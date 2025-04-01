# Definition
Abstract classes are classes that cannot be instantiated and must be inherited and are used to define a common interface for a group of subclasses. Abstract classes are defined using the `abstract` keyword, followed by the class name and the class body.

# Syntax
```lua
abstract.class 'ClassName' {
    -- Class members
}
```

## Example
```lua
abstract.class 'Shape' {
    public.abstract.int 'Area' { get; };
    public.abstract.int 'Perimeter' { get; };

    public.abstract.void 'Draw' ();

    public.abstract.event 'Clicked';
}

class 'Rectangle' : extends 'Shape' {
    private.int '_width';
    private.int '_height';

    public.constructor {
        { arg.int; arg.int };
        function(this, width, height)
            this._width = width;
            this._height = height;
        end
    }

    public.override.int 'Area' {
        get (function(this)
            return this._width * this._height;
        end);
    }

    public.override.int 'Perimeter' {
        get (function(this)
            return 2 * (this._width + this._height);
        end);
    }

    public.override.void 'Draw' (function(this)
        print("Drawing a rectangle");
    end)
}
```

## Abstract Members
Abstract members define a contract that derived classes must implement using the `override` modifier. Abstract members must be prefixed with the `abstract` keyword or the `abstract` modifier and cannot contain a body. They are used to enforce a consistent interface across subclasses.

### Abstract Properties
Abstract properties must be implemented by derived classes:
```lua
public.abstract.class 'Shape' {
    public.abstract.int 'Area' { get; };
    public.abstract.int 'Perimeter' { get; };
}
```

### Abstract Methods
Abstract methods must be implemented by derived classes:
```lua
public.abstract.class 'Shape' {
    public.abstract.void 'Draw' ();
}
```

### Abstract Events
Abstract events must be implemented by derived classes:
```lua
public.abstract.class 'Shape' {
    public.abstract.event 'Clicked';
}
```
# Remarks
- Abstract classes cannot be instantiated directly.
- Abstract members cannot contain a body and must be implemented by derived classes.
- Abstract members cannot be static or private.
