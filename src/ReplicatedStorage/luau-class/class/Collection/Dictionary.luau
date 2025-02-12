--!strict

----------------------------------------------------------------------------------------------------------------------------

local collection_util = require(script.Parent.Parent.Parent.util.collection)
local types = require(script.Parent.Parent.Parent.types)
local GetType = require(script.Parent.Parent.Parent.get_type)

----------------------------------------------------------------------------------------------------------------------------

local format = string.format

----------------------------------------------------------------------------------------------------------------------------

local hashset = (setmetatable({}, {__mode = "k"}) :: any)

----------------------------------------------------------------------------------------------------------------------------

local Dictionary = {}

local index_cases = {
    Count = function(self)
        return hashset[self].__count
    end,

    Length = function(self)
        return hashset[self].__count
    end,

    Values = function(self)
        local values = {}

        for k, v in hashset[self].__data do
            table.insert(values, v)
        end

        return values
    end,

    Keys = function(self)
        local keys = {}

        for k, v in hashset[self].__data do
            table.insert(keys, k)
        end

        return keys
    end,
}

Dictionary.__index = function(self, key)
    if Dictionary[key] then
        return Dictionary[key]
    elseif index_cases[key] then
        return index_cases[key](self)
    end

    return hashset[self].__data[key]
end

Dictionary.__newindex = function(self, key, value)
    assert(false, "Cannot assign new values to Dictionary instances, use Dictionary methods to modify the dictionary.") 
end

Dictionary.__iter = function(self)
    return pairs(self.__data)
end

Dictionary.__tostring = function(self)
    return format("Dictionary<%s, %s>[%s]", hashset[self].__collection_type.index_type, hashset[self].__collection_type.value_type, hashset[self].__count)
end

local metatable_cases = {
    __type = function(self)
        return "collection"
    end,

    __collection_type = function(self)
        return hashset[self].__collection_type
    end,

    __validator = function(self)
        return hashset[self].__validator
    end
}

Dictionary.__metatable = setmetatable({}, {
    __index = function(self, key)
        if metatable_cases[key] then
            return metatable_cases[key](self)
        end

        return Dictionary[key]
    end
})

Dictionary.__eq = function(self, other)
    if other == nil or (getmetatable(self) ~= getmetatable(other)) then
        return false
    end

    if hashset[self].__count ~= hashset[other].__count then
        return false
    end

    for k, v in hashset[self].__data do
        if v ~= hashset[other].__data[k] then
            return false
        end
    end

    return true
end

Dictionary.__len = function(self)
    return hashset[self].__count
end

----------------------------------------------------------------------------------------------------------------------------

Dictionary.GetType = function(self)
    return hashset[self].__type
end

Dictionary.new = function<K, V>(_key_type: string, _value_type: string): (data: {[K]: V}?) -> types.Dictionary<K, V>
    local dict_type = format("Dictionary<%s, %s>", _key_type, _value_type)

    assert(collection_util.valid_collection_info(dict_type), "Invalid collection type")

    local collection_info = collection_util.from_str(dict_type)
    local validator = collection_util.create_validator(collection_info)

    return function(data: {[K]: V}?)
        if data then
            assert(type(data) == "table", "Data must be a table")

            local validation, err = validator(data)

            if not validation then
                error("Invalid type for data: ".. tostring(err), 10)
            end

            if type(collection_info.value_type) == "table" then
                for i, v in data do
                    if type(v) == "table" and not getmetatable(v) then
                        local nested_value_type = collection_info.value_type.collection_type
                        data[i] = collection_util.new_collection(nested_value_type, v)
                    end
                end
            end
        end

        local self = setmetatable({}, Dictionary)

        hashset[self] = {
            __data = data or {},
            __count = if data then collection_util.len(data) else 0,
            __type = dict_type,
            __collection_type = collection_info,
        }
    
        getmetatable(self).__type = dict_type
        getmetatable(self).__collection_type = collection_info
        getmetatable(self).__validator = validator
    
        return self :: any
    end
end

----------------------------------------------------------------------------------------------------------------------------

Dictionary.Set = function<K, V>(self, key: K, value: V?)
    local hashset_self = hashset[self]

    assert(GetType(key) == hashset_self.__collection_type.index_type, "Invalid key type")
    assert(value ~= nil, "Value cannot be nil")

    if type(hashset_self.__collection_type.value_type) == "table" then
        if not getmetatable(value :: any) then
            if type(value) == "table" then
                local success, return_result = pcall(function()
                    return collection_util.new_collection(hashset_self.__collection_type.value_type.collection_type, value)
                end)

                if (success and return_result) then
                    value = return_result :: any
                else
                    error("Invalid value type, failed to automatically convert value to collection in a nested collection of type: ".. hashset_self.__type, 2)
                end
            end

            error("Invalid value type, expected a collection of type: ".. hashset_self.__type, 2)
        else 
            local mt = getmetatable(value :: any)

            assert(collection_util.is_collection_info((mt.__collection_type)), "Invalid collection type, expected a collection of type: ".. hashset_self.__type)
            assert(mt.__type == hashset_self.__type "Invalid value type, expected a collection of type: ".. hashset_self.__type)
        end
    end

    if hashset[self].__data[key] == nil then
        hashset[self].__count += 1
    end

    hashset[self].__data[key] = value
end

Dictionary.Remove = function<K>(self, key: K)
    assert(key ~= nil, "Key cannot be nil")
    assert(GetType(key) == hashset[self].__collection_type.index_type, "Invalid key type")

    hashset[self].__data[key] = nil
    hashset[self].__count -= 1
end

Dictionary.ContainsKey = function<K>(self, key: K): boolean
    return hashset[self].__data[key] ~= nil
end

Dictionary.ContainsValue = function<V>(self, value: V): boolean
    for k, v in hashset[self].__data do
        if v == value then
            return true
        end
    end

    return false
end

Dictionary.Clear = function(self)
    hashset[self].__data = {}
    hashset[self].__count = 0
end

Dictionary.IsEmpty = function(self): boolean
    return hashset[self].__count == 0
end

Dictionary.Get = function<K, V>(self, key: K): V
    assert(GetType(key) == hashset[self].__collection_type.index_type, "Invalid key type")

    return hashset[self].__data[key]
end

Dictionary.ForEach = function<K, V>(self, action: (K, V) -> nil)
    assert(type(action) == "function", "Action must be a function")

    for k, v in hashset[self].__data do
        action(k, v)
    end
end


Dictionary.Find = function<K, V>(self, predicate: (K, V) -> boolean): (K?, V?)
    assert(type(predicate) == "function", "Predicate must be a function")

    for k, v in hashset[self].__data do
        if predicate(k, v) then
            return k, v
        end
    end

    return nil
end

Dictionary.FindAll = function<K, V>(self, predicate: (K, V) -> boolean): types.Dictionary<K, V>
    assert(type(predicate) == "function", "Predicate must be a function")

    local collection_type = hashset[self].__collection_type
    local index_type = collection_type.index_type
    local value_type = collection_type.value_type

    local new_dict = Dictionary.new(index_type, value_type)()

    for k, v in hashset[self].__data do
        if predicate(k, v) then
            new_dict:Set(k, v)
        end
    end

    return new_dict
end


Dictionary.ToTable = function<K, V>(self): {[K]: V}
    return hashset[self].__data
end

Dictionary.PairsArray = function<K, V>(self)
    local array = {}

    for k, v in hashset[self].__data do
        table.insert(array, {k, v})
    end

    return array
end

Dictionary.Print = function(self)
    print(tostring(self))
    for k, v in hashset[self].__data do
        print(k, v)
    end
end

Dictionary.Exists = function<K, V>(self, predicate: (K, V) -> boolean): boolean
    assert(type(predicate) == "function", "Predicate must be a function")

    for k, v in hashset[self].__data do
        if predicate(k, v) then
            return true
        end
    end

    return false
end

----------------------------------------------------------------------------------------------------------------------------

return Dictionary

----------------------------------------------------------------------------------------------------------------------------