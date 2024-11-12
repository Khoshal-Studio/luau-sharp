--!nonstrict

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
    -- Simple type tests
    {
        name = "List<number> validation",
        collection_type = "List<number>",
        tests = {
            {
                input = {1, 2, 3, 4, 5},
                expected = true,
                desc = "Valid number list"
            },
            {
                input = {1, "2", 3},
                expected = false,
                desc = "Invalid: mixed types"
            },
            {
                input = {a = 1, b = 2},
                expected = false,
                desc = "Invalid: dictionary structure"
            },
            {
                input = {},
                expected = true,
                desc = "Valid: empty list"
            }
        }
    },
    
    -- Nested list tests
    {
        name = "List<List<string>> validation",
        collection_type = "List<List<string>>",
        tests = {
            {
                input = {{"a", "b"}, {"c", "d"}, {"e"}},
                expected = true,
                desc = "Valid nested string lists"
            },
            {
                input = {{"a", 1}, {"b", "c"}},
                expected = false,
                desc = "Invalid: nested list contains number"
            },
            {
                input = {{"a", "b"}, "c"},
                expected = false,
                desc = "Invalid: mixed nested types"
            },
            {
                input = {{}},
                expected = true,
                desc = "Valid: list containing empty list"
            }
        }
    },

    -- Dictionary tests
    {
        name = "Dictionary<string, number> validation",
        collection_type = "Dictionary<string, number>",
        tests = {
            {
                input = {a = 1, b = 2, c = 3},
                expected = true,
                desc = "Valid string-number dictionary"
            },
            {
                input = {a = "1"},
                expected = false,
                desc = "Invalid: string value"
            },
            {
                input = {[1] = 1},
                expected = false,
                desc = "Invalid: number key"
            },
            {
                input = {},
                expected = true,
                desc = "Valid: empty dictionary"
            }
        }
    },

    -- Complex nested dictionary tests
    {
        name = "Dictionary<string, Dictionary<string, List<number>>> validation",
        collection_type = "Dictionary<string, Dictionary<string, List<number>>>",
        tests = {
            {
                input = {
                    a = {x = {1, 2, 3}, y = {4, 5}},
                    b = {z = {6, 7, 8}}
                },
                expected = true,
                desc = "Valid complex nested structure"
            },
            {
                input = {
                    a = {x = {1, "2", 3}},
                    b = {y = {4, 5}}
                },
                expected = false,
                desc = "Invalid: string in number list"
            },
            {
                input = {
                    a = {x = {1, 2}},
                    b = {[1] = {3, 4}}
                },
                expected = false,
                desc = "Invalid: number key in nested dictionary"
            },
            {
                input = {
                    a = {x = {1, 2}},
                    b = 5
                },
                expected = false,
                desc = "Invalid: primitive instead of dictionary"
            }
        }
    },

    -- Edge cases
    {
        name = "Edge Cases",
        collection_type = "List<List<Dictionary<string, number>>>",
        tests = {
            {
                input = {{}, {}, {}},
                expected = true,
                desc = "Valid: list of empty lists"
            },
            {
                input = {{
                    {a = 1, b = 2},
                    {c = 3}
                }},
                expected = true,
                desc = "Valid: complex nested structure"
            },
            {
                input = nil,
                expected = false,
                desc = "Invalid: nil input"
            },
            {
                input = "not a table",
                expected = false,
                desc = "Invalid: string input"
            }
        }
    }
}

---------------------------------------------------------------------------------------------------------------------------

local function test()
    print("Running collection validator Tests...")

    local total_tests = 0
    local passed_tests = 0

    local failed_tests: {[number]: {
        input: any,
        expected: boolean,
        desc: string,
        fail_type: "function_error" | "false_validation",
        error: string,
        error_message: string?
    }} = {}

    for _, category in test_values do
        print(format("\nTesting %s:", category.name))
        local validator = util.create_validator(category.collection_type)

        for i, test in category.tests do
            total_tests = total_tests + 1
            local success, err = pcall(function()
                local result, err_ = validator(test.input)

                return table.pack(result, err_)
            end)

            local result = if success then err[1] else false
            local err_ = err[2]

            if success then
                if result ~= test.expected then
                    table.insert(failed_tests, {
                        input = test.input,
                        expected = test.expected,
                        desc = test.desc,
                        fail_type = "false_validation",
                        error = if test.expected then "False negative" else "False positive",
                        error_message = tostring(err_)
                    })
                    print(format("  ✗ %s", test.desc))
                else
                    passed_tests = passed_tests + 1
                    print(format("  ✓ %s", test.desc))
                end
            else
                table.insert(failed_tests, {
                    input = test.input,
                    expected = test.expected,
                    desc = test.desc,
                    fail_type = "function_error",
                    error = tostring(err)
                })
                print(format("  ✗ %s", test.desc))
            end
        end
    end

    -- Print summary
    print(format("\nTest Summary: %d/%d tests passed (%.1f%%)", 
        passed_tests, 
        total_tests, 
        (passed_tests/total_tests) * 100
    ))

    if passed_tests == total_tests then
        game:GetService("TestService"):Message("All collection validator tests passed!")
    else
        warn(format("Collection validator tests failed: %d/%d tests passed", passed_tests, total_tests))
        print("\nFailed tests:")
        for i, test in ipairs(failed_tests) do
            print("Test #" .. i)
            print("  Description: " .. test.desc)
            print("  Input: " .. JsonEncode(test.input))
            print("  Expected: " .. tostring(test.expected))
            if test.fail_type == "false_validation" then
                print("  Got: " .. tostring(not test.expected))
                print("  Error Message: " .. tostring(test.error_message))
            end
            print("  Error: " .. test.error)
            print(" Fail type: " .. test.fail_type)
        end
    end
end

module.test = test

---------------------------------------------------------------------------------------------------------------------------

return module

---------------------------------------------------------------------------------------------------------------------------