# class.ByName

## Definition
The `class.ByName` method is used to access a class by its name. This method returns the class object if it exists, otherwise it returns `nil`.

```lua
local classObject = class.ByName(className)
```
### Parameters
- `className` (string): The name of the class to retrieve.

### Returns
- `classObject` (table): The class object if it exists; otherwise, `nil`.

## Examples

### Example 1: Accessing an Existing Class
```lua
-- Define a class
class 'Person' {
    public.string 'Name';
    public.constructor {
        { arg.string };
        function(this, name)
            this.Name = name;
        end
    }
}

-- Access the class by name
local PersonClass = class.ByName('Person')
if PersonClass then
    local personInstance = PersonClass.new('John Doe')
    print(personInstance.Name)  -- Output: John Doe
else
    print('Class not found')
end
```

### Example 2: Attempting to Access a Non-Existent Class
```lua
local NonExistentClass = class.ByName('NonExistent')
if NonExistentClass then
    print('Class found')
else
    print('Class not found')  -- Output: Class not found
end
```

## Remarks
- The `class.ByName` method is useful for dynamically accessing classes by their names, especially in scenarios where the class name is determined at runtime.
- If the specified class does not exist, the method returns `nil`.

## See Also
- [[Documentation/Keywords/class]]
- [class Library](#class-library)