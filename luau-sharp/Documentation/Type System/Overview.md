# Types
A type can be thought of as a set of all possible values that are assignable to it.

L# uses a strict runtime type-checking system separate from the Luau type system. This is because Luau doesn't currently support reflection, at least with types, a core feature in L#. For example, in L#, you can pass type arguments to generic types, methods and constructors.

```lua
local BaseClass = class 'BaseClass' {};
local DerivedClass1 = class 'DerivedClass1': extends 'BaseClass' {};
local DerivedClass2 = class 'DerivedClass2': extends 'BaseClass' {};

local MyClass = class 'MyClass' {
	type_args (
		generic 'K': where 'K': extends 'BaseClass';
	);

	public.void 'MyMethod' {
		{
			arg.generic 'T';
			arg.string;
		};
		
		function(this, Str: string)
			print(`{Str} {T}`);
		end
	}
	
	private.K 'MyValue';
}

local function main()
	local obj = MyClass.new();
	obj.MyMethod('boolean', 'Typeof T is:')
end

main()
```

```c#
class MyClass<K>
{
    public static void MyMethod<T>(string Str)
    {
        System.Console.WriteLine($"{Str} {typeof(T)}");
    }

    private readonly K _myValue;

    public MyClass(K x)
    {
        this._myValue = x;
        System.Console.WriteLine(_myValue);
        System.Console.WriteLine($"The type of K is: {typeof(K)}");
    }
}

class Program
{
    public static void Main()
    {
        new MyClass<int>(42);
        MyClass<int>.MyMethod<bool>("Typeof T is:");
    }
}
```

# Creating Types
In Luau, types are structs that hold the information for their datatype. Types can be created using the `type` library. Don't worry, as the default `type` function hasn't been replaced and you can still call it normally to get the type of values.

Declare a global type using `type.new`, followed by the type name, then the type data.
```lua
type.new 'PrimaryColours' (literal ("Red", "Green", "Blue"))
```

# Using Types
When using types anywhere that takes type parameters, you can reference it by string (i.e. inputting the type name, or calling an existing generic type with arguments.)

**Non-generic String Reference**
```lua
type.new 'MyType' {
	Foo = 'number';
	Bar = 'string';
}

local arg_list = {
	arg.MyType
}
```

**Generic String Reference**
```lua
type.new 'GenericType' {
	type_args (
		generic 'T';
		generic 'K';
	);
	
	{
		X = 'T';
		Y = 'K'
	}
}

local MyClass = class 'MyClass' {
	private.static ['GenericType<decimal, int>'] 'MyField' {
		X = 0.3;
		Y = 2;
	};
}
```
## Interface Types
Interfaces are used to define data structures that can be passed as parameters or return types. They're similar to interfaces, but they can't contain methods because Luau doesn't support reflection (as in the return types and parameters of functions can't be checked at runtime). They don't have a special keyword, but they can be created by passing a table to `type.new`.

```lua
type.new 'IExample' {
    {
        foo = 'number';
        bar = 'string';
    }
}
```

### Indexers
On the topic of data structures, we also have indexers. Indexers are used to define an arbitrary datastructure whose keys are of a certain type and whose values are of another type. They're defined using `indexer` keyword, which takes in the key type and the value type.

```lua
type.new 'IndexerExample' (indexer ('string', 'number'))
```