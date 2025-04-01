--!strict

local MODIFIER_TREE = require(script.Parent.modifier_tree)

export type Reducer<T> = (key: any, chain: { [number]: T }) -> ()

local recursiveIndexer = {}

recursiveIndexer.__index = function(self, key: any): any
	-- Create a new chain by copying the existing chain and adding the new key
	local newChain = {}
	
	for i, v in pairs(self._chain) do
		newChain[i] = v
	end
	
	table.insert(newChain, key)

	-- Call the reducer function with the key and the new chain
	local res, value = self._reducer(key, newChain)

	print(res, value)

	if res == true then
		-- If the reducer returns true, return the value
		return value
	else
		-- Otherwise, create a new recursive indexer with the updated chain
		return setmetatable({ _chain = newChain, _reducer = self._reducer }, recursiveIndexer)
	end
end

function recursiveIndexer.new<T>(reducer: Reducer<T>, initial: {}?)
	assert(type(reducer) == "function", "A reducer function is required")
	-- Initialize the chain with the initial table (if provided)
	local chain = {}
	
	print(initial)
	
	-- Shallow copy
	for i, v in pairs(initial or {}) do
		chain[i] = v
	end
	
	print(chain)
	
	return setmetatable({ _chain = chain, _reducer = reducer }, recursiveIndexer)
end

local function main()
	local function validate_modifier_chain(chain: any)
		-- Placeholder for validation logic
	end
	
	local function method_or_field(chain)
		
	end

	local function make_indexer_of_access_modifier(access_modifier: string)
		return recursiveIndexer.new(function(key, chain: any)
			-- Check if the key already exists in the chain
			if chain[key] then
				error(`Modifier already set: {key}`)
			end

			-- Handle the "class" modifier
			if key == "class" then
				if chain.access_modifier and #chain > 1 then
					error("Invalid modifier combination: class cannot be used with access modifiers")
				end

				chain.class = true

				for i, v in pairs(chain) do
					if v == true and i ~= "static" and i ~= "class" then
						error(`Invalid modifier combination: {i} cannot be used with {key}`)
					end
				end

				return true, chain
			end

			-- Handle datatype modifiers
			if MODIFIER_TREE.DATATYPES[key] then
				chain.datatype = key
				return true, chain
			end

			-- Handle the "void" modifier
			if key == "void" then
				chain.void = true
				return true, chain
			end
			
			if key == "static" then
				chain.static = true
			end

			-- If no final modifier is found, continue the chain
			return false, setmetatable(chain, recursiveIndexer)
		end, { access_modifier = access_modifier }) -- Pass the initial table here
	end

	-- Create indexers for different access modifiers
	local public = make_indexer_of_access_modifier("public")
	local private = make_indexer_of_access_modifier("private")
	local protected = make_indexer_of_access_modifier("protected")

	local function get_readable_member_type(member: any): string
		local modifiers = {}

		for key, value in pairs(member) do
			if value == true and key ~= "access_modifier" then
				table.insert(modifiers, key)
			end
		end

		return `A {member.access_modifier} {table.concat(modifiers, " ")} field`
	end

	-- Test the indexers
	local y = public.int
	local z = public.static.string
	print(y, z)
end

main()

return recursiveIndexer