# Definition
Classes are the building blocks of object-oriented programming in L#. A class is a blueprint for creating objects (a particular data structure), providing initial values for state (member variables or fields), and implementations of behavior (member functions or methods). Classes are defined using the `class` keyword, followed by the class name and the class body.

Classes can also be defined using any access modifier (public, private, protected) and is required when defining a class in a namespace. Classes can also be defined as static, abstract, or sealed.

# Syntax
```lua
class 'ClassName' {
    -- Class members and methods
}
```

## Example
```lua
class 'Person' {
    private.string '_name';
    private.int '_age';

    public.constructor {
        { arg.string; arg.int };
        function(this, name, age)
            this._name = name;
            this._age = age;
        end
    }

    public.string 'Name' {
        get (function(this)
            return this._name;
        end);
    }

    public.int 'Age' {
        get (function(this)
            return this._age;
        end);
    }

    public.void 'Greet' {
        { arg.string };
        function(this, greeting)
            print(greeting .. ", my name is " .. this._name);
        end
    }
}
```

# Class Modifiers

## `static`
A static class cannot be instantiated and can only contain static members (fields, properties, methods, events). Static classes are used to organize utility methods and properties that do not require any instance data.

Static classes are defined by calling the class method of the static keyword before the class name. Static classes cannot be instantiated, and all members must be static, that is, prefixed with the `static` keyword before the datatype and member name.
```lua
static.class 'Math' {
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
```

### Static Members
Static members belong to the class itself rather than any instance. They are shared across all instances of the class. Static members can be accessed using the class name, as when a class is defined, it is injected into the global namespace.
```lua
class 'Counter' {
    public.static.int 'Count' (0);

    public.static.void 'Increment' (function()
        Counter.Count = Counter.Count + 1;
    end)
}
```

## `abstract`
Refer to [[abstract]].

## `sealed`
A sealed class cannot be inherited and can only be used as a base class. Sealed classes are used to prevent further derivation of a class. Sealed classes are declared by using the `sealed` keyword before the class keyword or by indexing an access modifier with the `sealed` key.

```lua
sealed.class 'Base' {
    public.int 'Value' (0);
}
```

### Sealed Members
Sealed members are members that are not inherited by derived classes. Sealed members are declared by using the `sealed` keyword before the member keyword or by indexing an access modifier with the `sealed` key.

```lua
class 'Base' {
    public.sealed.int 'Value' (0);
}

class 'Derived': extends 'Base' {
    public.constructor {
        { arg.int };
        function(this, value)
            this.Value = value;
            -- Error: 'Value' does not exist in 'Derived'
        end
    }
}
```

# Declaration Modifiers

## `extends`
A class can be derived from by calling `extends` method before the class body. The class can only extend one class, but it can implement multiple interfaces. L# does not support multiple inheritance, but this may change in the future.
```lua
class 'Employee': extends 'Person' {
    private.string '_position';

    public.constructor {
        { arg.string; arg.int; arg.string };
        function(this, name, age, position)
            base(name, age);
            this._position = position;
        end
    }

    public.string 'Position' {
        get (function(this)
            return this._position;
        end);
    }
}
```

## `implements`
A class can implement one or more interfaces by calling the `implements` method and passing the interface name(s) as arguments. The class must implement all the methods defined in the interface(s).
```lua
interface 'IWork' {
    public.abstract.void 'Work' ();
}

class 'Employee': extends 'Person': implements 'IWork' {
    private.string '_position';

    public.constructor {
        { arg.string; arg.int; arg.string };
        function(this, name, age, position)
            base(name, age);
            this._position = position;
        end
    }

    public.string 'Position' {
        get (function(this)
            return this._position;
        end);
    }

    public.void 'Work' {
        function(this)
            print("Working as " .. this._position);
        end
    }
}
```

# Access Modifiers
Classes can have members with different access levels. These access modifiers only make a difference when the class is defined in a namespace.
- `public`: Accessible from anywhere.
- `private`: Accessible only within the class.
- `protected`: Accessible within the class and its subclasses.

# class Library
While the `class` keyword is used to define classes, the `class` library is used to interact with classes. The `class` library provides methods to create, access, and manipulate classes, interfaces, enums, and other types defined in the script.

## Methods

### `class.ByName`
The `class.ByName` method is used to access a class by its name. This method returns the class object if it exists, otherwise it returns `nil`.

```lua
local Person = class.ByName('Person');
```


# Under The Hood
When a class is defined, it is injected into the script's global namespace. Classes can be accessed using the class name or using `class.ByName('ClassName')`.
The L# manager creates an internal scope for all scripts that interface with the L# runtime. This scope is used to store all classes, interfaces, enums, and other types defined in the script. Additionally, the `using` directive is used to import namespaces into the script's global namespace. 

L# essentially compartmentalizes the script's global namespace, allowing for better organization and separation of concerns. This is especially useful when working with multiple scripts or when importing external libraries.

# Remarks
Class definitions are subject to the following rules:
- The class name must be a valid identifier (alphanumeric characters and underscores, starting with a letter). 
- If the class is defined in a namespace, the class name must be unique within the namespace.
- The class body can contain fields, properties, constructors, methods, and events.
- The class body can also contain nested classes, structs, and interfaces.
- The class body can contain access modifiers, static, abstract, and sealed modifiers.
- The class body can contain the `extends` and `implements` methods to derive from a base class and implement interfaces, respectively.