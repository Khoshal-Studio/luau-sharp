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

local Queue = {}

local index_cases = {
    Count = function(self)
        return hashset[self].__count
    end,

    Length = function(self)
        return hashset[self].__count
    end,
}

Queue.__index = function(self, key)
    if Queue[key] then
        return Queue[key]
    elseif index_cases[key] then
        return index_cases[key](self)
    end

    return hashset[self].__data[key]
end

Queue.__newindex = function(self, key, value)
    assert(false, "Cannot assign new values to Queue instances, use Queue methods to modify the queue.") 
end

Queue.__iter = function(self)
    return ipairs(self.__data)
end

Queue.__tostring = function(self)
    return format("Queue<%s>[%s]", hashset[self].__collection_type.value_type, hashset[self].__count)
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
    end,
}

Queue.__metatable = setmetatable({}, {
    __index = function(self, key)
        if metatable_cases[key] then
            return metatable_cases[key](self)
        end

        return Queue[key]
    end
})

Queue.__eq = function(self, other)
    if other == nil or (getmetatable(self) ~= getmetatable(other)) then
        return false
    end

    if hashset[self].__count ~= hashset[other].__count then
        return false
    end

    for i, v in hashset[self].__data do
        if v ~= hashset[other].__data[i] then
            return false
        end
    end

    return true
end

Queue.__len = function(self)
    return hashset[self].__count
end

----------------------------------------------------------------------------------------------------------------------------

Queue.GetType = function(self)
    return hashset[self].__type
end

Queue.new = function<T>(_queue_type: string): (data: {T}?) -> types.Queue<T>
    local queue_type = format("Queue<%s>", _queue_type)

    assert(collection_util.valid_collection_info(queue_type), "Invalid collection type")

    local collection_info = collection_util.from_str(queue_type)
    local validator = collection_util.create_validator(collection_info)

    return function(data: {T}?)
        if data then
            assert(type(data) == "table", "Data must be a table")

            local validation, err = validator(data)

            if not validation then
                error("Invalid type for data: ".. tostring(err), 10)
            end

            data = collection_util.list_start_from_one(data, false)

            if type(collection_info.value_type) == "table" then
                for i, v in data do
                    if type(v) == "table" and not getmetatable(v) then
                        local nested_value_type = collection_info.value_type.collection_type
                        data[i] = collection_util.new_collection(nested_value_type, v)
                    end
                end
            end
        end

        local self = setmetatable({}, Queue)

        local len = if data then collection_util.len(data) else 0

        hashset[self] = {
            __data = data or {},
            __count = len,
            __type = queue_type,
            __collection_type = collection_info,

            __front = 1,
            __back = len,
        }
    
        getmetatable(self).__type = queue_type
        getmetatable(self).__collection_type = collection_info
        getmetatable(self).__validator = validator
    
        return self :: any
    end
end

----------------------------------------------------------------------------------------------------------------------------

Queue.Enqueue = function(self, value)
    local arg_type = GetType(value)

    if type(hashset[self].__collection_type.value_type) == "table" then
        if arg_type == "table" and not getmetatable(value) then
            local nested_value_type = hashset[self].__collection_type.value_type.collection_type
            value = collection_util.new_collection(nested_value_type, value :: any)
        else
            assert(arg_type == hashset[self].__collection_type.value_type.collection_type,
             format("Type of value does not match Queue value type. Expected collection type: %s, got: %s", hashset[self].__collection_type.value_type.collection_type, GetType(value)))
        end
    else
        assert(GetType(value) == hashset[self].__collection_type.value_type, "Type of value does not match Queue value type.")
    end

    local hashset_self = hashset[self]

    hashset_self.__count += 1
    hashset_self.__back += 1
    hashset_self.__data[hashset_self.__back] = value
end

Queue.Dequeue = function<T>(self: T): T?
    if hashset[self].__count == 0 then
        warn("Queue is empty")
        return nil
    end

    local hashset_self = hashset[self]

    hashset_self.__count -= 1

    local value = hashset_self.__data[hashset_self.__front]

    hashset_self.__data[hashset_self.__front] = nil
    hashset_self.__front += 1

    return value
end

Queue.Peek = function<T>(self: T): T?
    if hashset[self].__count == 0 then
        warn("Queue is empty")
        return nil
    end

    local hashset_self = hashset[self]

    return hashset_self.__data[hashset_self.__front]
end

Queue.Clear = function(self)
    hashset[self].__data = {}
    hashset[self].__count = 0

    hashset[self].__front = 1
    hashset[self].__back = 0
end

Queue.Contains = function<T>(self: T, value: T): boolean
    assert(GetType(value) == hashset[self].__collection_type.value_type, "Type of value does not match Queue value type.")

    for i, v in hashset[self].__data do
        if v == value then
            return true
        end
    end

    return false
end

Queue.IsEmpty = function(self): boolean
    return hashset[self].__count == 0
end

Queue.PeekLast = function<T>(self: T): T?
    if hashset[self].__count == 0 then
        return nil
    end

    local hashset_self = hashset[self]

    return hashset_self.__data[hashset_self.__back]
end

Queue.Print = function(self)
    print("Queue:")
    for i, v in hashset[self].__data do
        print(v)
    end
end

Queue.ForEach = function<T>(self: T, action: (T) -> nil)
    assert(type(action) == "function", "Action must be a function")

    for i, v in hashset[self].__data do
        action(v)
    end
end

Queue.Find = function<T>(self: T, predicate: (T) -> boolean): T?
    assert(type(predicate) == "function", "Predicate must be a function")

    for i, v in hashset[self].__data do
        if predicate(v) then
            return v
        end
    end

    return nil
end

Queue.FindAll = function<T>(self: T, predicate: (T) -> boolean): {T}
    assert(type(predicate) == "function", "Predicate must be a function")

    local list = {}

    for i, v in hashset[self].__data do
        if predicate(v) then
            table.insert(list, v)
        end
    end

    return list
end

Queue.ToArray = function<T>(self) : {T}
    return collection_util.list_start_from_one(hashset[self].__data, false)
end

----------------------------------------------------------------------------------------------------------------------------

return Queue

----------------------------------------------------------------------------------------------------------------------------