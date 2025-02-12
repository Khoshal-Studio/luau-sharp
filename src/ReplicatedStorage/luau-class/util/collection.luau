--!strict

--[=[=========================================================================================================================================]=]--

local module = {}

--[=[=========================================================================================================================================]=]--


local constants = require(script.Parent.Parent.constants)
local types = require(script.Parent.Parent.types)
local GetType = require(script.Parent.Parent.get_type)

local dependencies = script.Parent.Parent.dependencies
local t = require(dependencies.t)
local Collection: any = script.Parent.Parent.class.Collection

--[=[=========================================================================================================================================]=]--

local format = string.format

--[=[=========================================================================================================================================]=]--

local function collection_type_match(collection_info: string | types.collection_info): string?
    assert(t.string(collection_info) or t.table(collection_info), format("Expected collection info to be a string or table, got: %s", GetType(collection_info)))

    if type(collection_info) == "table" then
        return collection_info.collection_type
    end

    for baseType, _ in constants.DATASTRUCTURE_TYPES do
        local match = collection_info:match("^" .. baseType .. "<")
        if match then
            return baseType
        end
    end

    return nil
end

local function extract_collection_args(collection_info: string): {string}
    assert(t.string(collection_info), format("Expected collection info to be a string, got: %s", GetType(collection_info)))

    local match = collection_info:match("<(.+)>")
    if not match then
        error(format("Failed to extract collection arguments from: %s", collection_info))
    end

    local split = match:split(",")

    return split
end

local function is_collection_info(collection: types.collection_info | string): (boolean, string?)
    assert(t.string(collection) or t.table(collection), format("Expected collection info to be a string or table, got: %s", GetType(collection)))

    local match = collection_type_match(collection)

    return match ~= nil, match
end

--[=[=========================================================================================================================================]=]--

local function collection_info(_collection: types.collection_info | string): (boolean, string?)
    assert(t.table(_collection) or t.string(_collection), format("Expected collection info to be a table or string, got: %s", GetType(_collection)))

    local collection = if type(_collection) == "string" then module.from_str(_collection) else _collection
    
    if not t.table(collection) then
        return false, "Expected collection info to be a table"
    end

    local index_type = collection.index_type
    local value_type = collection.value_type

    local collection_type = collection_type_match(collection)

    if not collection_type then
        return false, format("Unknown collection type, got: %s", tostring(collection.collection_type))
    end

    if type(value_type) == "table" then
        local success, err = collection_info(value_type)
        if not success then
            return false, format("Expected a valid collection type for the value type, got: %s\n Error: %s", tostring(value_type), tostring(err))
        end
    elseif not t.string(value_type) then
        return false, format("Expected value type to be a string, got: %s", type(value_type))
    end

    if (collection.index_type == nil) and (constants.NO_INDEX_TYPE_DATASTRUCTURES[collection_type] == nil) then
        return false, format("Expected index type to be present in collection info, got: %s", tostring(collection.index_type))
    end

    local is_collection, index_collection_type = is_collection_info(index_type :: any)

    if is_collection and collection_type and not constants.IMMUTABLE_DATASTRUCTURES[index_collection_type] then
        return false, format("Invalid index type. Index types for collections can only be immutable, got type: %s", tostring(index_type))
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
    local args = extract_collection_args(collection_info)

    if #args ~= constants.DATASTRUCTURE_ARG_COUNT.List then
        error(format("Expected %d argument(s) for List, got: %d", constants.DATASTRUCTURE_ARG_COUNT.List, #args))
    end

    local value_type = args[1]

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

from_str_cases.Queue = function(collection_info: string): types.collection_info
    local args = extract_collection_args(collection_info)

    if #args ~= constants.DATASTRUCTURE_ARG_COUNT.List then
        error(format("Expected %d argument(s) for Queue, got: %d", constants.DATASTRUCTURE_ARG_COUNT.List, #args))
    end

    local value_type = args[1]

    assert(value_type, format("Expected value type to be present in Queue info, got: %s", collection_info))

    --[[-----------------------------------------------------------------------------]]--

    --[[
        Example Input: Queue<string>
        value_type = string
    ]]

    --[[
        Example Input: Queue<List<string>>
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
        collection_type = "Queue",
        value_type = value_type,
        index_type = "number"
    }
end

from_str_cases.Dictionary = function(collection_info: string): types.collection_info
    assert(t.string(collection_info), format("Expected collection info to be a string, got: %s", GetType(collection_info)))

    --[[-----------------------------------------------------------------------------]]--

    local args = extract_collection_args(collection_info)

    if #args ~= constants.DATASTRUCTURE_ARG_COUNT.Dictionary then
        error(format("Expected %d argument(s) for Dictionary, got: %d", constants.DATASTRUCTURE_ARG_COUNT.Dictionary, #args))
    end

    local index_type = args[1]
    local value_type = args[2]

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
            return false, "Expected input to be a table, got: "..type(list)
        end

        for i in list do
            if type(i) ~= "number" then
                return false, format("Expected index to be a number, got: %s", type(i))
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
                local value_type = GetType(value)

                if value_type ~= info.value_type then
                    return false, format("Expected value to be of type %s, got: %s", info.value_type, GetType(value))
                end
            end
        end

        return true
    end
end

module.create_validator_cases.Queue = module.create_validator_cases.List

module.create_validator_cases.Dictionary = function(info: types.collection_info)
    assert_wrap_collection_info(info)
    assert(info.index_type, format("Expected index type to be present in collection info, got: %s", tostring(info.index_type)))

    local value_type = info.value_type
    local index_type = info.index_type

    return function(dict: {[any]: any}): boolean
        if type(dict) ~= "table" then
            return false, "Expected input to be a table, got: "..type(dict)
        end

        for key in dict do
            local key_type = GetType(key)
            if key_type ~= index_type then
                return false, format("Expected key to be of type %s, got: %s", index_type, GetType(key))
            end
        end

        if type(value_type) == "table" then
            local nested_validator = module.create_validator(value_type)
            for _, value in dict do
                if not nested_validator(value) then
                    return false, "Nested collection validation failed"
                end
            end
        else
            for _, value in dict do
                if type(value) ~= value_type then
                    return false, format("Expected value to be of type %s, got: %s", value_type, GetType(value))
                end
            end
        end

        return true
    end
end

module.create_validator = function(_info: types.collection_info | string): (any) -> boolean
    assert(t.table(_info) or t.string(_info), format("Expected collection info to be a table or string, got: %s", type(_info)))

    local info = if type(_info) == "string" then
        module.from_str(_info)
    else
        (function()
            assert_wrap_collection_info(_info) 
            return _info end
        )()
    

    --[[-----------------------------------------------------------------------------]]--

    local collection_type = info.collection_type

    if module.create_validator_cases[collection_type] then
        return module.create_validator_cases[collection_type](info)
    else
        error(format("Unknown collection type, got: %s", tostring(collection_type)))
    end
end

module.len = function(collection: {}): number
    assert(type(collection) == "table", format("Expected collection to be a table, got: %s", type(collection)))

    local count = 0

    for _ in collection do
        count += 1
    end

    return count
end

module.list_start_from_one = function(list: any, recursive: boolean?)
    assert(type(list) == "table", format("Expected list to be a table, got: %s", type(list)))

    local new_list = {}

    local count = 0

    for i, v in list do
        count += 1

        if recursive and type(v) == "table" then
            new_list[count] = module.list_start_from_one(v, true)
        else
            new_list[count] = v
        end
    end

    return new_list
end

module.new_collection = function(collection_root_type: string, data: {}): any
    if type(collection_root_type) ~= "string" then
        error("Expected string, got: "..type(collection_root_type), 2)
    end

    if not constants.DATASTRUCTURE_TYPES[collection_root_type] then
        error("Unknown collection type, got: "..collection_root_type, 2)
    end

    if type(t) ~= "table" then
        error("Expected table, got: "..type(t), 2)
    end

    if typeof(Collection) == "Instance" then
        Collection = require(Collection) :: any
    end

    return Collection[collection_root_type].new(data)
end

module.equals = function<A, B>(a: A, b: B): boolean
    if type(a) ~= type(b) then
        return false
    end

    if type(a) == "table" and type(b) == "table" then
        if module.len(a) ~= module.len(b) then
            return false
        end

        for k, v in a do
            if not module.equals(v, b[k]) then
                return false
            end
        end

        return true
    end

    return a == b
end

module.is_collection_info = is_collection_info

module.valid_collection_info = collection_info

--[=[=========================================================================================================================================]=]--

return module

--[=[=========================================================================================================================================]=]--