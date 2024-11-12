--!nonstrict

--[=[=========================================================================================================================================]=]--

local module = {}

--[=[=========================================================================================================================================]=]--

local dependencies = script.Parent.dependencies

local constants = require(script.Parent.constants)
local types = require(script.Parent.types)
local GetType = require(script.Parent.get_type)

local t = require(dependencies.t)

--[=[=========================================================================================================================================]=]--

local format = string.format

--[=[=========================================================================================================================================]=]--

local function tableToString(t): string
    local str = "{"
    for i, v in pairs(t) do
        if type(v) == "table" then
            str = str .. tableToString(v)
        else
            str = str .. tostring(v)
        end
        if i ~= #t then
            str = str .. ", "
        end
    end
    str = str .. "}"
    return str
end

--[=[=========================================================================================================================================]=]--

module.tableToString = tableToString

module.t = t

module.assert_wrap = {}

module.assert_wrap = {
    num = t.strict(t.number),
    str = t.strict(t.string),
    bool = t.strict(t.boolean),
    table = t.strict(t.table),
    userdata = t.strict(t.userdata),
    callback = t.strict(t.callback),
    thread = t.strict(t.thread),
    List = function(list: {}, list_type: string)
        for i, v in list do
            local index_type = typeof(i)

            if index_type ~= "number" then
                error(format("Expected index for list to be number, got type: %s", index_type))
            end

            local v_type = GetType(v)

            if v_type ~= list_type then
                error(format("Expected list value type to be %s, got type: %s", list_type, v_type))
            end
        end
    end
}

--[=[=========================================================================================================================================]=]--


return module

--[=[=========================================================================================================================================]=]--