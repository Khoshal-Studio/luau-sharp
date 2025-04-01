# `exclude` keyword
An exclusion type is a type that contains all types except for the specified types. In L#, exclusion types are used to create a type that excludes a set of types. Exclusion types are useful for defining a type that should not be used in a given context.

## Declaring an Exclusion Type
Use the `exclude` keyword to declare an exclusion type in L#. This keyword specifies that the type is an exclusion type and contains all types except for the specified types.

### Simple Exclusion Type
```lua
public.type 'notnil' (exclude ('any', 'nil'));
```

### Exclusion Type with Generic Type Parameters
```lua
public.type 'Exclude' {
    type_args (
        generic 'T';
        generic 'U'
    );

    exclude ('T', 'U')
}
```

Note that you cannot create an exclusion type with a single type. An exclusion type must exclude at least two distinct but not disjoint types.

### Error Examples
```lua
-- Error: Exclusion type must exclude at least two distinct but not disjoint types.
public.type 'Exclude' {
    type_args (
        generic 'T'
    );

    exclude ('T')
}

-- Error: Exclusion type must exclude at least two distinct but not disjoint types.
-- These types are distinct but they are disjoint, so the exclusion type will evaluate to the base type because there are no types to exclude.
public.type 'Exclude' (exclude ('string', 'number'))
```

The code above is an example of a disjoint exclusion type. The exclusion type must exclude at least two distinct but not disjoint types. The type will evaluate to the base type if the exclusion type is disjoint, because there's nothing to exclude.

## Singleton Exclusion
Singleton exclusion can be used on a single type to create an exclusion type that excludes only that type. This is useful for creating a type that excludes a single type.
These obviously only can be used on singleton compatible types, that is `string`, `number` and `boolean` along with their derived types.

```lua
public.type 'everyWordExceptHello' (exclude ('string', literal 'hello'))

local HelloWrapper = class 'HelloWrapper' {
    public.everyWordExceptHello 'word';
}

local hello = HelloWrapper.new()
hello.word = 'hello' -- Error: Value of type 'string' is not of type 'everyWordExceptHello'
```

## Arguments

### Generic Arguments

#### `T : primitive` 
The type to exclude. Primitive types include `string`, `number`, and `boolean`.

### Parameters

#### `base_type : T`
The base type of the exclusion type. The exclusion type will contain all types except for the specified types.

#### `exclusion_type : T`
The types to exclude. To exclude multiple types, you must create a union type of the types to exclude.

# Remarks
Exclude cannot be used on custom types, similarly to many of the other type operators.