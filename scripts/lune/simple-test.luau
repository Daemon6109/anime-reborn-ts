-- Simple test script for Lune
local stdio = require("@lune/stdio")
local process = require("@lune/process")
local serde = require("@lune/serde")

print("Lune version test")
print("Args:", serde.encode("json", process.args))

-- Test typeof function
local function testTypeof()
	local value = {}
	return type(value)
end

local result = {
	test = "success",
	typeResult = testTypeof(),
	clock = os.clock(),
}

print(serde.encode("json", result))
