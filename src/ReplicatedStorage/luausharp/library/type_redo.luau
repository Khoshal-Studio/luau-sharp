--!strict

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
    Optional: {
        Value: boolean,
        Default: any
    }?
}

type Arguments = {
    [number]: Argument
}

type Callback = Type<"callback", {
    Arguments: Arguments
}>

type CompleteCallback = {
    Arguments: Arguments,
    Body: () -> ()
}

type OverloadMethod = {
    [number]: CompleteCallback
}

type AccessorType = "get" | "set"
type AccessModifier = "public" | "private" | "protected"

type Accessor<T = AccessorType> = {
    Type: T,
    AccessModifier: AccessModifier
}

type FieldConstructMember = {
    Type: Type,
    Name: string,
    AccessModifier: AccessModifier,
    Value: any
}

type MethodConstructMember = {
    Type: Callback,
    Name: string,
    AccessModifier: AccessModifier,
    Value: () -> ()
}

type AllMemberType = FieldConstructMember | MethodConstructMember

type number_field = (value: number?) -> FieldConstructMember
type string_field = (value: string?) -> FieldConstructMember
type boolean_field = (value: boolean?) -> FieldConstructMember
type table_field = (value: {}?) -> FieldConstructMember

type UnassignedValueFieldType = number_field | string_field | boolean_field | table_field


type Class = {
    ClassName: string,
    Members: {
        [string]: AllMemberType
    }
}

type UserClass<static_members> = static_members & {
    new : () -> {}
}

local base_types = {
    number = {
        TypeKind = "base",
        Value = "number",
        IsType = function(value: any): boolean
            return type(value) == "number"
        end
    },

    string = {
        TypeKind = "base",
        Value = "string",
        IsType = function(value: any): boolean
            return type(value) == "string"
        end
    },

    boolean = {
            TypeKind = "base",
            Value = "boolean",
            IsType = function(value: any): boolean
                return type(value) == "boolean"
            end
    },

    table = {
        TypeKind = "base",
        Value = "table",
        IsType = function(value: any): boolean
            return type(value) == "table"
        end
    },

    callback = {
        TypeKind = "base",
        Value = "function",
        IsType = function(value: any): boolean
            return type(value) == "function"
        end
    },

    void = {
        TypeKind = "base",
        Value = "nil",
        IsType = function(value: any): boolean
            return type(value) == "nil"
        end
    }
}

local no_value_provided = {}

local public = {
    number = function(name: string)
        return function(value: number?): FieldConstructMember
            return {
                Type = base_types.number,
                Name = name,
                AccessModifier = "public",
                Value = value or no_value_provided
            }
        end :: number_field
    end,

    string = function(name: string)
        return function(value: string?)
            return {
                Type = base_types.string,
                Name = name,
                AccessModifier = "public",
                Value = value or no_value_provided
            }
        end
    end,

    boolean = function(name: string)
        return function(value: boolean?)
            return {
                Type = base_types.boolean,
                Name = name,
                AccessModifier = "public",
                Value = value or no_value_provided
            }
        end
    end,

    table = function(name: string)
        return function(value: {}?)
            return {
                Type = base_types.table,
                Name = name,
                AccessModifier = "public",
                Value = value or no_value_provided
            } :: FieldConstructMember
        end
    end,

    void = function(name: string)
        return function(args: Arguments, body: () -> ())
            return {
                Type = {
                    TypeKind = "callback",
                    Value = {
                        Arguments = args
                    },
                    IsType = function(value: any): boolean
                        return type(value) == "function"
                    end
                },
                Name = name,
                AccessModifier = "public",
                Value = body
            } :: MethodConstructMember
        end
    end
}

local class_instance_data_store = {}

local class_store = {}

class_store.__index = class_store
class_store.__mode = "k"
setmetatable({}, class_store)

type ClassStoreEntry = {
    Object: Class,
    InheritingClasses: {
        [number]: string
    },
    UniqueID: any,
    Members: {
        AllMembers: {
            [string]: AllMemberType
        },
        MethodMembers: {
            [string]: MethodConstructMember
        },
        FieldMembers: {
            [string]: FieldConstructMember
        }
    }
}

local Reflection = {
    GetClass = function(class_name: string)
        return class_store[class_name]
    end,

    GetMethods = function(class_name: string)
        return class_store[class_name].Cache.MethodMembers
    end,

    GetFields = function(class_name: string)
        return class_store[class_name].Cache.FieldMembers
    end,

    GetMembers = function(class_name: string)
        return class_store[class_name].Cache.AllMembers
    end
}

local function class (class_name: string)--[[: (members: {
--     [number]: AllMemberType | UnassignedValueFieldType
    }) -> UserClass]]--
    return function (members: {
        [number]: AllMemberType | UnassignedValueFieldType
    }) --[[ : UserClass]]--
        local members: any = {}
        local inheriting_classes = {}
        -- this is here to see which classes are inheriting from this class and give them access to protected memberss
        local unique_id = newproxy()

        for i: number, v: (UnassignedValueFieldType | AllMemberType) in members do
            if typeof(v) == "function" then
                -- This means that the value was not assigned. This is only for fields.
                local v = (v :: any)() :: FieldConstructMember
                members[v.Name] = v
            else
                members[i] = v
            end
        end

        local object = {
            ClassName = class_name,
            Members = members,
            new = function()
                local instance = {}

                for i, v in members do
                    if v.Type.TypeKind == "base" then
                        instance[v.Name] = v.Value
                    end
                end

                local metatable = {
                    __index = function(self, key: string)
                        if instance[key].IsPrivate then
                            error("Attempt to access a private member")
                        end

                        if not instance[key] then
                            error("Attempt to access a value that does not exist in the class")
                        end

                        if instance[key].IsProtected then
                            local caller = debug.info(2, "f")
                            local is_inheriting = false

                            for i, v in inheriting_classes do
                                if v == caller then
                                    return instance[key]
                                end
                            end    

                        end

                        return instance[key]
                    end,

                    __newindex = function(self, key: string, value: any)
                        if not instance[key] then
                            error("Attempt to set a value that does not exist in the class")
                        end

                        local member = instance[key]
                    end
                }

                return instance
            end
        }

        class_store[unique_id] = {
            Object = object,
        }

        return object
    end
end

local myclass = class "MyClass" {
    public.number "MyNum";

    public.void "MyFunc" (
        {},

        function()
            print("Hello, world!")
        end
    );

    public.table "MyTable";
}