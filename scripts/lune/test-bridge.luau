-- Lune bridge for executing Roblox globals in tests
-- This script receives test code and executes it in the real Luau runtime
-- Results are returned as JSON to stdout for Node.js Jest consumption

local stdio = require("@lune/stdio")
local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

-- Helper function to safely serialize values to JSON
local function serializeValue(value)
	local valueType = type(value)

	if valueType == "nil" then
		return nil
	elseif valueType == "boolean" or valueType == "number" or valueType == "string" then
		return value
	elseif valueType == "table" then
		local result = {}
		for k, v in pairs(value) do
			result[tostring(k)] = serializeValue(v)
		end
		return result
	else
		-- For functions, threads, etc., return type info
		return {
			_type = valueType,
			_string = tostring(value),
		}
	end
end

-- Main execution function
local function executeTestCode(code)
	-- Create the full test script with Roblox globals
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

-- Mock script object for require() calls
local script = {
	Name = "MockScript",
	Parent = {
		Parent = {
			shared = {
				data = {
					utils = {
						validate = function(data, template)
							-- Simple validation: check if all template keys exist in data
							if not data or not template then return false end
							for key, _ in pairs(template) do
								if data[key] == nil then return false end
							end
							return true
						end
					},
					["data-template"] = {
						Level = 1,
						XP = 0,
						RobuxSpent = 0,
						CurrentTitle = "",
						EquippedMount = "",
						SlotsApplicable = 3,
						PlayerStatistics = {
							Kills = 0,
							TotalDamage = 0,
							GamesPlayed = 0,
							PlayTime = 0,
						},
						Currencies = {
							Gold = 0,
							Gems = 500,
						},
						Settings = {},
						Inventory = {
							Units = {},
							Items = {},
							MaxUnitStorage = 100
						},
						_version = 6
					}
				}
			}
		}
	}
}

-- Mock require function for Roblox-style module loading
require = function(modulePath)
	-- Handle script.Parent.Parent.shared.data.utils.validate type paths
	if type(modulePath) == "table" and tostring(modulePath) then
		local pathStr = tostring(modulePath)
		if string.find(pathStr, "validate") then
			return script.Parent.Parent.shared.data.utils.validate
		end
		if string.find(pathStr, "data%-template") then
			return script.Parent.Parent.shared.data["data-template"]
		end
	end
	
	-- Fallback for other modules
	return {}
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

-- Test result storage for setTestResult function
local testResult = nil

-- Helper function for tests to set results
local function setTestResult(result)
	testResult = result
end

-- User test code starts here
local function runTest()
]] .. "\n" .. code .. "\n" .. [[
end

-- Execute the test and capture result
local success, result = pcall(runTest)

-- If testResult was set via setTestResult, use that instead
if testResult ~= nil then
	result = testResult
end

local output = {
	success = success,
	result = result,
	error = success and nil or tostring(result)
}

-- Print result as JSON
local serde = require("@lune/serde")
print(serde.encode("json", output))
]]

	-- Write to a temporary file
	local tempFile = "temp_test_" .. math.random(1000000) .. ".luau"
	fs.writeFile(tempFile, fullScript)

	-- Execute the temporary file
	local result = process.exec("lune", { "run", tempFile })

	-- Clean up
	fs.removeFile(tempFile)

	-- Parse the output
	if result.ok then
		local parseSuccess, parsedOutput = pcall(function()
			return serde.decode("json", result.stdout)
		end)

		if parseSuccess and parsedOutput then
			return parsedOutput
		else
			return {
				success = false,
				error = "Failed to parse output: " .. result.stdout,
				result = nil,
			}
		end
	else
		return {
			success = false,
			error = "Execution failed: " .. result.stderr,
			result = nil,
		}
	end
end

-- Handle command line arguments
local args = process.args

if #args > 0 and args[1] == "--execute" then
	-- Direct execution mode
	local code = args[2]
	if not code then
		print("Error: No code provided")
		process.exit(1)
	end

	local result = executeTestCode(code)
	print(serde.encode("json", result))

	if not result.success then
		process.exit(1)
	end
else
	-- Interactive mode - read from stdin
	stdio.write("Lune Test Bridge - Ready for test execution\n")
	stdio.write("Send JSON commands with 'code' field\n")

	while true do
		local input = stdio.prompt("")
		if not input or input == "exit" then
			break
		end

		-- Try to parse as JSON
		local success, command = pcall(function()
			return serde.decode("json", input)
		end)

		if success and command and command.code then
			local result = executeTestCode(command.code)
			print(serde.encode("json", result))
		else
			print(serde.encode("json", {
				success = false,
				error = "Invalid command format. Expected JSON with 'code' field.",
				result = nil,
			}))
		end
	end
end
