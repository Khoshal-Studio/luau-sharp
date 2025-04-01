# Definition
`IAccessModifier` is an interface that defines the access modifiers for object members. Access modifiers are used to control the visibility of objects members. The `IAccessModifier` interface is implemented by the `public`, `protected`, and `private` keywords.

# Interface
```lua
type IAccessModifier = {
    get: <T>((this) -> T) & {
        __type: 'accessor',
        __visibility: 'public',
        __accessor: 'get'
    },

    set: <T>((this, value: T) -> ()) & {
        __type: 'accessor',
        __visibility: 'public',
        __accessor: 'set'
    },

    -- Base types
    interface: any,
    class: any,
    -- Data types
    boolean: any,
    number: any,
    string: any,
    table: any,
    callback: any,
    userdata: any,
    thread: any,
    int: any,
    uint: any,
    float: any,
    

    static: any,
    dynamic: any,
    abstract: any,
    override: any,
    virtual: any,
    sealed: any,
    readonly: any,
}
```