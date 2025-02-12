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

local List = {}

local index_cases = {
    Count = function(self)
        return hashset[self].__count
    end,

    Length = function(self)
        return hashset[self].__count
    end,
}

List.__index = function(self, key)
    if List[key] then
        return List[key]
    elseif index_cases[key] then
        return index_cases[key](self)
    end

    return hashset[self].__data[key]
end

List.__newindex = function(self, key, value)
    assert(false, "Cannot assign new values to List instances, use List methods to modify the list.") 
end

List.__iter = function(self)
    return ipairs(self.__data)
end

List.__tostring = function(self)
    return format("List<%s>[%s]", hashset[self].__collection_type.value_type, hashset[self].__count)
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

List.__metatable = setmetatable({}, {
    __index = function(self, key)
        if metatable_cases[key] then
            return metatable_cases[key](self)
        end

        return List[key]
    end
})

List.__eq = function(self, other)
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

List.__len = function(self)
    return hashset[self].__count
end

----------------------------------------------------------------------------------------------------------------------------

List.GetType = function(self)
    return hashset[self].__type
end

List.new = function<T>(_list_type: string): (data: {T}?) -> types.List<T>
    local list_type = format("List<%s>", _list_type)

    assert(collection_util.valid_collection_info(list_type), "Invalid collection type")

    local collection_info = collection_util.from_str(list_type)
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

        local self = setmetatable({}, List)

        hashset[self] = {
            __data = data or {},
            __count = if data then collection_util.len(data) else 0,
            __type = list_type,
            __collection_type = collection_info,
        }
    
        getmetatable(self).__type = list_type
        getmetatable(self).__collection_type = collection_info
        getmetatable(self).__validator = validator
    
        return self :: any
    end
end

----------------------------------------------------------------------------------------------------------------------------

List.Add = function(self, value)
    assert(value)

    hashset[self].__count += 1
    table.insert(hashset[self].__data, value)
end

List.Contains = function<T>(self, value: T): boolean
    assert(GetType(value) == getmetatable(self).__collection_type.value_type, "Type of value does not match List value type.")

    for i, v in hashset[self].__data do
        if v == value then
            return true
        end
    end

    return false
end

List.Print = function(self)
    print(tostring(self))
    for i, v in hashset[self].__data do
        print(v)
    end
end

List.Get = function<T>(self, index: number): T
    assert(type(index) == "number", "Index must be a number")
    assert(index % 1 == 0, "Index must be an integer")
    assert(index > 0, "Index must be greater than 0")
    assert(index <= hashset[self].__count, "Index out of range")

    return hashset[self].__data[index]
end

List.RemoveAt = function(self, index: number)
    assert(type(index) == "number", "Index must be a number")
    assert(index % 1 == 0, "Index must be an integer")
    assert(index > 0, "Index must be greater than 0")
    assert(index <= hashset[self].__count, "Index out of range")

    table.remove(hashset[self].__data, index)
    hashset[self].__count -= 1
end

List.Clear = function(self)
    hashset[self].__data = {}
    hashset[self].__count = 0
end

List.IsEmpty = function(self): boolean
    return hashset[self].__count == 0
end

List.AddRange = function<T>(self: T, values: {any})
    assert(type(values) == "table", "Values must be a table")

    for i, v in values do
        List.Add(self, v)
    end
end

List.RemoveLast = function<T>(self: T): boolean
    if hashset[self].__count == 0 then
        return false
    end

    hashset[self].__data[hashset[self].__count] = nil
    hashset[self].__count -= 1

    return true
end

List.Insert = function<T>(self, value: T, index: number)
    assert(value)

    hashset[self].__count += 1
    table.insert(hashset[self].__data, index, value)
end

List.InsertRange = function<T>(self, values: {T}, index: number)
    assert(type(values) == "table", "Values must be a table")
    assert(type(index) == "number", "Index must be a number")
    assert(index % 1 == 0, "Index must be an integer")
    assert(index > 0, "Index must be greater than 0")
    assert(index <= hashset[self].__count, "Index out of range")

    for i, v in values do
        List.Insert(self, v, index + i - 1)
    end
end

List.Remove = function(self, value: any)
    assert(value)

    for i, v in hashset[self].__data do
        if v == value then
            table.remove(hashset[self].__data, i)
            hashset[self].__count -= 1
            return
        end
    end
end

List.RemoveRangeAt = function(self, index: number, end_index: number)
    assert(type(index) == "number", "Index must be a number")
    assert(index % 1 == 0, "Index must be an integer")
    assert(index > 0, "Index must be greater than 0")
    assert(index <= hashset[self].__count, "Index out of range")

    assert(type(end_index) == "number", "End index must be a number")
    assert(end_index % 1 == 0, "End index must be an integer")
    assert(end_index > 0, "End index must be greater than 0")
    assert(end_index <= hashset[self].__count, "End index out of range")

    assert(end_index >= index, "End index must be greater than or equal to start index")

    for _ = index, end_index do
        table.remove(hashset[self].__data, index) -- Always remove at 'index'
        hashset[self].__count -= 1
    end
end

List.RemoveAll = function(self, predicate: (any) -> boolean)
    assert(type(predicate) == "function", "Predicate must be a function")

    for i = hashset[self].__count, 1, -1 do
        if predicate(hashset[self].__data[i]) then
            table.remove(hashset[self].__data, i)
            hashset[self].__count -= 1
        end
    end
end

List.Find = function<T>(self, predicate: (T) -> boolean): T?
    assert(type(predicate) == "function", "Predicate must be a function")

    for i, v in hashset[self].__data do
        if predicate(v) then
            return v
        end
    end

    return nil
end

List.FindAll = function<T>(self, predicate: (T) -> boolean): {}
    assert(type(predicate) == "function", "Predicate must be a function")

    local data = hashset[self]

    local result = {}

    for i, v in hashset[self].__data do
        if predicate(v) then
            table.insert(result, v)
        end
    end

    return List.new(data.__collection_type.value_type)(result)
end

List.FindIndex = function<T>(self, predicate: (T) -> boolean): number?
    assert(type(predicate) == "function", "Predicate must be a function")

    for i, v in hashset[self].__data do
        if predicate(v) then
            return i
        end
    end

    return nil
end

List.FindAllIndex = function<T>(self, predicate: (T) -> boolean): {number}
    assert(type(predicate) == "function", "Predicate must be a function")

    local result = {}

    for i, v in hashset[self].__data do
        if predicate(v) then
            table.insert(result, i)
        end
    end

    return result
end

List.FindLast = function<T>(self, predicate: (T) -> boolean): T?
    assert(type(predicate) == "function", "Predicate must be a function")

    for i = hashset[self].__count, 1, -1 do
        if predicate(hashset[self].__data[i]) then
            return hashset[self].__data[i]
        end
    end

    return nil
end

List.FindLastIndex = function<T>(self, predicate: (T) -> boolean): number?
    assert(type(predicate) == "function", "Predicate must be a function")

    for i = hashset[self].__count, 1, -1 do
        if predicate(hashset[self].__data[i]) then
            return i
        end
    end

    return nil
end

List.TrueForAll = function<T>(self, predicate: (T) -> boolean): boolean
    assert(type(predicate) == "function", "Predicate must be a function")

    for i, v in hashset[self].__data do
        if not predicate(v) then
            return false
        end
    end

    return true
end

List.IndexOf = function(self, value: any): number?
    for i, v in hashset[self].__data do
        if v == value then
            return i
        end
    end

    return nil
end

List.Sort = function<T>(self, comparator: types.Comparator<T>?)
    if comparator then
        table.sort(hashset[self].__data, function(a, b)
            return comparator(a, b) < 0
        end)
    else
        table.sort(hashset[self].__data)
    end
end

List.Slice = function(self, start_index: number, end_index: number): {}
    assert(type(start_index) == "number", "Start index must be a number")
    assert(start_index % 1 == 0, "Start index must be an integer")
    assert(start_index > 0, "Start index must be greater than 0")
    assert(start_index <= hashset[self].__count, "Start index out of range")

    assert(type(end_index) == "number", "End index must be a number")
    assert(end_index % 1 == 0, "End index must be an integer")
    assert(end_index > 0, "End index must be greater than 0")
    assert(end_index <= hashset[self].__count, "End index out of range")

    assert(end_index >= start_index, "End index must be greater than or equal to start index")

    local result = {}

    for i = start_index, end_index do
        table.insert(result, hashset[self].__data[i])
    end

    return List.new(hashset[self].__collection_type.value_type)(result)
end

List.GetFirst = function(self): any
    return hashset[self].__data[1]
end

List.GetLast = function(self): any
    return hashset[self].__data[hashset[self].__count]
end

List.ForEach = function(self, action: (any) -> nil)
    assert(type(action) == "function", "Action must be a function")

    for i, v in hashset[self].__data do
        action(v)
    end
end

List.GetRange = List.Slice

List.Reverse = function(self)
    local data = hashset[self].__data

    for i = 1, math.floor(hashset[self].__count / 2) do
        data[i], data[hashset[self].__count - i + 1] = data[hashset[self].__count - i + 1], data[i]
    end
end

List.LastIndexOf = function(self, value: any): number?
    for i = hashset[self].__count, 1, -1 do
        if hashset[self].__data[i] == value then
            return i
        end
    end

    return nil
end

List.Exists = function(self, predicate: (any) -> boolean): boolean
    for i, v in hashset[self].__data do
        if predicate(v) then
            return true
        end
    end

    return false
end

List.GetRaw = function(self): {}
    return hashset[self].__data
end

List.Average = function<T>(self, reducer: (number, T) -> number): number
    assert(type(reducer) == "function", "Reducer must be a function")

    local sum = 0

    for i, v in hashset[self].__data do
        sum += reducer(sum, v)
    end

    return sum / hashset[self].__count
end

List.Sum = function<T>(self, reducer: (number, T) -> number): number
    assert(type(reducer) == "function", "Reducer must be a function")

    local sum = 0

    for i, v in hashset[self].__data do
        sum += reducer(sum, v)
    end

    return sum
end

List.Max = function<T>(self, reducer: (number, T) -> number): number
    assert(type(reducer) == "function", "Reducer must be a function")

    local max = -math.huge

    for i, v in hashset[self].__data do
        local value = reducer(max, v)

        if value > max then
            max = value
        end
    end

    return max
end

List.Min = function<T>(self, reducer: (number, T) -> number): number
    assert(type(reducer) == "function", "Reducer must be a function")

    local min = math.huge

    for i, v in hashset[self].__data do
        local value = reducer(min, v)

        if value < min then
            min = value
        end
    end

    return min
end

----------------------------------------------------------------------------------------------------------------------------

return List

----------------------------------------------------------------------------------------------------------------------------