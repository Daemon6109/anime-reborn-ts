--!nolint
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

-- Load the place file
local placeFile = fs.readFile("reborn  lobbby.rbxl")
local game = roblox.deserializePlace(placeFile)

-- Get the Units registry folder
local UnitRegistryFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("Units")

if not UnitRegistryFolder then
	error("Units folder not found in Registry!")
end

-- Function to find matching closing brace accounting for nested braces, strings, and comments
local function findMatchingBrace(source, startPos)
	local braceCount = 1
	local inString = false
	local stringChar = nil
	local escapeNext = false
	local i = startPos + 1

	while i <= #source do
		local char = string.sub(source, i, i)
		local nextChar = string.sub(source, i + 1, i + 1)

		-- Handle escape sequences in strings
		if escapeNext then
			escapeNext = false
		elseif char == "\\" and inString then
			escapeNext = true
		-- Handle comments (both single line --)
		elseif not inString and char == "-" and nextChar == "-" then
			-- Skip to end of line to ignore commented content
			while i <= #source and string.sub(source, i, i) ~= "\n" do
				i = i + 1
			end
		-- Handle strings
		elseif not inString then
			if char == '"' or char == "'" then
				inString = true
				stringChar = char
			elseif char == "{" then
				braceCount = braceCount + 1
			elseif char == "}" then
				braceCount = braceCount - 1
				if braceCount == 0 then
					return i
				end
			end
		else
			-- We're inside a string
			if char == stringChar then
				inString = false
				stringChar = nil
			end
		end

		i = i + 1
	end

	return nil
end

-- Function to parse a value string into appropriate Lua type
local function parseValue(value, unitName, key)
	if not value or value == "" then
		return nil
	end

	-- Skip CheckFunction properties entirely
	if key == "CheckFunction" then
		return nil
	end

	-- Clean the value
	value = string.gsub(value, "^%s*", "") -- trim start
	value = string.gsub(value, "%s*$", "") -- trim end

	-- Remove comments first (everything after --)
	value = string.gsub(value, "%-%-.*", "")

	-- Remove type annotations more comprehensively
	-- Handle complex patterns like :: Enums.AttackTypes, :: boolean?, :: string, etc.
	value = string.gsub(value, "%s*::%s*[%w%.]+%??", "") -- remove type annotations with dots and optional ?
	value = string.gsub(value, "%s*::%s*%w+%??", "") -- remove simple type annotations with optional ?

	-- Remove trailing semicolons and question marks
	value = string.gsub(value, "%s*;%s*$", "")
	value = string.gsub(value, "%s*%?%s*$", "")

	-- Trim again after cleaning
	value = string.gsub(value, "^%s*", "")
	value = string.gsub(value, "%s*$", "")

	if value == "" then
		return nil
	end

	-- Handle boolean values
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	end

	-- Handle numbers
	if string.match(value, "^%d+%.%d+$") then
		return tonumber(value)
	elseif string.match(value, "^%-?%d+$") then
		return tonumber(value)
	end

	-- Handle quoted strings
	if string.match(value, '^"(.-)"$') then
		return string.match(value, '^"(.-)"$')
	elseif string.match(value, "^'(.-)'$") then
		return string.match(value, "^'(.-)'$")
	end

	-- Handle arrays in curly braces
	if string.match(value, "^%s*{.*}%s*$") then
		return value -- Return as string for now, will be parsed by extractNestedTable
	end

	-- Return as string for enum values and other simple types
	return value
end

-- Function to extract generic key-value tables
local function extractGenericTable(tableContent, unitName, tableName)
	local result = {}

	-- Extract simple key-value pairs
	for key, value in string.gmatch(tableContent, "([%w_]+)%s*=%s*([^,\n}]+)") do
		-- Skip nested tables for now, handle them separately
		if not string.find(value, "{") then
			local parsedValue = parseValue(value, unitName, key)
			if parsedValue ~= nil then
				result[key] = parsedValue
			end
		end
	end

	-- For Requirements table, extract Items and Units sub-tables
	if tableName == "Requirements" then
		-- Extract Items table
		local itemsPattern = "Items%s*=%s*{([^}]*)}"
		local itemsContent = string.match(tableContent, itemsPattern)
		if itemsContent then
			result.Items = {}
			for itemName, itemValue in string.gmatch(itemsContent, '%["([^"]+)"%]%s*=%s*(%d+)') do
				result.Items[itemName] = tonumber(itemValue)
			end
		end

		-- Extract Units table
		local unitsPattern = "Units%s*=%s*{([^}]*)}"
		local unitsContent = string.match(tableContent, unitsPattern)
		if unitsContent then
			result.Units = {}
			for unitKey, unitValue in string.gmatch(unitsContent, '%["([^"]+)"%]%s*=%s*(%d+)') do
				result.Units[unitKey] = tonumber(unitValue)
			end
		end
	end

	return result
end

-- Function to extract array-like tables (Passives, GameTypeAffinity, etc.)
local function extractArrayTable(tableContent, unitName, tableName)
	local result = {}

	-- Handle empty tables
	if string.match(tableContent, "^%s*$") then
		return {}
	end

	-- Extract quoted strings
	for item in string.gmatch(tableContent, '"([^"]*)"') do
		table.insert(result, item)
	end

	-- Also handle single-quoted strings
	for item in string.gmatch(tableContent, "'([^']*)'") do
		table.insert(result, item)
	end

	-- Debug if we're not finding anything
	if #result == 0 then
		print("DEBUG: Empty array for " .. unitName .. "." .. tableName .. ": " .. string.sub(tableContent, 1, 100))
	end

	return result
end

-- Function to extract individual evolve level data
local function extractEvolveLevel(levelContent, unitName, level)
	local result = {}

	-- Extract simple key-value pairs
	for key, value in string.gmatch(levelContent, "([%w_]+)%s*=%s*([^,\n}]+)") do
		-- Skip nested tables for now, handle them separately
		if not string.find(value, "{") then
			local parsedValue = parseValue(value, unitName, key)
			if parsedValue ~= nil then
				result[key] = parsedValue
			end
		end
	end

	-- Extract nested tables
	-- Requirements
	local requirementsPattern = "Requirements%s*=%s*{"
	local requirementsStart = string.find(levelContent, requirementsPattern)
	if requirementsStart then
		local openBracePos = string.find(levelContent, "{", requirementsStart)
		if openBracePos then
			local closeBracePos = findMatchingBrace(levelContent, openBracePos)
			if closeBracePos then
				local requirementsContent = string.sub(levelContent, openBracePos + 1, closeBracePos - 1)
				result.Requirements = extractGenericTable(requirementsContent, unitName, "Requirements")
			end
		end
	end

	-- DisplayBuffs
	local displayBuffsPattern = "DisplayBuffs%s*=%s*{"
	local displayBuffsStart = string.find(levelContent, displayBuffsPattern)
	if displayBuffsStart then
		local openBracePos = string.find(levelContent, "{", displayBuffsStart)
		if openBracePos then
			local closeBracePos = findMatchingBrace(levelContent, openBracePos)
			if closeBracePos then
				local displayBuffsContent = string.sub(levelContent, openBracePos + 1, closeBracePos - 1)
				result.DisplayBuffs = extractArrayTable(displayBuffsContent, unitName, "DisplayBuffs")
			end
		end
	end

	-- Debug logging
	print(
		"DEBUG: Extracted evolve level "
			.. level
			.. " for "
			.. unitName
			.. " with "
			.. tostring(#result)
			.. " properties"
	)

	return result
end

-- Function to extract EvolveData table
local function extractEvolveData(tableContent, unitName)
	local evolveData = {}

	-- Find numbered entries like [1] = { ... }
	local i = 1
	while i <= #tableContent do
		local levelPattern = "%[(%d+)%]%s*=%s*{"
		local levelStart = string.find(tableContent, levelPattern, i)

		if not levelStart then
			break
		end

		local levelNum = string.match(tableContent, levelPattern, i)
		local openBracePos = string.find(tableContent, "{", levelStart)

		if openBracePos and levelNum then
			local closeBracePos = findMatchingBrace(tableContent, openBracePos)
			if closeBracePos then
				local levelContent = string.sub(tableContent, openBracePos + 1, closeBracePos - 1)
				local level = tonumber(levelNum)
				evolveData[level] = extractEvolveLevel(levelContent, unitName, level)
				i = closeBracePos + 1
			else
				break
			end
		else
			break
		end
	end

	print("DEBUG: Extracted " .. tostring(#evolveData) .. " evolve levels for " .. unitName)
	return evolveData
end

-- Function to extract UpgradesInfo table
local function extractUpgradesInfo(tableContent, unitName)
	local upgrades = {}

	-- Find numbered entries like [1] = { ... }
	local i = 1
	while i <= #tableContent do
		local levelPattern = "%[(%d+)%]%s*=%s*{"
		local levelStart = string.find(tableContent, levelPattern, i)

		if not levelStart then
			break
		end

		local levelNum = string.match(tableContent, levelPattern, i)
		local openBracePos = string.find(tableContent, "{", levelStart)

		if openBracePos and levelNum then
			local closeBracePos = findMatchingBrace(tableContent, openBracePos)
			if closeBracePos then
				local levelContent = string.sub(tableContent, openBracePos + 1, closeBracePos - 1)
				local level = tonumber(levelNum)
				upgrades[level] = extractGenericTable(levelContent, unitName, "UpgradesInfo[" .. level .. "]")
				i = closeBracePos + 1
			else
				break
			end
		else
			break
		end
	end

	return upgrades
end

-- Generic function to extract nested tables from Lua source
local function extractNestedTable(source, tableName, unitName)
	local pattern = tableName .. "%s*=%s*{"
	local tableStart = string.find(source, pattern)

	if not tableStart then
		return {}
	end

	local openBracePos = string.find(source, "{", tableStart)
	if not openBracePos then
		return {}
	end

	local closeBracePos = findMatchingBrace(source, openBracePos)
	if not closeBracePos then
		print("WARNING: Could not find matching brace for " .. tableName .. " in unit " .. unitName)
		return {}
	end

	local tableContent = string.sub(source, openBracePos + 1, closeBracePos - 1)

	-- Handle special cases
	if tableName == "UpgradesInfo" then
		return extractUpgradesInfo(tableContent, unitName)
	elseif tableName == "Passives" or tableName == "GameTypeAffinity" then
		return extractArrayTable(tableContent, unitName, tableName)
	elseif tableName == "EvolveData" then
		return extractEvolveData(tableContent, unitName)
	elseif tableName == "MapAffnityBoosts" then
		return extractGenericTable(tableContent, unitName, tableName)
	else
		return extractGenericTable(tableContent, unitName, tableName)
	end
end

-- Function to extract the configuration table from source code
local function extractConfigurationFromSource(source, unitName)
	-- Find the Unit.configuration = { ... } block
	local configStart = string.find(source, "Unit%.configuration%s*=%s*{")
	if not configStart then
		return {}
	end

	-- Find the actual opening brace position
	local openBracePos = string.find(source, "{", configStart)
	if not openBracePos then
		return {}
	end

	local closeBracePos = findMatchingBrace(source, openBracePos)
	if not closeBracePos then
		print("WARNING: Could not find matching brace for configuration in unit " .. unitName)
		return {}
	end

	local configContent = string.sub(source, openBracePos + 1, closeBracePos - 1)

	-- Extract configuration data
	local config = {}

	-- Extract simple key-value pairs first with improved pattern to avoid capturing comments
	local lines = {}
	for line in string.gmatch(configContent, "[^\n]+") do
		table.insert(lines, line)
	end

	for _, line in ipairs(lines) do
		-- Skip lines that are just comments or empty
		local trimmedLine = string.gsub(line, "^%s*", "")
		if not string.match(trimmedLine, "^%-%-") and trimmedLine ~= "" then
			-- Extract key = value pairs, stopping at comments
			local key, value = string.match(line, "^%s*([%w_]+)%s*=%s*([^-]+)")
			if key and value then
				-- Clean up the value by removing trailing whitespace and commas
				value = string.gsub(value, "%s*,%s*$", "")
				value = string.gsub(value, "%s*$", "")

				-- Skip complex patterns and nested tables for now, but allow Enum values
				if
					not string.find(value, "CFrame")
					and not string.find(value, "math%.")
					and not string.find(value, "script%.")
					and not string.find(value, "function")
					and not string.find(value, "{")
				then
					local parsedValue = parseValue(value, unitName, key)
					if parsedValue ~= nil then
						config[key] = parsedValue
					else
						print("SKIPPED: " .. unitName .. "." .. key .. " = " .. tostring(value))
					end
				else
					print(
						"SKIPPED (complex): "
							.. unitName
							.. "."
							.. key
							.. " = "
							.. string.sub(tostring(value), 1, 50)
							.. "..."
					)
				end
			end
		end
	end

	-- Extract nested tables
	config.UpgradesInfo = extractNestedTable(configContent, "UpgradesInfo", unitName)
	config.Passives = extractNestedTable(configContent, "Passives", unitName)
	config.EvolveData = extractNestedTable(configContent, "EvolveData", unitName)
	config.MapAffnityBoosts = extractNestedTable(configContent, "MapAffnityBoosts", unitName)
	config.GameTypeAffinity = extractNestedTable(configContent, "GameTypeAffinity", unitName)

	-- Remove empty nested tables to keep JSON clean
	if not next(config.UpgradesInfo) then
		config.UpgradesInfo = nil
	end
	if not next(config.Passives) then
		config.Passives = nil
	end
	if not next(config.EvolveData) then
		config.EvolveData = nil
	end
	if not next(config.MapAffnityBoosts) then
		config.MapAffnityBoosts = nil
	end
	if not next(config.GameTypeAffinity) then
		config.GameTypeAffinity = nil
	end

	return config
end

-- Function to extract animations table from source code
local function extractAnimationsFromSource(source)
	-- Look for Unit.animations = { ... }
	local pattern = "Unit%.animations%s*=%s*{([^}]*)}"
	local animationsContent = string.match(source, pattern)

	if not animationsContent then
		return {}
	end

	local result = {}
	-- Extract key-value pairs from animations table
	for key, value in string.gmatch(animationsContent, "([%w_]+)%s*=%s*[\"']([^\"']*)[\"']") do
		result[key] = value
	end

	return result
end

-- Collect all unit data
local unitsData = {}
local processedCount = 0

print("Starting to process units...")

local successCount = 0
local warningCount = 0
local totalProcessed = 0

for _, unitEntry in pairs(UnitRegistryFolder:GetChildren()) do
	if unitEntry:IsA("ModuleScript") then
		local unitName = unitEntry.Name
		local scriptSource = unitEntry.Source

		-- Extract the main data we need
		local unitData = {
			name = unitName,
			configuration = extractConfigurationFromSource(scriptSource, unitName),
			Released = true, -- Default to true as per requirements
			Summonable = true, -- Default to true as per requirements
			animations = extractAnimationsFromSource(scriptSource),
		}

		-- Check Released and Summonable from BoolValue children (not source code)
		local releasedChild = unitEntry:FindFirstChild("Released")
		if releasedChild and releasedChild:IsA("BoolValue") then
			unitData.Released = releasedChild.Value
		end

		local summonableChild = unitEntry:FindFirstChild("Summonable")
		if summonableChild and summonableChild:IsA("BoolValue") then
			unitData.Summonable = summonableChild.Value
		end

		-- Add to our collection
		unitsData[unitName] = unitData
		totalProcessed = totalProcessed + 1

		-- Count successful extractions
		if next(unitData.configuration) then
			successCount = successCount + 1
		else
			warningCount = warningCount + 1
			print("WARNING: No configuration extracted for unit " .. unitName)
		end

		if totalProcessed % 50 == 0 then
			print("Processed " .. totalProcessed .. " units...")
		end
	end
end

print("Processing complete!")
print("Total units processed: " .. totalProcessed)
print("Successfully extracted: " .. successCount)
print("With warnings: " .. warningCount)

-- Convert to JSON
local jsonString = serde.encode("json", unitsData, true) -- true for pretty printing

-- Ensure the target directory exists
local targetDir = "places/common/src/shared/data"
if not fs.isDir(targetDir) then
	fs.writeDir(targetDir)
end

-- Write the JSON file
local jsonPath = targetDir .. "/units-data.json"

-- Delete existing file if it exists to ensure we're creating a fresh one
if fs.isFile(jsonPath) then
	fs.removeFile(jsonPath)
	print("Deleted existing units-data.json")
end

fs.writeFile(jsonPath, jsonString)

print("Units data JSON written to: " .. jsonPath)

-- Create the TypeScript wrapper file
local tsContent = [[import unitsData from './units-data.json';

export { unitsData };
]]

local tsPath = targetDir .. "/units-data.ts"
fs.writeFile(tsPath, tsContent)

print("TypeScript wrapper created at: " .. tsPath)
print("Extraction complete!")
