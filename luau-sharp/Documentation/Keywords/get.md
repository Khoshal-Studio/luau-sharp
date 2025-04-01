# Definition
The `get` keyword is a method used to define a getter accessor for properties. It is identical to `IAccessModifier.get` because it is a shorthand for defining a public getter method. The `get` keyword is used to define a property accessor that retrieves the value of a property.

# Syntax

```lua
class 'ClassName' {
    private.dynamic 'propertyName' (10);

    public.dynamic 'PropertyName' {
        get (function(this)
            return this._propertyName
        end);
    }
}

local instance = class.ByName('ClassName').new()
print(instance.PropertyName)  -- Output: 10
```

# Parameters
- `fn` (function): The function that retrieves the value of the property.

# Optional Calling
The `get` keyword is also used to specify a public getter when defining properties in interfaces or abstract classes without implementing any logic, by simply not calling `get`.Additionally, it's also used in automatic properties to define a getter method.

```lua
class 'ClassName' {
    private.dynamic 'propertyName' (10);

    public.dynamic 'PropertyName' {
        get;
        -- Equivalent to:
        -- public.get
    }
}
```

## Automatic Properties
```lua
class 'ClassName' {
    public.dynamic 'PropertyName' {
        get;
        set;
    }
}

-- Equivalent to: (excluding the name slot occupied by the private field)
class 'ClassName' {
    private.dynamic '_propertyName';

    public.dynamic 'PropertyName' {
        get (function(this)
            return this._propertyName
        end);

        set (function(this, value)
            this._propertyName = value
        end);
    }
}
```