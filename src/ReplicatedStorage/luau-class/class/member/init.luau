local function member(access_enum: number, datatype: string, name: string, value: any, static: boolean)
    return {access_enum, "member", name, value, static}
end