--!nolint
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

-- Load the place file
local placeFile = fs.readFile("reborn  lobbby.rbxl")
local game = roblox.deserializePlace(placeFile)

-- Get the Items registry folder
local ItemRegistryFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("Items")

if not ItemRegistryFolder then
	error("Items folder not found in Registry!")
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

-- Function to evaluate simple mathematical expressions
local function evaluateMathExpression(expr)
	-- Remove all whitespace
	expr = string.gsub(expr, "%s+", "")

	-- Handle expressions with parentheses like (36/2)/2 or (28/2)/2
	local parenExpr, operator, rightOperand = string.match(expr, "^%(([^%)]+)%)([%+%-%*/^])(%d+%.?%d*)$")
	if parenExpr and operator and rightOperand then
		-- Recursively evaluate the expression in parentheses
		local parenResult = evaluateMathExpression(parenExpr)
		local rightNum = tonumber(rightOperand)
		if parenResult and rightNum then
			if operator == "/" and rightNum ~= 0 then
				return parenResult / rightNum
			elseif operator == "*" then
				return parenResult * rightNum
			elseif operator == "+" then
				return parenResult + rightNum
			elseif operator == "-" then
				return parenResult - rightNum
			elseif operator == "^" then
				return parenResult ^ rightNum
			end
		end
	end

	-- Handle simple division operations (most common case)
	local numerator, denominator = string.match(expr, "^(%d+%.?%d*)/(%d+%.?%d*)$")
	if numerator and denominator then
		local num = tonumber(numerator)
		local den = tonumber(denominator)
		if num and den and den ~= 0 then
			return num / den
		end
	end

	-- Handle simple multiplication
	local factor1, factor2 = string.match(expr, "^(%d+%.?%d*)%*(%d+%.?%d*)$")
	if factor1 and factor2 then
		local f1 = tonumber(factor1)
		local f2 = tonumber(factor2)
		if f1 and f2 then
			return f1 * f2
		end
	end

	-- Handle simple addition
	local addend1, addend2 = string.match(expr, "^(%d+%.?%d*)%+(%d+%.?%d*)$")
	if addend1 and addend2 then
		local a1 = tonumber(addend1)
		local a2 = tonumber(addend2)
		if a1 and a2 then
			return a1 + a2
		end
	end

	-- Handle simple subtraction
	local minuend, subtrahend = string.match(expr, "^(%d+%.?%d*)%-(%d+%.?%d*)$")
	if minuend and subtrahend then
		local m = tonumber(minuend)
		local s = tonumber(subtrahend)
		if m and s then
			return m - s
		end
	end

	-- Handle simple power operations (using ^ symbol)
	local base, exponent = string.match(expr, "^(%d+%.?%d*)%^(%d+%.?%d*)$")
	if base and exponent then
		local b = tonumber(base)
		local e = tonumber(exponent)
		if b and e then
			return b ^ e
		end
	end

	return nil
end

-- Function to parse a value string into appropriate Lua type
local function parseValue(value, _itemName, key)
	if not value or value == "" then
		return nil
	end

	-- Skip Viewport/CFrame properties
	if key == "ViewportCFrame" or key == "PreviewViewport" then
		return nil
	end

	-- Clean the value
	value = string.gsub(value, "^%s*", "") -- trim start
	value = string.gsub(value, "%s*$", "") -- trim end

	-- Remove comments first (everything after --)
	value = string.gsub(value, "%-%-.*", "")

	-- Remove type annotations more comprehensively
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

	-- Try to evaluate mathematical expressions first (before checking for simple numbers)
	local mathResult = evaluateMathExpression(value)
	if mathResult then
		return mathResult
	end

	-- Handle numbers (including decimals)
	if string.match(value, "^%d+%.%d+$") then
		return tonumber(value)
	elseif string.match(value, "^%-?%d+$") then
		return tonumber(value)
	end

	-- Handle decimal strings that might represent numbers (like ".3", ".1")
	if string.match(value, '^"%.%d+"$') or string.match(value, "^'%.%d+'$") then
		local numStr = string.match(value, "^[\"'](%.%d+)[\"']$")
		return tonumber(numStr)
	end

	-- Handle decimal strings without quotes (like .3, .1)
	if string.match(value, "^%.%d+$") then
		return tonumber(value)
	end

	-- Handle quoted strings
	local stringValue = nil
	if string.match(value, '^"(.-)"$') then
		stringValue = string.match(value, '^"(.-)"$')
	elseif string.match(value, "^'(.-)'$") then
		stringValue = string.match(value, "^'(.-)'$")
	end

	if stringValue then
		return stringValue
	end

	-- Handle arrays in curly braces
	if string.match(value, "^%s*{.*}%s*$") then
		return value -- Return as string for now, will be parsed by extractNestedTable
	end

	-- Return as string for enum values and other simple types
	return value
end

-- Function to extract array-like tables (e.g., Sort)
local function extractArrayTable(tableContent, itemName, tableName)
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
		print("DEBUG: Empty array for " .. itemName .. "." .. tableName .. ": " .. string.sub(tableContent, 1, 100))
	end

	return result
end

-- Generic function to extract nested tables from Lua source
local function extractNestedTable(source, tableName, itemName)
	local pattern = tableName .. "%s*=%s*{"
	local tableStart = string.find(source, pattern)

	if not tableStart then
		return nil
	end

	local openBracePos = string.find(source, "{", tableStart)
	if not openBracePos then
		return nil
	end

	local closeBracePos = findMatchingBrace(source, openBracePos)
	if not closeBracePos then
		print("WARNING: Could not find matching brace for " .. tableName .. " in item " .. itemName)
		return nil
	end

	local tableContent = string.sub(source, openBracePos + 1, closeBracePos - 1)

	-- For now, only 'Sort' is expected as an array
	if tableName == "Sort" then
		return extractArrayTable(tableContent, itemName, tableName)
	end

	return nil
end

-- Function to extract the configuration table from source code
local function extractConfigurationFromSource(source, itemName)
	-- Find the Item.configuration = { ... } block
	local configStart = string.find(source, "Item%.configuration%s*=%s*{")
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
		print("WARNING: Could not find matching brace for configuration in item " .. itemName)
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
			local lineWithoutComments = string.gsub(line, "%-%-.*", "")
			local key, value = string.match(lineWithoutComments, "^%s*([%w_]+)%s*=%s*(.+)")
			if key and value and key ~= "TrueName" then
				-- Clean up the value by removing trailing whitespace and commas
				value = string.gsub(value, "%s*,%s*$", "")
				value = string.gsub(value, "%s*$", "")

				-- Skip complex patterns and nested tables for now
				if not string.find(value, "{") then
					local parsedValue = parseValue(value, itemName, key)
					if parsedValue ~= nil then
						config[key] = parsedValue
					end
				end
			end
		end
	end

	-- Extract nested tables
	config.Sort = extractNestedTable(configContent, "Sort", itemName)

	-- Remove empty nested tables to keep JSON clean
	if config.Sort and not next(config.Sort) then
		config.Sort = nil
	end

	return config
end

-- Function to extract top-level Item properties like Limit
local function extractItemProperties(source, itemName)
	local properties = {}

	-- Extract Item.Limit
	local limitPattern = "Item%.Limit%s*=%s*([%w\"']+)"
	local limitValue = string.match(source, limitPattern)
	if limitValue then
		-- It could be a number or a string like "inf"
		if tonumber(limitValue) then
			properties.Limit = tonumber(limitValue)
		else
			properties.Limit = parseValue(limitValue, itemName, "Limit")
		end
	end

	return properties
end

-- Collect all item data
local itemsData = {}

print("Starting to process items...")

local successCount = 0
local warningCount = 0
local totalProcessed = 0

for _, itemEntry in pairs(ItemRegistryFolder:GetChildren()) do
	if itemEntry:IsA("ModuleScript") then
		local itemName = itemEntry.Name
		local scriptSource = itemEntry.Source

		-- Extract the main data we need
		local itemData = {
			configuration = extractConfigurationFromSource(scriptSource, itemName),
		}

		-- Extract additional Item properties
		local itemProperties = extractItemProperties(scriptSource, itemName)
		-- Add the extracted properties to itemData
		for key, value in pairs(itemProperties) do
			itemData[key] = value
		end

		-- Add to our collection
		itemsData[itemName] = itemData
		totalProcessed = totalProcessed + 1

		-- Count successful extractions
		if next(itemData.configuration) then
			successCount = successCount + 1
		else
			warningCount = warningCount + 1
			print("WARNING: No configuration extracted for item " .. itemName)
		end

		if totalProcessed % 50 == 0 then
			print("Processed " .. totalProcessed .. " items...")
		end
	end
end

print("Processing complete!")
print("Total items processed: " .. totalProcessed)
print("Successfully extracted: " .. successCount)
print("With warnings: " .. warningCount)

-- Convert to JSON
local jsonString = serde.encode("json", itemsData, true) -- true for pretty printing

-- Post-process to fix number formatting (remove .0 from integers)
jsonString = string.gsub(jsonString, "(%d+)%.0([,%s%}%]])", "%1%2")

-- Ensure the target directory exists
local targetDir = "places/common/shared/configuration"
if not fs.isDir(targetDir) then
	fs.writeDir(targetDir)
end

-- Write the JSON file
local jsonPath = targetDir .. "/items-data.json"

-- Delete existing file if it exists to ensure we're creating a fresh one
if fs.isFile(jsonPath) then
	fs.removeFile(jsonPath)
	print("Deleted existing items-data.json")
end

fs.writeFile(jsonPath, jsonString)

print("Items data JSON written to: " .. jsonPath)
print("Extraction complete!")
