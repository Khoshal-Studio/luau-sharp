local keywords = {
    ["and"] = true,
    ["break"] = true,
    ["do"] = true,
    ["else"] = true,
    ["elseif"] = true,
    ["end"] = true,
    ["false"] = true,
    ["for"] = true,
    ["function"] = true,
    ["if"] = true,
    ["in"] = true,
    ["local"] = true,
    ["nil"] = true,
    ["not"] = true,
    ["or"] = true,
    ["repeat"] = true,
    ["return"] = true,
    ["then"] = true,
    ["true"] = true,
    ["until"] = true,
    ["while"] = true,
    ["continue"] = true,
    
    -- LuauSharp specific keywords
    ["class"] = true,
    ["namespace"] = true,
    ["extends"] = true,
    ["implements"] = true,
    ["constructor"] = true,
    ["destructor"] = true,
    ["static"] = true,
    ["override"] = true,
    ["abstract"] = true,
    ["virtual"] = true,
    ["sealed"] = true,
    ["readonly"] = true,
    ["async"] = true,
    ["await"] = true
}

local unofficialKeywords = {
    ["self"] = true,
    ["this"] = true
}

return {
    keywords = keywords,
    unofficialKeywords = unofficialKeywords,
}