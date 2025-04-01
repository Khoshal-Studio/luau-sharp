-- [[ ============================================================================================== ]]-- 

local TOKEN_VALUES = {
    STRING_ESCAPE_CHAR = "\\",
    INEQUALITY = "!=",
    NEGATION = "!",
    EQUALITY = "==",
    ASSIGNMENT = "=",
}

local REGEX_TABLE = {
    IDENTIFIER = "^[A-Za-z_][A-Za-z0-9_]*$",
    QUOTE = "^[\"'`]$",
    NUMBER = "^[0-9]$",
    INEQUALITY = "^[!]$",
    OPERATOR = "^[=<>!+-/*%^&|~]$",
}

local TOKEN_TYPES = {
    IDENTIFIER = "IDENTIFIER",
    STRING = "STRING",
    FORMATTED_STRING = "FORMATTED_STRING",
    NUMBER = "NUMBER",
    R_PAREN = "R_PAREN",
    L_PAREN = "L_PAREN",
    R_BRACE = "R_BRACE",
    L_BRACE = "L_BRACE",
    OPERATOR = "OPERATOR",
    EOF = "EOF",
    EOS = "EOS"
}


local FORMATTED_STRING = "`"
local NUMBER_DELIMITER = "_"

local quote_regex = "^[\"'`]$"
local number_regex = "^[0-9]$"
local inequality_regex = "^[!]$"

-- [[ ============================================================================================== ]]-- 

local lexer = {}

lexer.__index = lexer

function lexer.new()
    local self = setmetatable({}, lexer)

    self.tokens = {}
    self.line = 1

    return setmetatable(self, lexer)
end

function lexer:tokenize(input)
    self.tokens = {}
    self.line = 1

    local i = 1
    while i <= #input do
        local char = input:sub(i, i)

        if char == #input then
            table.insert(self.tokens, {
                type = TOKEN_TYPES.EOF,
                value = nil,
                line = self.line,
            })
            break
        end

        if char == "\n" then
            self.line += 1
        elseif char:match("%s") then
            -- Ignore whitespace
        elseif char:match(REGEX_TABLE.IDENTIFIER) then
            local start = i
            while i <= #input and input:sub(i, i):match(REGEX_TABLE.IDENTIFIER) do
                i += 1
            end

            table.insert(self.tokens, {
                type = TOKEN_TYPES.IDENTIFIER, 
                value = input:sub(start, i - 1),
                line = self.line,
            })
        elseif char:match(quote_regex) then
            local start = i
            local quote = char

            i += 1
            while i <= #input and input:sub(i, i) ~= quote do
                if input:sub(i, i) == TOKEN_VALUES.STRING_ESCAPE_CHAR then
                    i += 1 -- String escape character
                end
                i += 1
            end

            if i > #input then
                error("Unterminated string at line " .. self.line)
            end

            table.insert(self.tokens, {
                type = if quote == FORMATTED_STRING then TOKEN_TYPES.FORMATTED_STRING else TOKEN_TYPES.STRING,
                value = input:sub(start + 1, i - 1),
                line = self.line,
            })
        elseif char:match(REGEX_TABLE.OPERATOR) then
            local cases = {
                ["="] = function()
                    local value = ""

                    if input:sub(i + 1, i + 1) == "=" then
                        i += 1 -- Skip the second '='
                        value = "=="
                    else
                        value = "="
                    end

                    return {
                        type = TOKEN_TYPES.OPERATOR,
                        value = value,
                        line = self.line,
                    }
                end,

                ["!"] = function()
                    local value = ""

                    if input:sub(i + 1, i + 1) == "=" then
                        i += 1 -- Skip the second '='
                        value = TOKEN_VALUES.INEQUALITY
                    else
                        value = TOKEN_VALUES.NEGATION
                    end

                    return {
                        type = TOKEN_TYPES.OPERATOR,
                        value = value,
                        line = self.line,
                    }
                end,

                ["<"] = function()
                    local value = "<"

                    if input:sub(i + 1, i + 1) == "=" then
                        i += 1 -- Skip the second '='
                        value = "<="
                    end

                    return {
                        type = TOKEN_TYPES.OPERATOR,
                        value = value,
                        line = self.line,
                    }
                end,

                [">"] = function()
                    local value = ">"

                    if input:sub(i + 1, i + 1) == "=" then
                        i += 1 -- Skip the second '='
                        value = ">="
                    end

                    return {
                        type = TOKEN_TYPES.OPERATOR,
                        value = value,
                        line = self.line,
                    }
                end,
            }

            if cases[char] then
                table.insert(self.tokens, cases[char]())
            else
                table.insert(self.tokens, {
                    type = TOKEN_TYPES.OPERATOR,
                    value = char,
                    line = self.line,
                })
            end
        elseif char:match(number_regex) then
            local start = i
            while i <= #input and input:sub(i, i):match(number_regex) or (input:sub(i, i) == "_" and input:sub(i - 1, i - 1):match(number_regex) and input:sub(i + 1, i + 1):match(number_regex)) do
                if input:sub(i, i) == NUMBER_DELIMITER then
                    i += 1 -- Skip underscore
                end
                i += 1
            end

            table.insert(self.tokens, {
                type = TOKEN_TYPES.NUMBER,
                value = tonumber(input:sub(start, i - 1)),
                line = self.line,
            })
        elseif char:match("[(){}]") then
            local cases = {
                ["("] = TOKEN_TYPES.L_PAREN,
                [")"] = TOKEN_TYPES.R_PAREN,
                ["{"] = TOKEN_TYPES.L_BRACE,
                ["}"] = TOKEN_TYPES.R_BRACE,
            }

            table.insert(self.tokens, {
                type = cases[char],
                value = char,
                line = self.line,
            })
        else
            error("Unexpected character: " .. char .. " at line " .. self.line)
        end

        i += 1
    end

    return self.tokens
end

return lexer
