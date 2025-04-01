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
    num: (string) -> (number) -> (any) -> any,
    bool: (string) -> (boolean) -> (any) -> any
}

export type collection_type = 
    "List" | 
    "Dictionary"

export type collection_info = {
    collection_type: collection_type,
    value_type: string | collection_info,
    index_type: string?
}

export type member_interface = {[string]: (string) -> (...any) -> any} & members & {static: {[string]: (string) -> (any) -> any} & members}

-------------------------------------------------------------------------------------------------------------

export type List<T> = {
    __data: {T},
    __count: number,
    __type: string,
    __collection_type: collection_info,
    __validator: (any) -> boolean
}

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