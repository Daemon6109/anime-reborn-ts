local stdio = require("@lune/stdio")
local serde = require("@lune/serde")
local process = require("@lune/process")
local luau = require("@lune/luau")

local args = process.args
if #args < 2 or args[1] ~= "--execute" then
	print("Usage: lune run test-bridge.luau --execute 'lua code'")
	process.exit(1)
end

local code = args[2]

-- Simple test execution
local function executeTest()
	-- Create a global environment for the user code
	local env = {}

	env.typeof = function(value)
		local t = type(value)
		return t == "table" and "table" or t
	end

	env.script = {
		Name = "MockScript",
		Parent = {
			Parent = {
				shared = {
					data = {
						utils = {
							validate = function(data, template)
								if not data or not template then
									return false
								end
								for key, _ in pairs(template) do
									if data[key] == nil then
										return false
									end
								end
								return true
							end,
						},
						["data-template"] = {
							PlayerData = { Username = "", Level = 0 },
							Settings = {},
							Stats = {},
						},
					},
				},
			},
		},
	}

	env.require = function(modulePath)
		-- In our mock, modulePath will be the actual object being required
		-- So if it's script.Parent.Parent.shared.data.utils.validate, we should return the validate function
		if modulePath == env.script.Parent.Parent.shared.data.utils.validate then
			return env.script.Parent.Parent.shared.data.utils.validate
		elseif modulePath == env.script.Parent.Parent.shared.data["data-template"] then
			return env.script.Parent.Parent.shared.data["data-template"]
		end
		return {}
	end

	-- Include standard globals
	env.pairs = pairs
	env.ipairs = ipairs
	env.next = next
	env.type = type
	env.tostring = tostring
	env.tonumber = tonumber
	env.print = print
	env.pcall = pcall
	env.xpcall = xpcall
	env.error = error
	env.assert = assert
	env.select = select
	env.unpack = unpack
	env.rawget = rawget
	env.rawset = rawset
	env.rawequal = rawequal
	env.getmetatable = getmetatable
	env.setmetatable = setmetatable

	-- Load the user code as a function with our custom environment
	local userFunc, loadError = luau.load(code, {
		debugName = "user_test_code",
		environment = env,
	})
	if not userFunc then
		return {
			success = false,
			error = "Failed to load code: " .. (loadError or "unknown error"),
			result = nil,
		}
	end

	-- Execute the user code
	local success, result = pcall(userFunc)
	local errorMsg = nil
	if not success then
		errorMsg = tostring(result)
	end

	return {
		success = success,
		result = result,
		error = errorMsg,
	}
end

local result = executeTest()
print(serde.encode("json", result))
