# Sealed Types
A sealed type is a type that cannot be extended or implemented. In L#, sealed types are used to create a type hierarchy that restricts inheritance and implementation. Sealed types are useful for defining a set of types that are complete and should not be modified. Sealed types can be used to create a closed set of types that are guaranteed to be the only types in a given context.

## Declaring a Sealed Type
To declare a sealed type in L#, use the `type.sealed` declaration. This declaration specifies that the type is sealed and cannot be extended or implemented. Sealed types can have properties, methods, and constraints like any other type.

### Simple Sealed Type
```lua
public.type.sealed 'Shape' {
    public.number 'area';
    public.number 'perimeter';
}
```