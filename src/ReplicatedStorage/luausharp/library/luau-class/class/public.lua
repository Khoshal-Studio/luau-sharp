local types = require(script.Parent.Parent:WaitForChild("types"))

local public = {}
local classes = {}
local public_meta = {}

local enum = {
    public = 1,
    private = 2,
    protected = 3,
}

local static_toggle = false

local function member(access_enum: number, datatype: string, name: string, value: any, static: boolean)
    return {access_enum, "member", name, value, static}
end

public.str = function(name: string)
    return function(value: string)
        return member(enum.public, "string", name, value, static_toggle)
    end
end

public.List = function(list_type: string)
    return function(name: string)
        return function(value: any)
            return member(enum.public, string.format("List<%s>", list_type), name, value, static_toggle)
        end 
    end
end

public.Dictionary = function(dictionary_type: string)
    return function(name: string)
        return function(value: any)
            return member(enum.public, string.format("Dictionary<%s>", dictionary_type), name, value, static_toggle)
        end 
    end
end

public.num = function(name: string)
    return function(value: number)
        return member(enum.public, "number", name, value, static_toggle)
    end
end

public.bool = function(name: string)
    return function(value: boolean)
        return member(enum.public, "boolean", name, value, static_toggle)
    end
end

local static_meta = {}
static_meta.__index = function(self, key)
    if public[key] then
        static_toggle = true
        return public[key]
    end

    return nil
end

static = setmetatable({}, static_meta)

public_meta.__index = function(self, key)    
    if key == "static" then
        static_toggle = true
        return static
    else
        static_toggle = false
    end

    if public[key] then
        return public[key]
    elseif classes[key] then
        return function(...)
            return classes[key](...)
        end
    end

    return public[key]
end

public = setmetatable(public, public_meta)

local public: typeof(public) & types.member_interface & {static: typeof(public)} = public :: any


return public