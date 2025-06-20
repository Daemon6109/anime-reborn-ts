-- Compiled with roblox-ts v2.3.0
-- Deep copy utility for immutable data operations
local function deepCopy(obj)
	local _obj = obj
	if typeof(_obj) ~= "table" then
		return obj
	end
	local copy = {}
	local objTable = obj
	for key, value in pairs(objTable) do
		if typeof(value) == "table" then
			copy[key] = deepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end
return {
	deepCopy = deepCopy,
}
