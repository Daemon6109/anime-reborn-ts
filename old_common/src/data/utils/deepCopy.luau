--[=[
	Performs a deep copy of the given table, recursively copying all nested tables.
	Non-table values are returned as-is.

	@param original T -- The value or table to deep copy.

	@return T -- A deep copy of the original value or table.

	```lua
	local original = { a = 1, b = { c = 2 } }
	local copy = deepCopy(original)
	print(copy) -- { a = 1, b = { c = 2 } }
	```
]=]
local function deepCopy<T>(original: T): T
	if type(original) ~= "table" then
		return original
	end

	local copy = {}
	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = deepCopy(value)
		else
			copy[key] = value
		end
	end

	return (copy :: any) :: T
end

return deepCopy
