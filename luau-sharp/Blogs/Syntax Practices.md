**Author:** Amir Ghareebdost
**Date:** 12/12/2024

# Syntax Practices
In this article, I'll be overviewing out a comprehensive guide on how to write the 'cleanest' L# code with specific guidelines and rules to follow.


## Class Definition
When defining lambda classes (classes not part of any assembly or namespace), always declare your classes as local variables. It will improve performance when accessing them.
```lua
-- Do this
MyClass = class 'MyClass' {
	--...
}

local x = MyClass.new();

-- DON'T do this
class 'Foo' {
	public.meta.__call (function()
		print("Foo")
	end)
}

local y = Foo.new();

y()
```