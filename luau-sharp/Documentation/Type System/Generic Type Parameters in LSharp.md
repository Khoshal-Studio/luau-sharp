# Generic Type Parameters in L#

## Overview

L# introduces a modern generic type system using the `type_args` declaration with the `constrain` keyword. This system allows developers to create type-safe, reusable components with precise type constraints.

## Basic Generic Declaration
When defining a class with generic type parameters, use the `type_args` declaration to specify the generic types and their constraints. It must be the first declaration in the class definition not by convention but by necessity due to how L# parses the class definition (at least the generic type parameters) sequentially.

### Simple Generic Class
```lua
class 'Box' {
  type_args (
    generic 'T'
  );
  
  private.T '_contents';
  
  public.constructor {
    { arg.T };
    function<T>(this, contents: T)
      this._contents = contents;
    end
  }
  
  public.T 'GetContents' (function(this)
    return this._contents;
  end)
}

-- Usage
local stringBox = new 'Box'("Hello World")
local numberBox = new 'Box'(42)
```

### Generic Modifiers

#### `constrain`
Generic type parameters can be constrained to specific types using the `constrain` keyword. This ensures that only values of the specified type can be used with the generic type parameter.

```lua
class 'NumericBox' {
  type_args (
    generic 'T': constrain 'number'
  );
  
  private.T '_value';
  
  public.constructor {
    { arg.T };
    function(this, value: T)
      this._value = value;
    end
  }

  public.T 'Value' 
  
  public.T 'Double' (function(this)
    return this._value * 2;
  end)
}

-- This usage is not very practical because the type is already known, however there are derivatives of the numeric types that can be used. for example, `number` is a superset of `int` and `float`. If the generic type was `int`, it would not be able to accept `float` values.

-- Usage
local box = new 'NumericBox' ('int', 42)

-- local invalidBox = new 'NumericBox'("string")  -- Type error
```

#### `default`
You can specify default types for generic type parameters using the `default` keyword. If no type is provided when instantiating the class, the default type will be used.

```lua
class 'DefaultBox' {
  type_args (
    generic 'T': default 'string'
  );
  
  private.T '_value';
  
  public.constructor {
    { arg.T };
    function(this, value: T)
      this._value = value;
    end
  }
  
  public.T 'GetValue' (function(this)
    return this._value;
  end)
}
```

## Advanced Constraint Techniques

### Union Constraints
```lua
class 'FlexibleContainer' {
  type_args (
    generic 'T': constrain union('string', 'number')
  );
  
  private.T '_item';
  
  public.constructor {
    { arg.T };
    function(this, item: T)
      this._item = item;
    end
  }
}

-- Usage
local stringContainer = new 'FlexibleContainer'("Hello")
local numberContainer = new 'FlexibleContainer'(42)
```

### Multiple Generic Parameters
```lua
class 'KeyValuePair' {
  type_args (
    generic 'K': constrain 'string';
    generic 'V': constrain 'notnil'
  );
  
  private.K '_key';
  private.V '_value';
  
  public.constructor {
    { arg.K; arg.V };
    function(this, key: K, value: V)
      this._key = key;
      this._value = value;
    end
  }
}

-- Usage
local pair = new 'KeyValuePair'("userId", 12345)
```

### Complex Constraints
```lua
class 'AdvancedList' {
  type_args (
    generic 'T': constrain (intersection (
	    'notnil';
	    { 
	        Value = 'number';
	        Name = 'string'
	    })
    )
  );
  
  private [indexer ('number', 'T')] '_items';
  
  public.void 'Add' {
    { arg.T };
    function<T>(this, item: T)
      table.insert(this._items, item);
    end
  }
}

-- Usage
local list = new 'AdvancedList'()
list:Add({ Value = 10, Name = "Item" })
```

## Generic Interfaces
```lua
interface 'IRepository' {
  type_args (
    generic 'T': constrain 'notnil'
  );
  
  public.abstract.T 'FindById' {
    { arg.string };
    returns.T;
  }
  
  public.abstract.void 'Save' {
    { arg.T };
  }
}
```

## Generic Type Declarations
```lua
type.new 'Result' {
  type_args (
    generic 'T': constrain 'notnil';
    generic 'E': constrain 'string';
  );
  
  Success = 'boolean';
  Value = 'T?';
  Error = 'E?';
}
```

## Constraint Types
Any type can be used as a constraint, including built-in types, user-defined types, and interfaces.

### Built-in Constraint Types
See the [[Built-in datatypes]] documentation for a list of available constraint types.

## Best Practices
1. Keep constraints specific but not overly restrictive
2. Use `notnil` to prevent nil values in generic types
3. Always place the `type_args` declaration at the top of the class definition.

## Performance Considerations
- Generic type constraints are evaluated at type definition time
- Minimal runtime overhead
- Provides strong type safety without significant performance impact

## Error Handling
When type constraints are violated (without a default type to fallback to), L# will throw an error.