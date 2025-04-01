--!strict

-------------------------------------------------------------------------------------------------------------

local module = {}

-------------------------------------------------------------------------------------------------------------

local constants = require(script.Parent.constants)

-------------------------------------------------------------------------------------------------------------

export type members = {
    str: (string) -> (string) -> (any) -> any,
    List: (string) -> (string) -> (any) -> any,
    Dictionary: (string) -> (string) -> (any) -> any,
    Queue: (string) -> (any) -> any,
    num: (string) -> (number) -> (any) -> any,
    bool: (string) -> (boolean) -> (any) -> any
}

export type collection_type = 
    "List" | 
    "Dictionary" |
    "Queue"

export type collection_info = {
    collection_type: collection_type,
    value_type: string | collection_info,
    index_type: string?
}

export type member_interface = {[string]: (string) -> (...any) -> any} & members & {static: {[string]: (string) -> (any) -> any} & members}

-------------------------------------------------------------------------------------------------------------

export type Comparator<T> = (a: T, b: T) -> number
export type Predicate<T> = (value: T) -> boolean
export type Action<T> = (value: T) -> nil
export type Reducer<T> = (accumulator: number, value: T) -> number

export type Queue<T> = {
    -- Properties
    Count: number,
    Length: number,
    
    -- Methods
    GetType: (self: Queue<T>) -> string,
    Enqueue: (self: Queue<T>, value: T) -> (),
    Dequeue: (self: Queue<T>) -> T?,
    Peek: (self: Queue<T>) -> T?,
    Clear: (self: Queue<T>) -> (),
    Contains: (self: Queue<T>, value: T) -> boolean,
    IsEmpty: (self: Queue<T>) -> boolean,
    PeekLast: (self: Queue<T>) -> T?,
    Print: (self: Queue<T>) -> (),
    ForEach: (self: Queue<T>, action: (T) -> ()) -> (),
    GetRaw: (self: Queue<T>) -> {T},
    Find: (self: Queue<T>, predicate: (T) -> boolean) -> T?,
    FindAll: (self: Queue<T>, predicate: (T) -> boolean) -> Queue<T>,
    ToArray: (self: Queue<T>) -> {T}
}   

export type Dictionary<K, V> = 
{
    -- Properties
    Count: number,
    Length: number,
    Keys: {K},
    Values: {V},

    -- Methods
    GetType: (self: Dictionary<K, V>) -> string,
    Set: (self: Dictionary<K, V>, key: K, value: V) -> (),
    Remove: (self: Dictionary<K, V>, key: K) -> (),
    ContainsKey: (self: Dictionary<K, V>, key: K) -> boolean,
    ContainsValue: (self: Dictionary<K, V>, value: V) -> boolean,
    Clear: (self: Dictionary<K, V>) -> (),
    IsEmpty: (self: Dictionary<K, V>) -> boolean,
    Get: (self: Dictionary<K, V>, key: K) -> V,
    ForEach: (self: Dictionary<K, V>, action: (K, V) -> ()) -> (),
    Find: (self: Dictionary<K, V>, predicate: (K, V) -> boolean) -> (K?, V?),
    FindAll: (self: Dictionary<K, V>, predicate: (K, V) -> boolean) -> Dictionary<K, V>,
    ToTable: (self: Dictionary<K, V>) -> {[K]: V},
    ToArray: (self: Dictionary<K, V>) -> {[number] : {[number]: K | V}},
    Print: (self: Dictionary<K, V>) -> (),
    Exists: (self: Dictionary<K, V>, predicate: (K, V) -> boolean) -> boolean
}

export type List<T> = {
    -- Properties
    Count: number,
    Length: number,

    -- Methods
    GetType: (self: List<T>) -> string,
    Add: (self: List<T>, value: T) -> nil,
    Contains: (self: List<T>, value: T) -> boolean,
    Print: (self: List<T>) -> nil,
    Get: (self: List<T>, index: number) -> T,
    RemoveAt: (self: List<T>, index: number) -> nil,
    Clear: (self: List<T>) -> nil,
    IsEmpty: (self: List<T>) -> boolean,
    AddRange: (self: List<T>, values: {T}) -> nil,
    RemoveLast: (self: List<T>) -> boolean,
    Insert: (self: List<T>, value: T, index: number) -> nil,
    RemoveRange: (self: List<T>, index: number, endIndex: number) -> nil,
    RemoveAll: (self: List<T>, predicate: (T) -> boolean) -> nil,
    Remove: (self: List<T>, value: T) -> boolean,
    Find: (self: List<T>, predicate: (T) -> boolean) -> T?,
    FindAll: (self: List<T>, predicate: (T) -> boolean) -> List<T>,
    FindIndex: (self: List<T>, predicate: (T) -> boolean) -> number?,
    FindAllIndex: (self: List<T>, predicate: (T) -> boolean) -> {number},
    FindLast: (self: List<T>, predicate: (T) -> boolean) -> T?,
    FindLastIndex: (self: List<T>, predicate: (T) -> boolean) -> number?,
    TrueForAll: (self: List<T>, predicate: (T) -> boolean) -> boolean,
    IndexOf: (self: List<T>, value: T) -> number?,
    Sort: (self: List<T>, comparator: ((a: T, b: T) -> number)?) -> nil,
    Slice: (self: List<T>, startIndex: number, endIndex: number) -> List<T>,
    GetFirst: (self: List<T>) -> T?,
    GetLast: (self: List<T>) -> T?,
    ForEach: (self: List<T>, action: (T) -> nil) -> nil,
    Reverse: (self: List<T>) -> nil,
    LastIndexOf: (self: List<T>, value: T) -> number?,
    Exists: (self: List<T>, predicate: (T) -> boolean) -> boolean,
    GetRaw: (self: List<T>) -> {T},
    Average: (self: List<T>, reducer: (number, T) -> number) -> number,
    Sum: (self: List<T>, reducer: (number, T) -> number) -> number,
    Max: (self: List<T>, reducer: (number, T) -> number) -> number,
    Min: (self: List<T>, reducer: (number, T) -> number) -> number
}

export type hashset_list = {[any]: {
    __data: {},
    __count: number,
    __type: string,
    __collection_type: collection_info,
}}

export type Class = {
    name: string,
    members: {{
        visibility: "public" | "private",
        type: string,
        name: string,
        value: any
    }}
}

-------------------------------------------------------------------------------------------------------------

return nil

-------------------------------------------------------------------------------------------------------------