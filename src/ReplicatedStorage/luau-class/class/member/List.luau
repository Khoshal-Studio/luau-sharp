--!strict

---------------------------------------------------------------------------------------------------------------------

local member = require(script.Parent.member)
local util = require(script.Parent.Parent.Parent.util)
---------------------------------------------------------------------------------------------------------------------

local member_type = "List<%s>"
local assert_wrap = util.assert_wrap.List
local format = string.format

---------------------------------------------------------------------------------------------------------------------

return function(static_toggle: () -> boolean, access_modifier: number)
    return function(list_type: string)
        return function(name: string)
            return function<T>(value: {[number] : T})
                assert_wrap(value)
                return member(access_modifier, format(member_type, list_type), name, value, static_toggle())
            end
        end 
    end
end

---------------------------------------------------------------------------------------------------------------------