local lexer = require("../lexer")

local tests = {
    "local a = 1",
    "local x = 'Hello This is A test with Quotes, like this \" and this \\ and this \n and this \t'",
    "(1 + 2) * 3",
}

local function test(input: string)
    local lexerInstance = lexer.new()
    local tokens = lexerInstance:tokenize(input)

    for _, token in tokens do
        -- pretty print the token type and value
        print(string.format("Token Type: %s, Value: %s", token.type, token.value))
    end
end

for _, testInput in tests do
    print("Testing input: " .. testInput)
    test(testInput)
end
