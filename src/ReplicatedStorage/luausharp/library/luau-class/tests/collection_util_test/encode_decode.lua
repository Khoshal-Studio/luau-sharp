---------------------------------------------------------------------------------------------------------------------------

local module = {}

---------------------------------------------------------------------------------------------------------------------------

local HttpService = game:GetService("HttpService")

---------------------------------------------------------------------------------------------------------------------------

local util = require(script.Parent.Parent.Parent.util.collection)

---------------------------------------------------------------------------------------------------------------------------

local JsonEncode = function(value: any): string
    return HttpService:JSONEncode(value)
end
local format = string.format

local function equal(a: any, b: any): boolean
    if (type(a) ~= type(b)) then
        return false
    end

    if (type(a) == "table" and type(b) ==  "table") then
        for i, v in a do
            if (not equal(v, b[i])) then
                return false
            end
        end

        return true
    end

    return a == b
end

---------------------------------------------------------------------------------------------------------------------------

local test_values = {
    {
        a = {
            collection_type = "List",
            value_type = "number",
            index_type = "number"
        },
        q = "List<number>"
    },

    {
        a = {
            collection_type = "List",
            value_type = {
                collection_type = "List",
                value_type = "string",
                index_type = "number"
            },
            index_type = "number"
        },
        q = "List<List<string>>"
    },

    {
        a = {
            collection_type = "Dictionary",
            value_type = "number",
            index_type = "string"
        },
        q = "Dictionary<string, number>"
    },

    {
        a = {
            collection_type = "Dictionary",
            value_type = {
                collection_type = "List",
                value_type = "number",
                index_type = "number"
            },
            index_type = "string"
        },
        q = "Dictionary<string, List<number>>"
    },

    {
        a = {
            collection_type = "Dictionary",
            value_type = {
                collection_type = "Dictionary",
                value_type = "number",
                index_type = "string"
            },
            index_type = "string"
        },
        q = "Dictionary<string, Dictionary<string, number>>"
    },

    {
        a = {
            collection_type = "Dictionary",
            value_type = {
                collection_type = "Dictionary",
                value_type = {
                    collection_type = "List",
                    value_type = "number",
                    index_type = "number"
                },
                index_type = "string"
            },
            index_type = "string"
        },
        q = "Dictionary<string, Dictionary<string, List<number>>>"
    },
    {
        q = "List<number>",
        a = {
            collection_type = "List",
            value_type = "number",
            index_type = "number"
        }
    },

    {
        q = "List<List<string>>",
        a = {
            collection_type = "List",
            value_type = {
                collection_type = "List",
                value_type = "string",
                index_type = "number"
            },
            index_type = "number"
        }
    },

    {
        q = "Dictionary<string, number>",
        a = {
            collection_type = "Dictionary",
            value_type = "number",
            index_type = "string"
        }
    },

    {
        q = "Dictionary<string, List<number>>",
        a = {
            collection_type = "Dictionary",
            value_type = {
                collection_type = "List",
                value_type = "number",
                index_type = "number"
            },
            index_type = "string"
        }
    },

    {
        q = "Dictionary<string, Dictionary<string, number>>",
        a = {
            collection_type = "Dictionary",
            value_type = {
                collection_type = "Dictionary",
                value_type = "number",
                index_type = "string"
            },
            index_type = "string"
        }
    },

    {
        q = "Dictionary<string, Dictionary<string, List<number>>>",
        a = {
            collection_type = "Dictionary",
            value_type = {
                collection_type = "Dictionary",
                value_type = {
                    collection_type = "List",
                    value_type = "number",
                    index_type = "number"
                },
                index_type = "string"
            },
            index_type = "string"
        }
    },
}

---------------------------------------------------------------------------------------------------------------------------

local function encode_test()
    print("Running encode tests...")

    for i, test in ipairs(test_values) do
        local result = util.from_str(test.q)
    
        if (not equal(result.collection_type, test.a.collection_type)) then
            error(format("Encode test #%d failed. Collection type mismatch, \n\nGot:\n\n" .. JsonEncode(result.collection_type) .. "\n\nExpected:\n\n" .. JsonEncode(test.a.collection_type), i))
        end
    
        if (not equal(result.value_type, test.a.value_type)) then
            error(format("Encode test #%d failed. Value type mismatch, \n\nGot:\n\n" .. JsonEncode(result.value_type) .. "\n\nExpected:\n\n" .. JsonEncode(test.a.value_type), i))
        end
    
        if (not equal(result.index_type, test.a.index_type)) then
            error(format("Encode test #%d failed. Index type mismatch, \n\nGot:\n\n" .. JsonEncode(result.index_type) .. "\n\nExpected:\n\n" .. JsonEncode(test.a.index_type), i))
        end
    end
    
    game:GetService("TestService"):Message("Encode tests passed") 
end

local function decode_test()
    print("Running decode tests...")

    for i, test in ipairs(test_values) do
        local result = util.to_str(test.a)
    
        if (result ~= test.q) then
            error(format("Decode test #%d failed, Got: " .. result .. " Expected: " .. test.q, i))
        end
    end
    
    game:GetService("TestService"):Message("Decode tests passed") 
end

---------------------------------------------------------------------------------------------------------------------------

module.encode_test = encode_test
module.decode_test = decode_test

---------------------------------------------------------------------------------------------------------------------------

return module

---------------------------------------------------------------------------------------------------------------------------
