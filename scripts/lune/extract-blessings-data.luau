--!nolint
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

-- Load the place file
local placeFile = fs.readFile("reborn  lobbby.rbxl")
local game = roblox.deserializePlace(placeFile)

-- Get the Blessings registry folder
local BlessingRegistryFolder =
	game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("Blessings")

if not BlessingRegistryFolder then
	error("Blessings folder not found in Registry!")
end

-- Function to extract animation ID from a function's source
local function extractAnimationId(funcSource)
	if not funcSource then
		return nil
	end
	local animIdPattern = "player%.IdleAnimationValue%.Value%s*=%s*(%d+)"
	local animId = string.match(funcSource, animIdPattern)
	if animId then
		return tonumber(animId)
	end
	return nil
end

-- Function to extract a function's body by its name
local function getFunctionBody(source, funcName)
	local pattern = "function%s+module%s*:%s*" .. funcName .. "%s*%([^)]*%)"
	local funcStart, funcEnd = string.find(source, pattern)

	if not funcStart then
		return nil
	end

	local bodyStart = funcEnd + 1
	local nestingLevel = 0
	local i = bodyStart

	while i <= #source do
		local sub = string.sub(source, i)
		if
			string.find(sub, "^function")
			or string.find(sub, "^if")
			or string.find(sub, "^for")
			or string.find(sub, "^while")
			or string.find(sub, "^repeat")
		then
			nestingLevel = nestingLevel + 1
		elseif string.find(sub, "^end") then
			if nestingLevel == 0 then
				return string.sub(source, bodyStart, i - 1)
			else
				nestingLevel = nestingLevel - 1
			end
		end
		i = i + 1
	end

	return nil -- Matching end not found
end

-- Collect all blessing data
local blessingsData = {}

print("Starting to process blessings...")

local totalProcessed = 0

for _, blessingEntry in pairs(BlessingRegistryFolder:GetChildren()) do
	if blessingEntry:IsA("ModuleScript") then
		local blessingName = blessingEntry.Name
		local scriptSource = blessingEntry.Source

		print("Processing blessing: " .. blessingName)

		local blessingData = {}

		-- Extract animation from Equip
		local equipFuncSource = getFunctionBody(scriptSource, "Equip")
		if not equipFuncSource then
			print("Equip function not found for " .. blessingName)
		end
		local idleAnim = extractAnimationId(equipFuncSource)
		if idleAnim then
			blessingData.IdleAnimation = idleAnim
		end

		-- Extract animation from ShinyEquip
		local shinyEquipFuncSource = getFunctionBody(scriptSource, "ShinyEquip")
		if not shinyEquipFuncSource then
			print("ShinyEquip function not found for " .. blessingName)
		end
		local shinyIdleAnim = extractAnimationId(shinyEquipFuncSource)
		if shinyIdleAnim then
			blessingData.ShinyIdleAnimation = shinyIdleAnim
		end

		-- Add to our collection if we found any data
		if next(blessingData) then
			blessingsData[blessingName] = blessingData
		end

		totalProcessed = totalProcessed + 1

		if totalProcessed % 50 == 0 then
			print("Processed " .. totalProcessed .. " blessings...")
		end
	end
end

print("Processing complete!")
print("Total blessings processed: " .. totalProcessed)

-- Convert to JSON
local jsonString = serde.encode("json", blessingsData, true) -- true for pretty printing

-- Post-process to fix number formatting (remove .0 from integers)
jsonString = string.gsub(jsonString, "(%d+)%.0([,%s%}%]])", "%1%2")

-- Ensure the target directory exists
local targetDir = "places/common/src/shared/configuration"
if not fs.isDir(targetDir) then
	fs.writeDir(targetDir)
end

-- Write the JSON file
local jsonPath = targetDir .. "/blessings-data.json"

-- Delete existing file if it exists to ensure we're creating a fresh one
if fs.isFile(jsonPath) then
	fs.removeFile(jsonPath)
	print("Deleted existing blessings-data.json")
end

fs.writeFile(jsonPath, jsonString)

print("Blessings data JSON written to: " .. jsonPath)
print("Extraction complete!")
