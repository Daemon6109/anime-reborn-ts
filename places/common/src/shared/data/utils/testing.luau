--------------------------------------------------------------------------------
-- Data Testing Utilities

-- This module provides helper functions for testing data templates and factories.
--------------------------------------------------------------------------------

local function mockPlayerData()
	local DataTemplate = require("../data_template")

	-- Create a lightweight copy for testing
	local mockData = table.clone(DataTemplate)

	-- Add some test values
	mockData.Level = 10
	mockData.XP = 5000
	mockData.Currencies.Gold = 10000
	mockData.Currencies.Gems = 1000

	return mockData
end

local function validateStructure(data: any, template: any): (boolean, string?)
	if typeof(data) ~= "table" then
		return false, "Data is not a table"
	end

	for key, value in pairs(template) do
		if data[key] == nil then
			return false, string.format("Missing field: %s", key)
		end

		if typeof(value) == "table" and typeof(data[key]) == "table" then
			local isValid, errorMessage = validateStructure(data[key], value)
			if not isValid and errorMessage then
				return false, string.format("In %s: %s", key, errorMessage)
			end
		end
	end

	return true
end

-- Compare two data structures and return differences
local function diffData(data1: any, data2: any, path: string?): { [string]: { old: any, new: any } }
	local safePath = path or ""
	local differences = {}

	-- Check for fields in data1 that differ from data2
	for key, value1 in pairs(data1) do
		local currentPath = safePath .. (safePath ~= "" and "." or "") .. tostring(key)
		local value2 = data2[key]

		if value2 == nil then
			differences[currentPath] = { old = value1, new = nil }
		elseif typeof(value1) == "table" and typeof(value2) == "table" then
			local nestedDifferences = diffData(value1, value2, currentPath)
			for diffPath, diffValue in pairs(nestedDifferences) do
				differences[diffPath] = diffValue
			end
		elseif typeof(value1) ~= typeof(value2) or value1 ~= value2 then
			differences[currentPath] = { old = value1, new = value2 }
		end
	end

	-- Check for fields in data2 that don't exist in data1
	for key, value2 in pairs(data2) do
		local currentPath = safePath .. (safePath ~= "" and "." or "") .. tostring(key)
		if data1[key] == nil then
			differences[currentPath] = { old = nil, new = value2 }
		end
	end

	return differences
end

local function printDataSummary(data: any)
	print("---- Data Summary ----")
	print(string.format("Player Level: %d", data.Level))
	print(string.format("XP: %d", data.XP))
	print("Currencies:")
	for name, amount in pairs(data.Currencies) do
		print(string.format("  %s: %s", name, tostring(amount)))
	end
	print("Inventory:")
	print(string.format("  Units: %d", #(data.Inventory.Units or {})))
	print(string.format("  Items: %d", #(data.Inventory.Items or {})))
	print("--------------------")
end

return {
	mockPlayerData = mockPlayerData,
	validateStructure = validateStructure,
	diffData = diffData,
	printDataSummary = printDataSummary,
}
