--!strict

local old_type = type

local type = {}

type TypeKind = 
    "union" |
    "intersection" |
    "indexer" |
    "callback" |
    "literal" |
    "base"

type Type<T=TypeKind, K=any> = {
    TypeKind: T,
    Value: K,
    IsType: (value: any) -> boolean
}

type base_types = "string" | "number" | "boolean" | "table" | "function" | "thread" | "userdata" | "nil" | "any"

type Base = Type<"base", base_types>

type Indexer<T, K> = Type<"indexer", {
    Key: T,
    Value: K
}>

type Union = Type<"union", {
    [number]: Type
}>

type Intersection = Type<"intersection", {
    [number]: Type
}>

type Argument = {
    Type: Type,
    Required: boolean
}

type Arguments = {
    [number]: Argument
}

type Callback = Type<"callback", {
    Arguments: Arguments
}>

type AccessorType = "get" | "set"
type AccessModifier = "public" | "private" | "protected"

type Accessor<T = AccessorType> = {
    Type: T,
    AccessModifier: AccessModifier
}

type MemberRoot<T, K> = T & {
    MemberType: K
}


type PropertyType = "virtual" | "abstract" | "default"
type Immutability = "readonly" | "const" | "mutable"

type Field = MemberRoot<{
    Name: string,
    Type: Type,
    Sealed: boolean,
    Immutability: Immutability,
    Static: boolean
}, "field">

type Property = MemberRoot<{
    Name: string,
    Type: Type,
    Accessors: {[number]: Accessor},

    PropertyType: PropertyType,
    Sealed: boolean,
    Immutability: Immutability,
    Static: boolean
}, "property">

type CallbackMember = MemberRoot<{
    Type: Type,
}, "callback">

type AllMembers = Property | CallbackMember | Field

type interface = {
    Properties: {[number]: Property},
    Methods: {[number]: CallbackMember},
    Fields: {[number]: Field},

    GetMembers: () -> {[number]: AllMembers}
}

type Interface = Type<"interface", interface>

type Literal = Type<"literal", string | number | boolean>

type Class = {
    Name: string,

    Members: {[number]: AllMembers},
    StaticMembers: {[number]: AllMembers},
    InstanceMembers: {[number]: AllMembers},
    -- cached values

    Properties: {[number]: Property},
    Methods: {[number]: CallbackMember},
    Fields: {[number]: Field},
    -- these are cached values

    InheritanceTree: {[number]: Class},
    Interfaces: {[number]: Interface},
    -- last class is reference to the class itself
    -- interfaces are not included in inheritance tree

    ClassType: PropertyType,
    Sealed: boolean,
    Static: boolean,
}

type AllTypes<T, K> = Union | Intersection | Indexer<T, K> | Callback | Literal | Base | Interface
local function indexer(key: any, value: any): Indexer<any, any>
    return {
        TypeKind = "indexer",
        Value = {
            Key = key,
            Value = value
        },
        IsType = function(value: any): boolean
            if old_type(value) == "table" then
                for k, v in pairs(value) do
                    if not key.IsType(k) or not value.IsType(v) then
                        return true
                    end
                end
            end

            return false
        end
    }
end

local function union(...): Union
    local types = {...}

    return {
        TypeKind = "union",
        Value = {...},
        IsType = function(value: any): boolean
            for i, type_ in types do
                if type_.IsType(value) then
                    return true
                end
            end

            return false
        end
    }
end

local function intersection(...): Intersection
    local types = {...}

    return {
        TypeKind = "intersection",
        Value = types,
        IsType = function(value): boolean
            for i, type_ in types do
                if not type_.IsType(value) then
                    return false
                end
            end

            return true
        end
    }
end

local function required_count(arguments: Arguments): number
    local count = 0

    for _, arg in arguments do
        if arg.Required then
            count += 1
        end
    end

    return count
end

local function callback(arguments: Arguments): Callback
    return {
        TypeKind = "callback",
        Value = {
            Arguments = arguments
        },
        IsType = function(args: {any}): boolean
            local required_count = required_count(arguments)

            if #args < required_count then
                return false
            end

            if #args > #arguments then
                return false
            end

            for i, arg in ipairs(arguments) do
                if not arg.Type.IsType(args[i]) then
                    return false
                end
            end

            return true
        end
    }
end

local function literal(value: string | number | boolean): Literal
    return {
        TypeKind = "literal",
        Value = value,
        IsType = function(value: any): boolean
            return value == value
        end
    }
end

local function base(value: base_types): Base
    return {
        TypeKind = "base",
        Value = value,
        IsType = function(value: any): boolean
            return old_type(value) == value
        end
    }
end

local public: {get: {Type: "get", AccessModifier: "public"}, set: {Type: "set", AccessModifier: "public"}} = {
    get = {
        Type = "get",
        AccessModifier = "public"
    },

    set = {
        Type = "set",
        AccessModifier = "public"
    }
}

local private: {get: {Type: "get", AccessModifier: "private"}, set: {Type: "set", AccessModifier: "private"}} = {
    get = {
        Type = "get",
        AccessModifier = "private"
    },

    set = {
        Type = "set",
        AccessModifier = "private"
    }
}

local function bool_fallback(value: boolean?): boolean
    if value == nil then
        return false
    end

    return value
end

local function property<static>(
        name: string,
        type: AllTypes<any, any>,
        property_type: PropertyType?,
        sealed: boolean?,
        immutability: Immutability?,
        static: boolean?,
        get: AccessModifier?,
        set: AccessModifier?
    ): Property
    
    return {
        Name = name,
        Type = type,
        Accessors = (function()
            local accessors = {}
            if get then
                table.insert(accessors, { Type = "get", AccessModifier = get })
            end
            if set then
                table.insert(accessors, { Type = "set", AccessModifier = set })
            end
            return accessors
        end)(),
        PropertyType = property_type or "default" :: PropertyType,
        Sealed = bool_fallback(sealed),
        Immutability = immutability or "mutable" :: Immutability,
        Static = bool_fallback(static),
        MemberType = "property" :: "property",
    }
end

local function switch_case(value: any, cases: {[any]: () -> any}): any
    for case, func in pairs(cases) do
        if value == case then
            return func()
        end
    end

    return nil
end

-- local function interface(members: {[number] : AllMembers}): Interface
--     local properties = {}
--     local methods = {}
--     local fields: {[number]: Field}= {}

--     for _, member in pairs(members) do
--         switch_case(member.MemberType, {
--             property = function()
--                 table.insert(properties, member)

--                 return nil
--             end,

--             callback = function()
--                 table.insert(methods, member)

--                 return nil
--             end,

--             field = function()
                

--                 return nil
--             end
--         })

--         if member.MemberType == "property" then
--             if member.Static then
--                 error("Static properties are not allowed in interfaces")
--             end
--             table.insert(properties, member)
--         elseif member.MemberType == "callback" then
--             table.insert(methods, member)
--         elseif member.MemberType == "field" then
--             error("Fields are not allowed in interfaces")
--         end
--     end

--     return {
--         TypeKind = "interface",
--         Value = {
--             Properties = properties,
--             Methods = methods,
--             Fields = fields,
--             GetMembers = function()
--                 return members
--             end
--         },

--         IsType = function(value: Class): boolean
--             for key, member in pairs(members) do
--                 if not member.Type.IsType(value[key]) then
--                     return false
--                 end
--             end

--             return true
--         end
--     }
-- end

-- local y = interface {
--     property("Name", literal("string"), "default", false, "mutable", false, "public", nil)
-- }

-- return {
--     type = type,
--     indexer = indexer,
--     union = union,
--     intersection = intersection,
--     callback = callback,
--     literal = literal,
--     base = base,
--     public = public,
--     private = private,
--     property = property,
--     interface = interface,
--     y = y
-- }