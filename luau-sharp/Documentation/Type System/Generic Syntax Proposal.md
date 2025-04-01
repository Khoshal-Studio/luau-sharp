These are the current suggestions for how generic type parameters should be declared in the L# framework.
## Proposal 1
Declaration in classes, interfaces, structs, and types.
```lua
class 'Baz<T>' 
{
	public.constructor (function(this)
		print(this.GenericArgs.T)
	end)
}

class 'Wrapper<Y>' 
{
	private.Y '_original';
	
	public.constructor 
	{
		{
			arg.Y;
		};
		
		function(original)
			this._original = original;
		end
	}
}
--Access and specification of generics are identical for structs and interfaces.


--Types
type.new 'Hook<A, B>' {
	HookA = 'A';
	HookB = 'B';
}
```

Specify the generic constraints at the end of all class and type declaration modifiers.
```lua
class 'Foo<T>': extends 'ArbitraryClass': implements 'IArbitrary': where {T = union ('boolean', 'string')} {
	--...
}

type.new 'SuperFoo<P>': from 'Foo': where {P = 'ArbitraryRootType'} {
	SuperFoo = 'P';
	---...
}
```

Usage with the type system:
```lua
type.new 'Bar<T, K>': where {[T = 'primitive'} (
	--...
)
```

The special feature about this proposal is the ability to pack constraints. It allows users to apply a constraint to multiple generic arguments to prevent verbosity.
```lua
class 'PackedConstraints<T, K, V>': where {['T, K, V'] = 'notnil'} {
	--...
}
```

## Proposal 2
For members like classes, interfaces and structs:

```lua
class 'Baz' {
	type_args (
		generic 'T';
	);
	
	public.constructor (function(this)
		print(this.GenericArgs.T)
	end)
}
```

Specify the generic constraints at the end of all class modifiers.
```lua
class 'Foo': extends 'ArbitraryClass': implements 'IArbitrary' {
	type_args (
		generic 'T'
	): where {T = union ('boolean', 'string')}
	--...
}
```

Usage with the type system:
```lua
type.new 'Bar' (
	type_args (
		generic 'T';
		generic 'K'
	): where {T = 'primitive'}
	--...
)
```

This proposal is derived from 1, therefore it has the ability to pack constraints. It allows users to apply a constraint to multiple generic arguments to prevent verbosity.
```lua
class 'PackedConstraints' {
	type_args (
		generic 'T';
		generic 'K';
		generic 'V';
	): where {['T, K, V'] = 'notnil'}
	--...
}
```
## Proposal 2.1
The only difference is that the where keyword is replaced with `constrain`
## Proposal 3
For members like classes, interfaces and structs:

```lua
class 'Baz' {
	type.arg 'T';
	
	public.constructor (function(this)
		print(this.GenericArgs.T)
	end)
}
```

Specify the generic constraints at the end of all class modifiers.
```lua
class 'Foo': extends 'ArbitraryClass': implements 'IArbitrary' {
	type.arg 'T': constrain (union ('boolean', 'string'))
	--...
}
```

Usage with the type system:
```lua
type.new 'Bar' (
	type.arg 'T': constrain 'primitive';
	type.arg 'K';
	--...
)
```

This proposal is derived from 1, therefore it has the ability to pack constraints. It allows users to apply a constraint to multiple generic arguments to prevent verbosity.
```lua
class 'PackedConstraints' {
	type.arg 'T': constrain 'notnil';
	type.arg 'K': constrain 'notnil';
	type.arg 'V': constrain 'notnil';
	--...
}
```


# Final Solution
The final solution for the generic type syntax in L# is as follows:

## Generic Type Declaration

### Classes
Generic type parameters are declared using the `type_args` keyword, where all generic parameters are specified as arguments in the brackets. The `generic` keyword is used to specify type parameters must be called with a string name. Constraints can be specified using the `constain` method of the object returned by the `generic` keyword, and any type can be used as a constraint.

`type_args` can be used in classes, interfaces, and even types. It must be the first member of the object body.

```lua
class 'Foo': extends 'ArbitraryClass': implements 'IArbitrary' {
	type_args (
        generic 'T': constrain (union ('boolean', 'string'))
    ) 
	
    public.T 'Value' {
        get (function(this, field)
            return field;
        end)
    }
}
```

### Types
Generic type parameters for types are declared using the `type.arg` keyword followed by the generic type name. Constraints can be specified using the `constrain` keyword.

```lua
type.new 'Bar' (
	type.arg 'T': constrain 'primitive';
	type.arg 'K';
	-- Type members
)
```

### Packing Constraints
The final solution allows packing constraints to apply a constraint to multiple generic arguments, reducing verbosity.

```lua
class 'PackedConstraints' {
	type.arg 'T': constrain 'notnil';
	type.arg 'K': constrain 'notnil';
	type.arg 'V': constrain 'notnil';
	-- Class members and methods
}
```

## Examples

### Generic Class with Constraints
```lua
class 'NumericBox' {
	type.arg 'T': constrain 'number';
	
	private.T '_value';
	
	public.constructor {
		{ arg.T };
		function(this, value: T)
			this._value = value;
		end
	}
	
	public.T 'Value' {
		get (function(this)
			return this._value;
		end)
	}
}
```

### Generic Type with Constraints
```lua
type.new 'Result' (
	type.arg 'T': constrain 'notnil';
	type.arg 'E': constrain 'string';
	
	{
		Success = 'boolean';
		Value = 'T?';
		Error = 'E?';
	}
)
```

### Packed Constraints
```lua
class 'TripleContainer' {
	type.arg 'A': constrain 'notnil';
	type.arg 'B': constrain 'notnil';
	type.arg 'C': constrain 'notnil';
	
	private.A '_first';
	private.B '_second';
	private.C '_third';
	
	public.constructor {
		{ arg.A; arg.B; arg.C };
		function(this, first: A, second: B, third: C)
			this._first = first;
			this._second = second;
			this._third = third;
		end
	}
}
```

## Remarks
- The `type.arg` keyword is used to declare generic type parameters.
- The `constrain` keyword is used to specify constraints on generic type parameters.
- Constraints can be packed to apply the same constraint to multiple generic arguments.