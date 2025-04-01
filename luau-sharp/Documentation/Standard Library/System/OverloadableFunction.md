# Definition
A class for creating and managing a list of overloads for a function. This class is used to store multiple function definitions that share the same name but have different parameter lists. The `OverloadableFunction` class is used to define a function that can be called with different sets of arguments, allowing for polymorphism in Lua.

```lua
public.class 'OverloadableFunction' {
    type_args (
        generic 'ReturnType';
    )

    public.constructor {
        { arg.string 'name' };
        function(this, name)
            this.Name = name;
            this.Overloads = {};
        end
    };

    public.meta.__call = {
        { arg.table 'args' };
        function(this, args)
            return this:Invoke(args);
        end
    };

    public.ReturnType 'Invoke' {
        { arg.table 'args' };
        function(this, args)
            return this:Match(args);
        end
    };

    public.nullable.callback 'Match' {
        { arg.table 'args' };
        function(this, args)
            for _, overload in ipairs(this.Overloads) do
                if overload:Match(args) then
                    return overload:Invoke(args);
                end
            end
            
            return nil;
        end
    };
}
```