local parser = {}

parser.__index = parser

parser.new = function(lexer)
    local self = setmetatable({}, parser)

    self.lexer = lexer
    self.currentToken = nil
    self.ast = {}

    return self
end

parser.parse = function(self, input)
    self.lexer:tokenize(input)
    self.currentToken = self.lexer:nextToken()

    while self.currentToken.type ~= TOKEN_TYPES.EOF do
        local node = self:parseStatement()
        if node then
            table.insert(self.ast, node)
        end
    end

    return self.ast
end