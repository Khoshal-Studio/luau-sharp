--!strict

--[=[=========================================================================================================================================]=]--

local module = {}

--[=[=========================================================================================================================================]=]--

local constants = require(script.Parent.Parent.constants)
local types = require(script.Parent.Parent.types)
local GetType = require(script.Parent.Parent.get_type)

local dependencies = script.Parent.Parent.dependencies
local t = require(dependencies.t)

--[=[=========================================================================================================================================]=]--

local format = string.format

--[=[=========================================================================================================================================]=]--

local function collection_type_match(collection_info: string | types.collection_info): string?
    assert(t.string(collection_info) or t.table(collection_info), format("Expected collection info to be a string or table, got: %s", GetType(collection_info)))

    if type(collection_info) == "table" then
        return constants.DATASTRUCTURE_TYPES[collection_info.collection_type] or nil
    end

    -- For string case, extract the outermost type
    for baseType, _ in constants.DATASTRUCTURE_TYPES do
        -- Simply match the type at the start followed by a 
        local match = collection_info:match("^" .. baseType .. "<")
        if match then
            return baseType
        end
    end

    return nil
end

local function is_collection_info(collection: types.collection_info | string): boolean
    assert(t.string(collection) or t.table(collection), format("Expected collection info to be a string or table, got: %s", GetType(collection)))

    return collection_type_match(collection) ~= nil
end

--[=[=========================================================================================================================================]=]--

local function collection_info(_collection: types.collection_info | string): (boolean, string?)
    assert(t.table(_collection) or t.string(_collection), format("Expected collection info to be a table or string, got: %s", GetType(_collection)))

    local collection = if type(_collection) == "string" then module.from_str(_collection) else _collection
    
    if not t.table(collection) then
        return false, "Expected collection info to be a table"
    end

    local collection_type = collection_type_match(collection)

    if not collection_type then
        return false, format("Unknown collection type, got: %s", tostring(collection.collection_type))
    end

    if type(collection.value_type) == "table" then
        if not collection_info(collection.value_type) then
            return false, format("Invalid value type, got: %s", tostring(collection.value_type))
        end
    elseif not t.string(collection.value_type) then
        return false, format("Invalid value type, got: %s", tostring(collection.value_type))
    end

    if (collection.index_type == nil) and (constants.NO_INDEX_TYPE_DATASTRUCTURES[collection_type] == nil) then
        return false, format("Expected index type to be present in collection info, got: %s", tostring(collection.index_type))
    end

    return true
end

local function assert_wrap_collection_info(collection: types.collection_info)
    local success, err = collection_info(collection)
    assert(success, err)
end

--[=[=========================================================================================================================================]=]--

module.to_str = (nil :: any) :: ((collection: types.collection_info) -> string?)

local collection_type_cases = {}

collection_type_cases.List = function(collection: types.collection_info)
    assert_wrap_collection_info(collection)

    --[[-----------------------------------------------------------------------------]]--

    local value_type = collection.value_type

    if type(value_type) == "table" then
        local result = module.to_str(value_type)

        if not result then
            error(format("Failed to convert value type to string, got: %s", tostring(value_type)))
        end

        value_type = result
    end

    --[[-----------------------------------------------------------------------------]]--

    return format("List<%s>", value_type :: string)
end

collection_type_cases.Dictionary = function(collection: types.collection_info)
    assert_wrap_collection_info(collection)

    --[[-----------------------------------------------------------------------------]]--
    
    local value_type = collection.value_type

    if type(value_type) == "table" then
        local result = module.to_str(value_type)

        if not result then
            error(format("Failed to convert value type to string, got: %s", tostring(value_type)))
        end

        value_type = result
    end

    --[[-----------------------------------------------------------------------------]]--

    return format("Dictionary<%s, %s>", collection.index_type :: string, value_type :: string)
end

----------------------------------------------------------------------------------------------------------------------

module.to_str = function(collection: types.collection_info): string?
    assert_wrap_collection_info(collection)

    --[[-----------------------------------------------------------------------------]]--

    local collection_type = collection.collection_type

    if collection_type_cases[collection_type] then
        return collection_type_cases[collection_type](collection)
    end

    --[[-----------------------------------------------------------------------------]]--
    
    return nil
end


--[=[=========================================================================================================================================]=]--

local from_str_cases = {}

from_str_cases.List = function(collection_info: string): types.collection_info

    local value_type = collection_info:match("<(.+)>")
    assert(value_type, format("Expected value type to be present in List info, got: %s", collection_info))

    --[[-----------------------------------------------------------------------------]]--

    --[[
        Example Input: List<string>
        value_type = string
    ]]

    --[[
        Example Input: List<List<string>>
        value_type = List<string>
    ]]

    --[[-----------------------------------------------------------------------------]]--

    local value_type_match = collection_type_match(value_type)

    if value_type_match then
        local collection_type = value_type_match
        
        if not collection_type then
            error(format("Unknown value collection type, got: %s", value_type))
        end
        
        value_type = from_str_cases[collection_type](value_type)
    end

    --[[-----------------------------------------------------------------------------]]--

    return {
        collection_type = "List",
        value_type = value_type,
        index_type = "number"
    }
end

from_str_cases.Dictionary = function(collection_info: string): types.collection_info
    assert(t.string(collection_info), format("Expected collection info to be a string, got: %s", GetType(collection_info)))

    --[[-----------------------------------------------------------------------------]]--

    local index_type = collection_info:match("<([^,>]+),")
    local value_type = collection_info:match(", (.+)>$")


    --[[-----------------------------------------------------------------------------]]--

    --[[
        Example Input: Dictionary<string, number>
        value_type = string
        index_type = number
    ]]

    --[[-----------------------------------------------------------------------------]]--

    assert(value_type, format("Expected value type to be present in Dictionary info, got: %s", collection_info))
    assert(index_type, format("Expected index type to be present in Dictionary info, got: %s", collection_info))

    --[[-----------------------------------------------------------------------------]]--

    local value_type_match = collection_type_match(value_type)

    if value_type_match then
        local collection_type = value_type_match
        
        if not collection_type then
            error(format("Unknown collection type, got: %s", value_type))
        end

        value_type = from_str_cases[collection_type](value_type)
    end

    --[[-----------------------------------------------------------------------------]]--

    return {
        collection_type = "Dictionary",
        value_type = value_type,
        index_type = index_type
    }
end

----------------------------------------------------------------------------------------------------------------------

module.from_str = function(info: string): types.collection_info
    local collection_type = collection_type_match(info)
    assert(collection_type, format("Unknown collection type, got: %s, from: %s", tostring(collection_type), tostring(info)))

    return from_str_cases[collection_type](info)
end

--[=[=========================================================================================================================================]=]--

module.create_validator = (nil :: any) :: ((info: types.collection_info | string) -> (any) -> (boolean, string?))

module.create_validator_cases = {}

module.create_validator_cases.List = function(info: types.collection_info)
    assert_wrap_collection_info(info)

    return function(list: {}): (boolean, string?)
        -- Check if input is a table
        if type(list) ~= "table" then
            return false, "Expected input to be a table, got: "..GetType(list)
        end

        for i in list do
            if type(i) ~= "number" then
                return false, format("Expected index to be a number, got: %s", GetType(i))
            end
        end



        -- Handle nested collection validation
        if type(info.value_type) == "table" then
            local nested_validator = module.create_validator(info.value_type)
            
            for _, value in list do
                local success, err = nested_validator(value)
                if not success then
                    return false, "Nested collection validation failed: "..tostring(err)
                end
            end
        elseif type(info.value_type) == "string" then
            -- Validate each element matches the specified type
            for _, value in list do
                if GetType(value) ~= info.value_type then
                    return false, format("Expected value to be of type %s, got: %s", info.value_type, GetType(value))
                end
            end
        end

        return true
    end
end

module.create_validator_cases.Dictionary = function(info: types.collection_info)
    assert_wrap_collection_info(info)
    assert(info.index_type, format("Expected index type to be present in collection info, got: %s", tostring(info.index_type)))

    return function(dict: {[any]: any}): boolean
        -- Check if input is a table
        if type(dict) ~= "table" then
            return false, "Expected input to be a table, got: "..GetType(dict)
        end

        print(info)

        -- Validate all keys match the index type
        for key in dict do
            if type(key) ~= info.index_type then
                return false, format("Expected key to be of type %s, got: %s", info.index_type, GetType(key))
            end
        end

        -- Handle nested collection validation for values
        if type(info.value_type) == "table" then
            local nested_validator = module.create_validator(info.value_type)
            
            -- Validate each value in the dictionary
            for _, value in dict do
                if not nested_validator(value) then
                    return false, "Nested collection validation failed"
                end
            end
        else
            -- Validate each value matches the specified type
            for _, value in dict do
                if type(value) ~= info.value_type then
                    return false, format("Expected value to be of type %s, got: %s", info.value_type, GetType(value))
                end
            end
        end

        return true
    end
end

module.create_validator = function(_info: types.collection_info | string): (any) -> boolean
    assert(t.table(_info) or t.string(_info), format("Expected collection info to be a table or string, got: %s", GetType(_info)))

    local info = if type(_info) == "string" then module.from_str(_info) else _info
    assert_wrap_collection_info(info)

    --[[-----------------------------------------------------------------------------]]--

    local collection_type = info.collection_type

    if module.create_validator_cases[collection_type] then
        return module.create_validator_cases[collection_type](info)
    else
        error(format("Unknown collection type, got: %s", tostring(collection_type)))
    end
end

module.is_collection_info = is_collection_info

module.valid_collection_info = collection_info

--[=[=========================================================================================================================================]=]--

return module

--[=[=========================================================================================================================================]=]--