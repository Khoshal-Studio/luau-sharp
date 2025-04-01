# Definition
The `static` keyword is used to declare static classes and static members. Static classes cannot be instantiated and can only contain static members. Static members belong to the class itself rather than any instance and are shared across all instances of the class.

# Syntax
## Static Class
```lua
static.class 'ClassName' {
    -- Static members
}
```

## Static Members
```lua
class 'ClassName' {
    public.static.int 'StaticMember' (0);
}
```

## Example
### Static Class
```lua
local Math = static.class 'Math' {
    public.static.int 'Add' {
        { arg.int; arg.int };
        function(a, b)
            return a + b;
        end
    }

    public.static.int 'Subtract' {
        { arg.int; arg.int };
        function(a, b)
            return a - b;
        end
    }
}

print(Math.Add(5, 3))  -- Output: 8
```

### Static Members
```lua
local Counter = class 'Counter' {
    public.static.int 'Count' (0);

    public.static.void 'Increment' (function()
        Counter.Count = Counter.Count + 1;
    end)

    public.meta.__call (function()
        Counter.Increment();
    end)
}

local MyCounter = new (Counter);
```

# Under The Hood
When a static class is defined, the class is injected into the global namespace, allowing static members to be accessed using the class name or by `class.ByName('ClassName')`.

# Remarks
- Static classes cannot be instantiated.
- All members of a static class must be static.
- Static members are shared across all instances of the class.
- Static members can be accessed using the class name.