# Examples

Here are some examples of how to use LuauSharp.

## Hello World

```luau
local LuauSharp = require("LuauSharp")

local fooClass = LuauSharp.class "Foo" {
    constructor (function(self)
        print("Hello World!")
    end)
}

local foo = fooClass.new()
-- Output: Hello World!
```

## Inheritance

```luau
local LuauSharp = require(path.to.luau.sharp)
local class = LuauSharp.class
local type = LuauSharp.type
local generic = LuauSharp.generic
local constructor = LuauSharp.constructor
local arg = LuauSharp.arg

local types = require("./AutoGenTypes")

local fooClass = class "Foo" {
    constructor (function(self)
        print("Foo")
    end)
}

local stringNumber = type.union('string', 'number')

local stringNumberList = type.indexer('number', stringNumber)

local generic_list = type.generic (
    args { 
        generic 'T' : constrain ('string', 'number', 'boolean')
        -- When using constrain all the types are packed into a union type. Why? Because the generic type can be any of the types specified in the constrain. 
    },

    function(generics)
        return type.indexer('number', generics.T)
    end
)


local barClass: types.barClass = class : extends (fooClass) 
{
    public.constructor {
        { 
            arg 'string',
            arg 'number',

            arg.optional (stringNumberList, {1, 2, 3}),
            -- Notice how we can use the optional keyword to specify optional arguments.
            -- We can also specify a default value for the optional argument.
            -- You cannot have optional arguments before required arguments, all optional arguments must after all required arguments.
        };
        
        base (function(self, a: string, b: number, c: types.stringNumberList)
            return a, b, c
            -- used to pass the arguments to the base class constructor
            -- can be omitted if you don't need to pass arguments to the base class constructor
        end)

        function(self, a: string, b: number, c: types.stringNumberList)
            print("Bar", a, b, c[1])
        end
    };

    public.static 'Print' {
        { arg 'string' },
        function(a: string)
            print(a)
        end
    };
}

-- Notice how we can use built-in types like 'number' and 'string' as well as custom types like 'stringNumber' and 'stringNumberList', and the built in types are inferred correctly. Use strings in the argument definition only when you are accessing a base type like 'string' or 'number'.

-- Notice how we have static method in the class. Static methods are accessed using the class name.
barClass.Print("Hello World!")

local bar = barClass.new()
-- Output: Foo
-- Output: Bar
-- Notice how the constructor of the base class is called first. You can also access the base class by using self.__base.
```