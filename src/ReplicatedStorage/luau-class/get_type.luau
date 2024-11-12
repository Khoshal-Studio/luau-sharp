--!strict

------------------------------------------------------------------------------------------------------

local function GetType(arg: any): string
    local metatable = getmetatable(arg)

    if metatable and metatable.__type then
        return metatable.__type
    end

    return typeof(arg)
end

------------------------------------------------------------------------------------------------------

return GetType

------------------------------------------------------------------------------------------------------