## Datatypes
The following are the built-in datatypes in L# that can be used to define variables, parameters, and return types in functions and classes. These datatypes are used to enforce type safety and provide a clear definition of the data being used in a program.

All the datatypes below are predefined in the framework, and they can be referenced directly by their name. Note that some datatypes are environment-specific, such as Roblox-specific datatypes and Luau-specific datatypes (vector, buffer). 

Additionally, none of the datatypes can be overridden or redefined by the user, as they are built-in, and `type.new` will throw an error if you try to redefine a built-in datatype.

### `primitive` (L#)
```lua
public.type 'primitive' (union ('string', 'boolean', 'number'));
```
A union type of string, boolean and number.
### `string` (Lua)
A sequence of characters.

### `number` (Lua)
Real (double precision floating point) numbers.
```lua
public.type.base 'number';
```

#### `decimal` (L#)
The set of numbers between 0 and 1.
```lua
public.type.custom 'decimal': from 'number' (function(value)
    return value >= 0 and value <= 1
end)
```

#### `int` (L#)
The set of all integers, numbers without a decimal component.
```lua
public.type.custom 'int' : from 'number' (function(value)
    return math.floor(value) == value
end)
```

##### `uint` (L#)
The set of numbers greater than or equal to 0.
```lua
public.type.custom 'uint' : from 'int' {
	validator (function(value)
		return value >= 0;
	end)
}
```

### `boolean` (Lua)
A Boolean value that evaluates to either `true` or `false`.
### `table` (Lua)
Any data structure defined with the curly bracket syntax in Lua.
#### `array<T>` (L#)
A contiguous numerically indexed table.

##### Generic Type Parameters
- `T`: The type of the elements in the array.

```lua
public.type.custom 'array' : from 'table' {
	type_args (
		generic 'T': constrain 'notnil'
	);
	
	validator (function(value)
		local current = 1
		
		for i, _ in value do
			if type(i) ~= 'number' then return false end
			if i ~= current then return false end
			
			current += 1
		end
		
		return true
	end)
} 
```

#### `map<K, V>` (L#)
A table with keys of type `K` and values of type `V`.

##### Generic Type Parameters
- `K`: The type of the keys in the map.
- `V`: The type of the values in the map.

```lua
public.type.custom 'map' : from 'table' {
    type_args (
        generic 'K': constrain 'notnil';
        generic 'V': constrain 'notnil'
    );
    
    validator (function(this, value)
        for k, v in pairs(value) do
            if this.GenericArgs[1]:IsType(k) == false then return false end
            if this.GenericTypes[2]:IsType(v) == false then return false end
        end
        
        return true
    end)
}
```

### `notnil` (L#)
```lua
public.type 'notnil' (exclude ('any', 'nil'));
```

### `thread` (Lua)
A coroutine in Lua.

### `callback` (Lua)
A function.

#### `void` (L#)
A function that returns no values.

### `userdata` (Lua)
C-object in Lua

#### `Instance` (Roblox)

### `vector` (Luau)
Luau built-in vector type

### `buffer` (Luau)
Luau buffer type