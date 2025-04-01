--!strict

----------------------------------------------------------------------------------------------------------------------------------------

local module = {}

----------------------------------------------------------------------------------------------------------------------------------------

local Collection = require(script.Parent.Parent.Parent.class.Collection)

----------------------------------------------------------------------------------------------------------------------------------------

local function test()
    print("Running Queue Class Tests...")
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
        
        local queue = Collection.Queue.new("number")()
        assert_test(queue ~= nil, "Create Empty Queue", "Should create empty number queue")
        
        local queue_with_data = Collection.Queue.new("string")({"a", "b", "c"})
        assert_test(queue_with_data.Count == 3, "Create Queue With Data", "Should create queue with initial data")
        
        local success = pcall(function()
            Collection.Queue.new("number")({"a", "b", "c"})
        end)
        assert_test(not success, "Type Validation", "Should fail when creating queue with invalid types")
    end

    -- Basic Operations Tests
    do
        print("\nTesting Basic Operations:")
        
        local queue = Collection.Queue.new("number")()
        
        -- Enqueue
        queue:Enqueue(1)
        assert_test(queue.Count == 1, "Enqueue Single Item", "Count should be 1 after enqueuing item")
        assert_test(queue:Peek() == 1, "Peek First Item", "Should retrieve the first item")
        
        -- Enqueue Multiple Items
        queue:Enqueue(2)
        queue:Enqueue(3)
        queue:Enqueue(4)
        assert_test(queue.Count == 4, "Enqueue Multiple Items", "Count should increase after enqueuing multiple items")
        
        -- Contains
        assert_test(queue:Contains(2), "Contains Existing", "Should find existing item")
        assert_test(not queue:Contains(5), "Contains Non-existing", "Should not find non-existing item")
        
        -- Clear
        queue:Clear()
        assert_test(queue.Count == 0, "Clear", "Count should be 0 after clearing")
    end

    -- Dequeue Tests
    do
        print("\nTesting Dequeue:")
        
        local queue = Collection.Queue.new("number")({1, 2, 3})
        
        local dequeued = queue:Dequeue()
        assert_test(dequeued == 1, "Dequeue First Item", "Should dequeue the first item")
        assert_test(queue.Count == 2, "Count After Dequeue", "Count should decrease after dequeuing")
        
        -- Dequeue until empty
        queue:Dequeue()
        queue:Dequeue()
        assert_test(queue.Count == 0, "Dequeue to Empty", "Queue should be empty after dequeuing all items")
        
        local emptyDequeue = queue:Dequeue()
        assert_test(emptyDequeue == nil, "Dequeue Empty Queue", "Dequeue should return nil when queue is empty")
    end

    -- Peek Tests
    do
        print("\nTesting Peek:")
        
        local queue = Collection.Queue.new("string")({"a", "b", "c"})
        
        local peeked = queue:Peek()
        assert_test(peeked == "a", "Peek First Item", "Should peek the first item without removing it")
        assert_test(queue.Count == 3, "Count After Peek", "Count should remain same after peeking")
    end

    -- Find Operations Tests
    do
        print("\nTesting Find Operations:")
        
        local queue = Collection.Queue.new("number")({1, 2, 3, 4, 5, 3})
        
        -- Find
        local found = queue:Find(function(x) return x > 3 end)
        assert_test(found == 4, "Find", "Should find first number greater than 3")
        
        -- FindAll
        local all_greater = queue:FindAll(function(x) return x > 3 end)
        assert_test(all_greater.Count == 2, "FindAll", "Should find all numbers greater than 3")
    end

    -- Other Operations Tests
    do
        print("\nTesting Other Operations:")
        
        local queue = Collection.Queue.new("number")()
        assert_test(queue:IsEmpty(), "IsEmpty on Empty Queue", "Should be empty initially")

        queue:Enqueue(10)
        assert_test(not queue:IsEmpty(), "IsEmpty after Enqueue", "Should not be empty after enqueuing an item")

        -- PeekLast
        queue:Enqueue(20)
        assert_test(queue:PeekLast() == 20, "GetLast", "Should get the last item enqueued")

        -- ForEach
        local sum = 0
        queue:ForEach(function(x)
            sum += x
        end)
        assert_test(sum == 30, "ForEach", "Should correctly iterate over all items")
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
        game:GetService("TestService"):Message("All Queue class tests passed!")
    else
        warn(string.format("Queue class tests failed: %d/%d tests passed", passed_tests, total_tests))
    end
end

module.test = test

----------------------------------------------------------------------------------------------------------------------------------------

return module

----------------------------------------------------------------------------------------------------------------------------------------