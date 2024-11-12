--!nonstrict

local collection_util = require(script.Parent.Parent.util.collection)
local types = require(script.Parent.Parent.types)
local GetType = require(script.Parent.Parent.get_type)

local format = string.format

local hashset = setmetatable({}, {__mode = "k"})

local List = {}

List.__index = function(self, key)
    if List[key] then
        return List[key]
    else
        return hashset[self][key]
    end
end

List.__iter = function(self)
    return ipairs(self.__data)
end

List.GetType = function(self)
    return self.__type
end

List.__metatable = {
    __type = "Object",
}

List.new = function(_list_type: string | types.collection_info)
    local list_type = if typeof(_list_type) == "table" then collection_util.to_str({
        collection_type = "List",
        value_type = _list_type,
        index_type = "number",
    }) else format("List<%s>", _list_type)

    assert(collection_util.valid_collection_info(list_type), "Invalid collection type")

    local collection_info = collection_util.from_str(list_type)
    print(collection_info, list_type)
    local validator = collection_util.create_validator(collection_info)

    local isNested = type(collection_info.value_type) == "table"

    return function(data: {}?)
        if data then
            assert(type(data) == "table", "Data must be a table")

            print(data)
            print(collection_info)

            local validation, err = validator(data)

            if not validation then
                error("Invalid type for data: ".. err, 10)
            end

            if isNested then
                for i, v in ipairs(data) do
                    if type(v) == "table" and not getmetatable(v) then
                        data[i] = List.new(collection_util.remove_layer(collection_info.value_type))(v)
                    end
                end
            end
        end

        local self = setmetatable({}, List)

        hashset[self] = {
            __data = data or {},
            __count = 0,
        }
    
        getmetatable(self).__type = list_type
        getmetatable(self).__collection_type = collection_info
        getmetatable(self).__validator = validator
    
        return self
    end
end

List.Add = function(self, value)
    assert(value)

    hashset[self].__count += 1
    table.insert(hashset[self], value)
end

List.Contains = function(self, value): boolean
    assert(GetType(value) == getmetatable(self).__collection_type.value_type, "Type of value does not match List value type.")

    for i, v in hashset[self].__data do
        if v == value then
            return true
        end
    end

    return false
end



return List