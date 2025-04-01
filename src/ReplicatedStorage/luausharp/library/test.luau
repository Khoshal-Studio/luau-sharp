--!strict

local recursiveIndexer = require("index_arguments")
local MODIFIER_TREE = require("modifier_tree")

local function runTests()
    print("Running tests...")

    local successCount = 0
    local failCount = 0

    local function assertEqual(actual: any, expected: any, testName: string)
        if actual == expected then
            print(`✅ {testName} passed.`)
            successCount += 1
        else
            print(`❌ {testName} failed. Expected: {expected}, Got: {actual}`)
            failCount += 1
        end
    end

    local function assertError(fn: () -> (), expectedError: string, testName: string)
        local success, err = pcall(fn)
        if not success and string.find(err, expectedError) then
            print(`✅ {testName} passed.`)
            successCount += 1
        else
            print(`❌ {testName} failed. Expected error containing: '{expectedError}', but got: {err or "no error"}`)
            failCount += 1
        end
    end

    -- Create indexers
    local public = recursiveIndexer.new(function(key, chain: any)
        if MODIFIER_TREE.field.public[key] == nil then
            error(`Invalid modifier: {key} for public`)
        end
        chain[key] = true
        return false, setmetatable(chain, recursiveIndexer)
    end, { _access_modifier = "public" })

    local private = recursiveIndexer.new(function(key, chain: any)
        if MODIFIER_TREE.field.private[key] == nil then
            error(`Invalid modifier: {key} for private`)
        end
        chain[key] = true
        return false, setmetatable(chain, recursiveIndexer)
    end, { _access_modifier = "private" })

    -- 🟢 **Valid Combinations**
    local test1 = public.static
    assertEqual(test1.static, true, "Public static field should be valid")

    local test2 = private.static
    assertEqual(test2.static, true, "Private static field should be valid")

    -- 🛑 **Invalid Combinations**
    assertError(function()
        local _ = public.abstract
    end, "Invalid modifier", "Public abstract field should be invalid")

    assertError(function()
        local _ = private.virtual
    end, "Invalid modifier", "Private virtual field should be invalid")

    -- 🟢 **Recursive Indexing Works**
    local test3 = public.static
    assertEqual(test3._access_modifier, "public", "Public static field should retain access modifier")

    -- 🛑 **Duplicate Modifiers**
    assertError(function()
        local _ = public.static.static
    end, "Modifier already set", "Should not allow setting static twice")

    -- 🛑 **Conflicting Modifiers**
    assertError(function()
        local _ = public.static.abstract
    end, "Cannot set abstract on static", "Static and abstract should not coexist")

    -- 🛑 **Invalid Modifier Names**
    assertError(function()
        local _ = public.nonexistentModifier
    end, "Invalid modifier", "Using an invalid modifier should throw an error")

    -- Summary
    print(`Tests completed. {successCount} passed, {failCount} failed.`)
end

runTests()
