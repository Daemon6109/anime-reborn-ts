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

-- Function to safely extract a table from Luau source code
local function extractTableFromSource(source, tableName)
	-- Look for the table definition pattern
	local pattern = tableName .. "%s*=%s*{(.-)}"
	local tableContent = string.match(source, pattern)
	
	if not tableContent then
		return nil
	end
	
	-- This is a simplified parser - for a production system you might want something more robust
	local result = {}
	
	-- Extract key-value pairs (simplified approach)
	for key, value in string.gmatch(tableContent, "([%w_]+)%s*=%s*([^,\n}]+)") do
		-- Remove extra whitespace and quotes
		value = string.gsub(value, "^%s*", "")
		value = string.gsub(value, "%s*$", "")
		
		-- Try to parse different value types
		if value == "true" then
			result[key] = true
		elseif value == "false" then
			result[key] = false
		elseif string.match(value, "^%d+%.%d+$") then
			result[key] = tonumber(value)
		elseif string.match(value, "^%d+$") then
			result[key] = tonumber(value)
		elseif string.match(value, '^"(.-)"$') then
			result[key] = string.match(value, '^"(.-)"$')
		else
			-- For complex values, store as string
			result[key] = value
		end
	end
	
	return result
end

-- Function to extract nested table structures like UpgradesInfo
local function extractUpgradesInfo(source)
	local upgradesPattern = "UpgradesInfo%s*=%s*{(.-)},?%s*%-%-===="
	local upgradesContent = string.match(source, upgradesPattern)
	
	if not upgradesContent then
		return {}
	end
	
	local upgrades = {}
	
	-- Extract each upgrade level
	for levelNum, levelContent in string.gmatch(upgradesContent, "%[(%d+)%]%s*=%s*{([^}]+)}") do
		local level = tonumber(levelNum)
		upgrades[level] = {}
		
		-- Extract properties from each level
		for key, value in string.gmatch(levelContent, "([%w_]+)%s*=%s*([^,\n]+)") do
			value = string.gsub(value, "^%s*", "")
			value = string.gsub(value, "%s*$", "")
			
			if value == "true" then
				upgrades[level][key] = true
			elseif value == "false" then
				upgrades[level][key] = false
			elseif string.match(value, "^%d+%.%d+$") then
				upgrades[level][key] = tonumber(value)
			elseif string.match(value, "^%d+$") then
				upgrades[level][key] = tonumber(value)
			elseif string.match(value, '^"(.-)"$') then
				upgrades[level][key] = string.match(value, '^"(.-)"$')
			else
				upgrades[level][key] = value
			end
		end
	end
	
	return upgrades
end

-- Function to extract arrays like Passives
local function extractArray(source, arrayName)
	local pattern = arrayName .. "%s*=%s*{([^}]*)}"
	local arrayContent = string.match(source, pattern)
	
	if not arrayContent then
		return {}
	end
	
	local result = {}
	for item in string.gmatch(arrayContent, '"([^"]*)"') do
		table.insert(result, item)
	end
	
	return result
end

-- Function to extract simple key-value pairs from the configuration table
local function extractConfigFromSource(source)
	local configPattern = "configuration%s*=%s*{(.-)},?%s*%-%-====%s*}"
	local configContent = string.match(source, configPattern)
	
	if not configContent then
		return {}
	end
	
	local config = {}
	
	-- Extract simple key-value pairs
	for key, value in string.gmatch(configContent, "([%w_]+)%s*=%s*([^,\n}]+)") do
		-- Skip complex CFrame values and other complex types for now
		if not string.find(value, "CFrame") and not string.find(value, "Enums") then
			value = string.gsub(value, "^%s*", "")
			value = string.gsub(value, "%s*$", "")
			value = string.gsub(value, "%s*::%s*%w+", "") -- Remove type annotations
			
			if value == "true" then
				config[key] = true
			elseif value == "false" then
				config[key] = false
			elseif string.match(value, "^%d+%.%d+$") then
				config[key] = tonumber(value)
			elseif string.match(value, "^%d+$") then
				config[key] = tonumber(value)
			elseif string.match(value, '^"(.-)"$') then
				config[key] = string.match(value, '^"(.-)"$')
			else
				-- Store as string for enum values and other types
				config[key] = string.gsub(value, '^"', ""):gsub('"$', "")
			end
		end
	end
	
	-- Extract UpgradesInfo separately
	config.UpgradesInfo = extractUpgradesInfo(source)
	
	-- Extract Passives array
	config.Passives = extractArray(source, "Passives")
	
	return config
end

-- Collect all unit data
local unitsData = {}
local processedCount = 0

print("Starting to process units...")

for _, unitEntry in pairs(UnitRegistryFolder:GetChildren()) do
	if unitEntry:IsA("ModuleScript") then
		local unitName = unitEntry.Name
		local scriptSource = unitEntry.Source
		
		-- Extract the main data we need
		local unitData = {
			name = unitName,
			configuration = extractConfigFromSource(scriptSource),
			Released = true, -- Default to true as per requirements
			Summonable = true, -- Default to true as per requirements
			animations = extractTableFromSource(scriptSource, "animations") or {}
		}
		
		-- Check if Released or Summonable are explicitly defined
		local releasedMatch = string.match(scriptSource, "Released%s*=%s*(%w+)")
		if releasedMatch then
			unitData.Released = releasedMatch == "true"
		end
		
		local summonableMatch = string.match(scriptSource, "Summonable%s*=%s*(%w+)")
		if summonableMatch then
			unitData.Summonable = summonableMatch == "true"
		end
		
		-- Add to our collection
		unitsData[unitName] = unitData
		processedCount = processedCount + 1
		
		if processedCount % 50 == 0 then
			print("Processed " .. processedCount .. " units...")
		end
	end
end

print("Processed " .. processedCount .. " units total")

-- Convert to JSON
local jsonString = serde.encode("json", unitsData, true) -- true for pretty printing

-- Ensure the target directory exists
local targetDir = "places/common/src/shared/data"
if not fs.isDir(targetDir) then
	fs.writeDir(targetDir)
end

-- Write the JSON file
local jsonPath = targetDir .. "/units-data.json"
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
