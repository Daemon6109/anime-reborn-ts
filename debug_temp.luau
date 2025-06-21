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
return 42end

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
