-- Debug version that saves the temp file
local stdio = require("@lune/stdio")
local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local code = "return 42"

local fullScript = [[
-- Roblox-like globals for testing
local typeof = function(value)
	local t = type(value)
	return t == "table" and "table" or t
end

local tick = function()
	return os.clock()
end

local wait = function(_duration)
	return 0
end

local task = {
	spawn = function(func, ...)
		local args = {...}
		return coroutine.create(function()
			func(unpack(args))
		end)
	end,
	defer = function(func, ...)
		local args = {...}
		return coroutine.create(function()
			func(unpack(args))
		end)
	end,
	wait = function(_duration)
		return 0
	end
}

-- User test code starts here
local function runTest()
]] .. code .. [[
end

-- Execute the test and capture result
local success, result = pcall(runTest)
local output = {
	success = success,
	result = result,
	error = success and nil or tostring(result)
}

-- Print result as JSON
local serde = require("@lune/serde")
print(serde.encode("json", output))
]]

local tempFile = "debug_temp.luau"
fs.writeFile(tempFile, fullScript)
print("Generated script:")
print(fullScript)
print("---")
print("File saved as:", tempFile)
