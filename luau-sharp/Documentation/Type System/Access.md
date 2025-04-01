# `access` keyword
The access keyword is used to retreive the Type object of any type in the script's scope. It takes a single string argument, which is the name of the type to be accessed. The type object is then returned, which can be used to access the type's members. Access will return nil if the type is not found.

It's essentially just a shorthand for `LuauSharp.GetGlobalType`.

```lua
local stringType = access 'string'
print(stringType)
--[[
Output:
{
    TypeName = "string",
    TypeKind = "primitive",
    Types = {},
    IsNever = false
}
]]

type.new 'Foo' (union ('string', 'number'))
local fooType = access 'Foo'
print(fooType)

--[[
Output:
{
    TypeName = "Foo",
    TypeKind = "union",
    Types = {
        [1] = {ConstituentType = "reference", Value = "string"},
        [2] = {ConstituentType = "reference", Value = "number"}
    },
    IsNever = true,
}
]]

type.new 'Bar' (literal ('Red', 'Green', 'Blue'))
local barType = access 'Bar'
print(barType)

--[[
Output:
{
    TypeName = "Bar",
    TypeKind = "union",
    Types = {
        [1] = {ConstituentType = "raw", Value = {
            TypeKind = "literal",
            Value = "Red",
        }},
        [2] = {ConstituentType = "raw", Value = {
            TypeKind = "literal",
            Value = "Green",
        }},
        [3] = {ConstituentType = "raw", Value = {
            TypeKind = "literal",
            Value = "Blue",
        }}
    },
    IsNever = false
}
]]
```

## What is the use case for this feature?
When you need to access a type through its object, rather than reference. The Type object allows you to access the type's members, such as its type arguments, constraints, and other properties. 

# Example
```lua
type.new 'Foo' (union ('string', 'number'))

type.new 'StringAlias' (System.TypeLib.UnionExclude (access 'Foo', 'number'))
```

Normally you would have to write it out like:

```lua
type.new 'StringAlias' (System.TypeLib.UnionExclude (LuauSharp.GetGlobalType 'Foo', 'number'))
```