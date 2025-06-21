-- Simple test
local typeof = function(value)
	local t = type(value)
	return t == "table" and "table" or t
end

local function runTest()
	return 42
end

local success, result = pcall(runTest)
print("Success:", success)
print("Result:", result)
print("Type of result:", type(result))
