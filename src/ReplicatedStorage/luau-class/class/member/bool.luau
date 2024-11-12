--!strict

---------------------------------------------------------------------------------------------------------------------

local member = require(script.Parent.member)
local util = require(script.Parent.Parent.Parent.util)

---------------------------------------------------------------------------------------------------------------------

local member_type = "boolean"
local assert_wrap = util.assert_wrap.bool

---------------------------------------------------------------------------------------------------------------------

return function(static_toggle: () -> boolean, access_modifier: number)
    return function(name: string)
        return function(value: boolean)
            assert_wrap(value)
            return member(access_modifier, member_type, name, value, static_toggle())
        end
    end
end

---------------------------------------------------------------------------------------------------------------------s