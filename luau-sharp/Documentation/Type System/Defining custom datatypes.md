# Overview
In L#, custom datatypes are created using the `type.custom` declaration. This allows developers to define new datatypes with custom validation logic and constraints. Custom datatypes can be used to create type-safe, reusable components with specific behavior and constraints. Custom types can be independent or derived from existing datatypes, but all must have a validator function that enforces the type constraints.

## Basic Custom Datatype Declaration
When defining a custom datatype, use the `type.custom` declaration to specify the new datatype and its properties. The `from` keyword can be used to derive the new datatype from an existing datatype, inheriting its properties and constraints. 

When type-checking custom types that derive from existing types (including custom types), the L# type system will sequentially check the constraints of the ancestor types before checking the constraints of the derived type. 

## Simple Custom Datatype
```lua
public.type.custom 'decimal' : from 'number' (function (value)
	return value >= 0 and value <= 1;
end)
```

## `never`
The `never` datatype is a special type that represents a value that should never occur. It is useful for indicating unreachable code or invalid states. The `never` datatype has no valid values and is typically used as a return type for functions that should never return.

### Evaluating `never`
One of the problems with `never` is inferring whether a type can ever be satisfied. Below is an algorithm used to determine if a type can be `never`. Note that this algorithm is not exhaustive and may not cover all cases. Additionally, custom types are not considered in this algorithm because of the Halting Problem.

> [!question] FAQ
> ## Question 1
> **Why are custom types not considered in the `never` algorithm? What is the Halting Problem?**
> ## Answer 1
> The Halting Problem is a fundamental limitation in computer science that states it is impossible to determine whether a Turing-complete program will halt or run indefinitely. In the context of type inference, considering custom types would require analyzing the entire program's execution path, which is not feasible due to the Halting Problem. It is impossible to determine all possible types that a program can evaluate to. Custom types are user-defined types that can have arbitrary validation logic, making it difficult to determine if a type can be `never`. The reason why we can statically evaluate non-custom types is because the L# type system is a Turing-incomplete type system, meaning it has limitations on what it can express and evaluate. This allows us to make certain guarantees about the types that can be evaluated statically. Therefore, custom types are not considered in the `never` algorithm to avoid undecidable cases. 
> ## Question 2
> Why is it so important to determine if a type can be `never`? It seems like a niche case.
> ## Answer 2
> Because if we know a type is never we can optimize the runtime type validation and lint unreachable code. For example, if we had a program that constantly uses a never type that uses computationally expensive validation logic, we can optimize the program by skipping that validation logic entirely. Additionally, if we know a type is never, we can lint unreachable code paths, which can help identify bugs and improve code quality. While it may seem like a niche case, determining if a type can be `never` can have significant performance and code quality benefits in certain scenarios.


# `never` Evaluation Algorithm
1. **Explicit `never`**: If the type is explicitly defined as `never`, it is `never`.
```lua
public.type.base 'never'

public.type.custom 'NewNever' (function (value)
	return false;
end)
```
2. **Intersection Constraint**: If the type is an intersection of types, and at least one is `never`, it is `never`. 
3. **Union of `never` Types**: If the type is a union of types, and all are `never`, it is `never`.
4. **Union with Non-`never` Types**: If the type is a union of types, and at least one constituent does not evaluate to `never`, it is not `never`.
5. **Callback Return Type**: If the type is a `callback` type with a `never` return type, it is `never`.
6. **Impossible Function Arguments**: If the function type has at least one argument that evaluates to `never`, it is `never`.
7. **Interface Constraints**: If the type is an interface and at least one member evaluates to `never`, it is `never`. This is because interfaces are open-ended, and adding a member that is `never` would make the interface impossible to satisfy. 
8. **Disjoint Type Intersection**: If the type is an intersection of two fundamentally incompatible types, it is `never` (e.g., `number & string`). Disjoint means that the types don't have any common superset (other than `any` and `dynamic`), that is, they are mutually exclusive types.
9. **Deriving from `never`**: If a custom type is derived from `never`, it is `never`.
10. **Recursive Type**: If the type is a recursive type that evaluates to `never`, it is `never`. This is because in practice a recursive type would require infinite memory, which can't be allocated in a finite system.
11. **Deriving from Sealed Type**: If a custom type is derived from a sealed type that evaluates to `never`, it is `never`. Sealed types are types that cannot be extended or implemented, and deriving from a `never` sealed type would result in an impossible type. See [[Sealed Types]] for more information.
