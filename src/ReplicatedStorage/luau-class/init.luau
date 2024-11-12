--!nonstrict

---------------------------------------------------------------------------------------------------------------------------

local module = {}

---------------------------------------------------------------------------------------------------------------------------

local HttpService = game:GetService("HttpService")

---------------------------------------------------------------------------------------------------------------------------

local dependencies = script:WaitForChild("dependencies")


local t = require(dependencies.t)
local get_type = require(script.get_type)
local types = require(script:WaitForChild("types"))

---------------------------------------------------------------------------------------------------------------------------

local JsonDecode = function(value: string): any
    return HttpService:JSONDecode(value)
end

local JsonEncode = function(value: any): string
    return HttpService:JSONEncode(value)
end

local primitive_types = {
    "string",
    "number",
    "boolean",
    "table",
    "function",
    "userdata",
    "thread"
}

local Types = {
    String = "string",
    Number = "number",
    Boolean = "boolean",
    Table = "table",
    Void = "void",
    Userdata = "userdata",
    Thread = "thread",
    Callback = "function",
    Int = "int",
    Float = "float",
    Nil = "nil"
}

type input_constructor = {
    args: {arg},
    constructor: (any) -> nil,
}

type arg = {
    type: string,
    required: boolean,
}

type args = {
    min: number,
    max: number,
    list: {arg},
}

type type_builder<T> = ((name: string) -> ((value: T) -> {})) & (required: boolean) -> {}


-- type input arg = {[1] type: string, [2] required: boolean}

type constructor = {
    args: args,
    constructor: (any) -> nil,
}

type member = {
	name: string,
	value: any,
}

type private_member = member
type public_member = member

type class_input = {
    [number]: member, 
}

type internal_class = {
    constructors: {constructor},
    public_members: {public_member},
	static_members: {public_member},
	static_values: {}
}

local datatypes = {}

local classes: {[string]: internal_class} = {}
local namespaces = {}

local function make_args(input): args
    local args = {
        min = 0,
        max = 0,
        list = {},
    }
    
	for i, arg in ipairs(input) do
        assert(t.table(arg), "Argument must be an array.")
        assert(t.string(arg[1]), "Argument type must be a string.")
        assert(t.boolean(arg[2]), "Argument required must be a boolean.")
        
        local arg_type = arg[1]
        local arg_required = if arg[2] == nil then true else arg[2]
        
        args.max += 1
        args.min += if arg_required then 1 else 0
        
        assert(table.find(primitive_types, arg_type) or classes[arg_type], "Unknown argument type: "..tostring(arg_type))

        args.list[i] = {
            type = arg_type,
            required = arg_required,
        }
    end
    
    return args
end

local function class(class_name: string): (class: {}) -> nil
    return function(class: {})
        local class_name = class[1]

        local public_members = {}
        local constructors = {}
        
        for key, value in class do
            if value.name == class_name then
                local constructor: input_constructor = value.value
                local args_list = make_args(constructor.args)

                constructors[#constructors + 1] = {
                    args = args_list,
                    constructor = constructor.constructor,
                }
            end
        end

        if #constructors == 0 then
            constructors[1] = {
                args = {
                    list = {},
                    min = 0,
                    max = 0,
                },
                constructor = function() end,
            }
        end

        classes[class_name] = {
            constructors = constructors,
            public_members = public_members,
            static_members = {},
            static_values = {}
        }
    end
end

local _new_namespace = function(namespace_name: string, namespace: any)
    if not namespaces[namespace_name] then
        namespaces[namespace_name] = namespace
    else
        for key, value in pairs(namespace) do
            namespaces[namespace_name][key] = value
        end
    end
end

local function match_constructor_with_args(class_name: string, ...): constructor?
    local args = {...}
    local class = classes[class_name]
    local constructors = class.constructors

    for _, constructor in constructors do
        local constructor_args = constructor.args
        local arg_count = #args

		if (arg_count >= constructor_args.min) and (arg_count <= constructor_args.max) then
			print("Count match")
            local valid = true

            for arg_index, arg in ipairs(constructor_args.list) do
                local arg_type = arg.type
                local arg_required = arg.required

                if arg_required and not args[arg_index] then
					valid = false
					break
                end

				if get_type(args[arg_index]) ~= arg_type then
					valid = false
					break
				end
            end 

            if valid then
                return constructor
            end
        end
    end

    return nil
end

local function _new(class_name: string, ...)
    local class = classes[class_name]
    local instance = {}
    
    local constructor = match_constructor_with_args(class_name, {...})

	if constructor then
		print(constructor)
        constructor.constructor(instance, ...)
    end

    -- populate instance with public members
    for key, value in pairs(class.public_members) do
        instance[key] = value
    end

    local metatable = {
        __index = class,
        __newindex = function(_, k, _): nil
            error("Attempt to index a " .. get_type(k) .. " with a " .. class_name .. ".", 2)
        end,
        __metatable = {
            __type = class_name,
        },
    }

    setmetatable(instance, metatable)
    
    return instance
end

local str: type_builder<string> = function(arg_1: string | boolean)
    if typeof(arg_1) == "boolean" then
        return {Types.String, arg_1}
    end

    if arg_1 ~= nil then
       assert(typeof(arg_1) == Types.String) 
    end

    return function(value: string?)
        return {Types.String, arg_1, value}
    end
end

local num: type_builder<number> = function(arg_1: string | boolean)
    if typeof(arg_1) == "boolean" then
        return {Types.Number, arg_1}
    end

    if arg_1 ~= nil then
       assert(typeof(arg_1) == Types.Number) 
    end

    return function(value: number?)
        return {Types.Number, arg_1, value}
    end
end

local method = function(name: string)
    return function(method: {})
        local input_args = method[1]
        local method_fn = method[2]

        local args = make_args(input_args)
    end
end

local function main()
	-- class "Person" {
    --     public.str "Name" "John";
    --     public.num "Age" (1);

    --     public.method "IncrementAge" {
    --         {
    --             num (false);
    --         };

    --         function(this, amount: number?)
    --             this.age += amount or 1
    --         end
    --     };

    --     constructor {
    --         {
    --             str (true);
    --             num (true);
    --         };

    --         function(this, name: string, age: number)
    --             this.name = name;
    --             this.age = age;
    --         end 
    -- }};
	
	-- local person: any = _new("Person", "John", 20)
	-- print(person, get_type(person), getmetatable(person))
	-- print(person.name, person.age)
end

main()



---------------------------------------------------------------------------------------------------------------------------

return module