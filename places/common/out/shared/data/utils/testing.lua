-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- Data Testing Utilities for TypeScript
local DATA_TEMPLATE = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "data-template").DATA_TEMPLATE
local deepCopy = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "utils", "deep-copy").deepCopy
--[[
	*
	 * Creates mock player data for testing purposes
	 
]]
local function mockPlayerData()
	-- Create a lightweight copy for testing
	local mockData = deepCopy(DATA_TEMPLATE)
	-- Add some test values
	mockData.Level = 10
	mockData.XP = 5000
	mockData.Currencies.Gold = 10000
	mockData.Currencies.Gems = 1000
	return mockData
end
--[[
	*
	 * Validates that data structure matches the expected template
	 
]]
local function validateStructure(data, template)
	local _data = data
	if typeof(_data) ~= "table" then
		return { false, "Data is not a table" }
	end
	local dataTable = data
	local templateTable = template
	for key, value in pairs(templateTable) do
		if dataTable[key] == nil then
			return { false, `Missing field: {key}` }
		end
		local _condition = typeof(value) == "table"
		if _condition then
			local _arg0 = dataTable[key]
			_condition = typeof(_arg0) == "table"
		end
		if _condition then
			local _binding = validateStructure(dataTable[key], value)
			local isValid = _binding[1]
			local errorMessage = _binding[2]
			local _value = not isValid and errorMessage
			if _value ~= "" and _value then
				return { false, `In {key}: {errorMessage}` }
			end
		end
	end
	return { true }
end
--[[
	*
	 * Compare two data structures and return differences
	 
]]
local function diffData(data1, data2, path)
	if path == nil then
		path = ""
	end
	local differences = {}
	local _data1 = data1
	local _condition = typeof(_data1) ~= "table"
	if not _condition then
		local _data2 = data2
		_condition = typeof(_data2) ~= "table"
	end
	if _condition then
		if data1 ~= data2 then
			local _condition_1 = path
			if not (_condition_1 ~= "" and _condition_1) then
				_condition_1 = "root"
			end
			differences[_condition_1] = {
				old = data1,
				new = data2,
			}
		end
		return differences
	end
	local data1Table = data1
	local data2Table = data2
	-- Check for fields in data1 that differ from data2
	for key, value1 in pairs(data1Table) do
		local currentPath = if path ~= "" and path then `{path}.{key}` else key
		local value2 = data2Table[key]
		if value2 == nil then
			differences[currentPath] = {
				old = value1,
				new = nil,
			}
		elseif typeof(value1) == "table" and typeof(value2) == "table" then
			local nestedDifferences = diffData(value1, value2, currentPath)
			for diffPath, diffValue in pairs(nestedDifferences) do
				differences[diffPath] = diffValue
			end
		elseif typeof(value1) ~= typeof(value2) or value1 ~= value2 then
			differences[currentPath] = {
				old = value1,
				new = value2,
			}
		end
	end
	-- Check for fields in data2 that don't exist in data1
	for key, value2 in pairs(data2Table) do
		local currentPath = if path ~= "" and path then `{path}.{key}` else key
		if data1Table[key] == nil then
			differences[currentPath] = {
				old = nil,
				new = value2,
			}
		end
	end
	return differences
end
--[[
	*
	 * Prints a summary of data for debugging
	 
]]
local function printDataSummary(data)
	print("---- Data Summary ----")
	print(`Player Level: {data.Level}`)
	print(`XP: {data.XP}`)
	print("Currencies:")
	for name, amount in pairs(data.Currencies) do
		print(`  {name}: {amount}`)
	end
	print("Inventory:")
	-- Count units and items using pairs iteration
	local unitCount = 0
	local itemCount = 0
	for _ in pairs(data.Inventory.Units) do
		unitCount += 1
	end
	for _ in pairs(data.Inventory.Items) do
		itemCount += 1
	end
	print(`  Units: {unitCount}`)
	print(`  Items: {itemCount}`)
	print("--------------------")
end
--[[
	*
	 * Creates test data with specific values for validation testing
	 
]]
local function createTestData(overrides)
	if overrides == nil then
		overrides = {}
	end
	local baseData = deepCopy(DATA_TEMPLATE)
	-- Apply overrides
	for key, value in pairs(overrides) do
		baseData[key] = value
	end
	return baseData
end
--[[
	*
	 * Validates that all required fields exist in the data
	 
]]
local function validateRequiredFields(data)
	local missingFields = {}
	local template = DATA_TEMPLATE
	local function checkFields(dataObj, templateObj, prefix)
		if prefix == nil then
			prefix = ""
		end
		for key, templateValue in pairs(templateObj) do
			local fullKey = if prefix ~= "" and prefix then `{prefix}.{key}` else key
			local dataValue = dataObj[key]
			if dataValue == nil then
				table.insert(missingFields, fullKey)
			elseif typeof(templateValue) == "table" and typeof(dataValue) == "table" then
				checkFields(dataValue, templateValue, fullKey)
			end
		end
	end
	checkFields(data, template)
	return { #missingFields == 0, missingFields }
end
return {
	mockPlayerData = mockPlayerData,
	validateStructure = validateStructure,
	diffData = diffData,
	printDataSummary = printDataSummary,
	createTestData = createTestData,
	validateRequiredFields = validateRequiredFields,
}
