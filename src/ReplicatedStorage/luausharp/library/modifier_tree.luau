local MODIFIER_TREE = {
    class = {
        private = false
    },

    method = {
        -- All combinations of modifiers are allowed
    },

    field = {
        -- All combinations of modifiers are allowed
    }
}

-- The possible modifiers for a class, method, or field. 
-- If a modifier is  present, it is assumed to not be allowed.

export type class_modifier_chain = {
    static: boolean,
}

export type method_modifier_chain = {
    access_modifier: "public" | "private" | "protected",
    static: boolean,
    void: boolean,
}

export type field_modifier_chain = {
    access_modifier: "public" | "private" | "protected",
    static: boolean,
    readonly: boolean,
}

export type universal_modifier_chain = {
    access_modifier: "public" | "private" | "protected",
    static: boolean,
    void: boolean,
    readonly: boolean,
    class: boolean,
}

local function infer_modifier_chain_type(chain: any): any
    if chain.access_modifier then
        return "class"
    elseif chain.void then
        return "method"
    elseif chain.readonly then
        return "field"
    end

    return "method"
end

local function validate_modifier_chain(chain: class_modifier_chain | method_modifier_chain | field_modifier_chain)
    local access_modifier = chain.access_modifier
    local modifier_rules = MODIFIER_TREE.class[access_modifier] -- Get rules for classes

    for key, value in pairs(chain) do
        if key ~= "access_modifier" and modifier_rules[key] == false then
            error(`Invalid modifier combination: {key} cannot be used with {access_modifier}`)
        end
    end
end

local ACCESS_MODIFIERS = {
    public = true,
    private = true,
    protected = true,
}

local DATATYPES = {
    number = true,
    string = true,
    boolean = true,
    table = true,
    callback = true,
    userdata = true,
	thread = true,
	int = true
}

return {
    TREE = MODIFIER_TREE,
    ACCESS_MODIFIERS = ACCESS_MODIFIERS,
    DATATYPES = DATATYPES,
}