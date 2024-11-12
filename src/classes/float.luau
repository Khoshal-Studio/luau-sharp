--!strict

------------------------------------------------------------------------------------------------------------------------------------------

type float = {
    Value: number,
    Equals: (number) -> boolean,
    LessThan: (number) -> boolean,
    LessThanOrEqual: (number) -> boolean,
    GreaterThan: (number) -> boolean,
    GreaterThanOrEqual: (number) -> boolean,
}

------------------------------------------------------------------------------------------------------------------------------------------

local new: (number) -> (float & number) = nil

local float = {
    __newindex = function(_, k, _): nil
        error("Attempt to index a " .. typeof(k) .. " with a float.", 2)
    end,

    __metatable = {
        __type = "float",
    },

    __tostring = function(a): string
        -- if no decimal part, add .0
        local x = a[1] :: number
        local has_decimal = x % 1 ~= 0

        return if has_decimal then
            tostring(x)
        else
            tostring(x) .. ".0"
    end,

    __add = function(a, b: number): number
        return new(a[1] :: number + b)
    end,

    __sub = function(a, b: number): number
        return new(a[1] :: number - b)
    end,

    __mul = function(a, b: number): number
        return new(a[1] :: number * b)
    end,

    __div = function(a, b: number): number
        return new(a[1] :: number / b)
    end,

    __idiv = function(a, b: number): number
        return new(a[1] :: number // b)
    end,

    __tonumber = function(a): number
        return a[1]
    end,

    __unm = function(a): number
        return new(-(a[1] :: number))
    end,

    __pow = function(a, b: number): number
        return new((a[1] :: number) ^ b)
    end,

    __mod = function(a, b: number): number
        return new((a[1] :: number) % b)
    end,

    __concat = function(a: number, b: number): string
        return tostring(a) .. tostring(b)
    end,

    __call = function(a): number
        return a[1] :: number
    end,
}

float.__index = float

float.Equals = function(a: number, b: number): boolean
    return a == b
end

float.LessThan = function(a: float, b: number): boolean
    return a.Value < b
end

float.LessThanOrEqual = function(a: number, b: number): boolean
    return a <= b
end

float.GreaterThan = function(a: number, b: number): boolean
    return a > b
end

float.GreaterThanOrEqual = function(a: number, b: number): boolean
    return a >= b
end

------------------------------------------------------------------------------------------------------------------------------------------

new =  function(a: number)
    return setmetatable({a}, float) :: any
end

------------------------------------------------------------------------------------------------------------------------------------------

return new

------------------------------------------------------------------------------------------------------------------------------------------