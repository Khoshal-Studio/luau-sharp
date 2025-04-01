--!strict

------------------------------------------------------------------------------------------------------------------------------------------

local module = {}

------------------------------------------------------------------------------------------------------------------------------------------

local Collection = require(script.Parent.Parent.Parent.class.Collection)

------------------------------------------------------------------------------------------------------------------------------------------

local function test()
    print("Running List Class Tests...")
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
        
        local list = Collection.List.new("number")()
        assert_test(list ~= nil, "Create Empty List", "Should create empty number list")
        
        local list_with_data = Collection.List.new("string")({"a", "b", "c"})
        assert_test(list_with_data.Count == 3, "Create List With Data", "Should create list with initial data")
        
        local success = pcall(function()
            Collection.List.new("number")({"a", "b", "c"})
        end)
        assert_test(not success, "Type Validation", "Should fail when creating list with invalid types")
    end

    -- Basic Operations Tests
    do
        print("\nTesting Basic Operations:")
        
        local list = Collection.List.new("number")()
        
        -- Add
        list:Add(1)
        assert_test(list.Count == 1, "Add Single Item", "Count should be 1 after adding item")
        assert_test(list:Get(1) == 1, "Get Item", "Should retrieve correct item")
        
        -- AddRange
        list:AddRange({2, 3, 4})
        assert_test(list.Count == 4, "Add Range", "Count should increase after adding range")
        
        -- Contains
        assert_test(list:Contains(2), "Contains Existing", "Should find existing item")
        assert_test(not list:Contains(5), "Contains Non-existing", "Should not find non-existing item")
        
        -- Clear
        list:Clear()
        assert_test(list.Count == 0, "Clear", "Count should be 0 after clearing")
    end

    -- Search Operations Tests
    do
        print("\nTesting Search Operations:")
        
        local list = Collection.List.new("number")({1, 2, 3, 4, 5, 3})
        
        -- Find
        local found = list:Find(function(x) return x > 3 end)
        assert_test(found == 4, "Find", "Should find first number greater than 3")
        
        -- FindAll
        local all_greater = list:FindAll(function(x) return x > 3 end)
        assert_test(all_greater.Count == 2, "FindAll", "Should find all numbers greater than 3")
        
        -- FindIndex
        local index = list:FindIndex(function(x) return x == 3 end)
        assert_test(index == 3, "FindIndex", "Should find correct index of first 3")
        
        -- LastIndexOf
        local last_index = list:LastIndexOf(3)
        assert_test(last_index == 6, "LastIndexOf", "Should find last occurrence of 3")
    end

    -- Modification Tests
    do
        print("\nTesting Modification Operations:")
        
        local list = Collection.List.new("string")({"a", "b", "c", "d"})
        
        -- Insert
        list:Insert("x", 2)
        assert_test(list:Get(2) == "x", "Insert", "Should insert at correct position")
        
        -- Remove
        list:Remove("x")
        assert_test(not list:Contains("x"), "Remove", "Should remove specified item")
        
        -- RemoveAt
        list:RemoveAt(2)
        assert_test(list.Count == 3, "RemoveAt", "Count should decrease after removal")
        
        -- Reverse
        list:Reverse()
        assert_test(list:GetFirst() == "d", "Reverse", "Should reverse list order")
    end

    -- Range Operations Tests
    do
        print("\nTesting Range Operations:")
        
        local list = Collection.List.new("number")({1, 2, 3, 4, 5})
        
        -- GetRange
        local range = list:GetRange(2, 4)
        assert_test(range.Count == 3, "GetRange Count", "Should get correct range size")
        assert_test(range:GetFirst() == 2, "GetRange Start", "Should get correct range start")
        assert_test(range:GetLast() == 4, "GetRange End", "Should get correct range end")
        
        -- RemoveRangeAt
        print(list.Count)
        list:RemoveRangeAt(2, 3)
        print(list.Count)
        assert_test(list.Count == 3, "RemoveRange", "Count should decrease after range removal")
    end

    -- Aggregate Operations Tests
    do
        print("\nTesting Aggregate Operations:")
        
        local list = Collection.List.new("number")({1, 2, 3, 4, 5})
        
        -- Sum
        local sum = list:Sum(function(acc, x) return x end)
        assert_test(sum == 15, "Sum", "Should calculate correct sum")
        
        -- Average
        local avg = list:Average(function(acc, x) return x end)
        assert_test(avg == 3, "Average", "Should calculate correct average")
        
        -- Max
        local max = list:Max(function(acc, x) return x end)
        assert_test(max == 5, "Max", "Should find maximum value")
        
        -- Min
        local min = list:Min(function(acc, x) return x end)
        assert_test(min == 1, "Min", "Should find minimum value")
    end

    -- Print summary
    print(string.format("\nTest Summary: %d/%d tests passed (%.1f%%)", 
        passed_tests, 
        total_tests, 
        (passed_tests/total_tests) * 100
    ))

    if #failed_tests > 0 then
        print("\nFailed tests:")
        for _, test in ipairs(failed_tests) do
            print(string.format("- %s: %s", test.name, test.description))
        end
    end

    if passed_tests == total_tests then
        game:GetService("TestService"):Message("All List class tests passed!")
    else
        warn(string.format("List class tests failed: %d/%d tests passed", passed_tests, total_tests))
    end
end

module.test = test

------------------------------------------------------------------------------------------------------------------------------------------

return module

------------------------------------------------------------------------------------------------------------------------------------------