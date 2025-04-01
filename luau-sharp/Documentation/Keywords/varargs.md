# Definition
The `varargs` keyword specifies variadic arguments when describing the nature of arguments to a L# overloadable function.

# Example
```lua
local arg_list = {
	varargs.string;
}
```
The snippet above indicates an argument specification of variadic strings. What this means is that the function will take any amount of strings after `varargs` is declared, and no other arguments can be declared after `varargs` is used, otherwise it will throw a `System.Exceptions.ArgumentSpecificationException`.

# Remarks
- `varargs` can only be used once in an argument list.
- `varargs` must be the last argument in the argument list.