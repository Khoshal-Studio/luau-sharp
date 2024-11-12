--!strict

local t = require(script.Parent.dependencies.t)

local types = {}

types.int = function(x)
    return x == math.floor(x)
end

types.float = function(x)
    
end

types.string = t.string

types.boolean = t.boolean

types.table = t.table

types.list = t.array

types.dictionary = t.map

return types