--!strict

--------------------------------------------------------------------------------------------------------------------------------

local module = {}

--------------------------------------------------------------------------------------------------------------------------------

local Collection = require(script.Parent.Parent.Parent.class.Collection)
local types = require(script.Parent.Parent.Parent.types)

--------------------------------------------------------------------------------------------------------------------------------

local function test()
    print("Running Dictionary Class Tests...")
    local total_tests = 0
    local passed_tests = 0
    local failed_tests = {}

    local function assert_test(condition: boolean, test_name: string, description: string)
        total_tests += 1
        if condition then
            passed_tests += 1
            print(string.format("  ✓ %s", test_name))
        else
            table.insert(failed_tests, {
                name = test_name,
                description = description
            })
            print(string.format("  ✗ %s: %s", test_name, description))
        end
    end

    -- Constructor Tests
    do
        print("\nTesting Constructor:")
        
        local dict = Collection.Dictionary.new("number", "string")()
        assert_test(dict ~= nil, "Create Empty Dictionary", "Should create empty number to string dictionary")
        
        local dict_with_data = Collection.Dictionary.new("string", "number")({a = 1, b = 2, c = 3})
        assert_test(dict_with_data.Count == 3, "Create Dictionary With Data", "Should create dictionary with initial data")

        local success = pcall(function()
            Collection.Dictionary.new("number", "string")({[1] = "one", [2] = 2 :: any})
        end)

        assert_test(not success, "Type Validation", "Should fail when creating dictionary with invalid types")
    end

    -- Basic Operations Tests
    do
        print("\nTesting Basic Operations:")
        
        local dict = Collection.Dictionary.new("string", "number")()
        
        -- Set
        dict:Set("a", 1)
        assert_test(dict.Count == 1, "Add Single Item", "Count should be 1 after adding item")
        
        -- Get
        local value = dict:Get("a")
        assert_test(value == 1, "Get Item", "Should retrieve the correct value")
        
        -- Remove
        dict:Remove("a")
        assert_test(dict.Count == 0, "Remove Item", "Count should be 0 after removing item")
        
        -- ContainsKey
        dict:Set("b", 2)
        assert_test(dict:ContainsKey("b"), "Contains Key", "Should contain key 'b'")
        
        -- ContainsValue
        assert_test(dict:ContainsValue(2), "Contains Value", "Should contain value 2")
    end

    -- Iteration Tests
    do
        print("\nTesting Iteration:")
        
        local dict: types.Dictionary<string, number>  = Collection.Dictionary.new("string", "number")({a = 1, b = 2, c = 3})
        dict:Set("d", 0)
        local sum = 0

        dict:ForEach(function(key, value)
            sum += value
        end)

        assert_test(sum == 6, "Iterate Over Items", "Sum should be 6 after iterating")
    end

    -- Equality Tests
    do
        print("\nTesting Equality:")
        
        local dict1 = Collection.Dictionary.new("string", "number")({a = 1, b = 2})
        local dict2 = Collection.Dictionary.new("string", "number")({a = 1, b = 2})
        local dict3 = Collection.Dictionary.new("string", "number")({a = 1, b = 3})
        
        assert_test(dict1 == dict2, "Equal Dictionaries", "Dictionaries should be equal")
        assert_test(dict1 ~= dict3, "Unequal Dictionaries", "Dictionaries should not be equal")
    end

    -- Type Tests
    do
        print("\nTesting Type:")
        
        local dict = Collection.Dictionary.new("number", "string")()
        assert_test(dict:GetType() == "Dictionary<number, string>", "Get Type", "Should return correct type")
    end

    -- Final Results
    print("\nTest Results:")
    print(string.format("  Passed %d out of %d tests.", passed_tests, total_tests))
    if #failed_tests > 0 then
        print("\nFailed Tests:")
        for _, test in ipairs(failed_tests) do
            print(string.format("  ✗ %s: %s", test.name, test.description))
        end
    end
end

test()

--------------------------------------------------------------------------------------------------------------------------------

return module