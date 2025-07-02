--!nolint
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

-- Load the place file
local placeFile = fs.readFile("reborn  lobbby.rbxl")
local game = roblox.deserializePlace(placeFile)

-- Get the Currency registry folder
local CurrencyRegistryFolder =
	game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("Currency")

if not CurrencyRegistryFolder then
	error("Currency folder not found in Registry!")
end

-- Collect all currency data
local currencyData = {}
local totalProcessed = 0
local successCount = 0

local function parseUDim2(str)
	local xScale, yScale = str:match("UDim2.fromScale%((.-),%s*(.-)%)")
	if xScale and yScale then
		return {
			x = {
				scale = tonumber(xScale),
				offset = 0,
			},
			y = {
				scale = tonumber(yScale),
				offset = 0,
			},
		}
	end
	return nil
end

local function parseCurrency(source)
	local data = {}

	data.TrueName = source:match('TrueName%s*=%s*"(.-)"')
	data.DisplayName = source:match('DisplayName%s*=%s*"(.-)"')
	data.Description = source:match('Description%s*=%s*"(.-)"')
	data.Image = source:match('Image%s*=%s*"(.-)"')
	data.Rarity = source:match('Rarity%s*=%s*"(.-)"')
	data.Order = tonumber(source:match("Order%s*=%s*(%d+)"))

	local sortMatch = source:match("Sort%s*=%s*{(.-)}")
	if sortMatch then
		data.Sort = {}
		for sort in sortMatch:gmatch('"([^"]*)"') do
			table.insert(data.Sort, sort)
		end
	end

	local iconSizeMatch = source:match("DisplayIconSize%s*=%s*(UDim2.fromScale.-))")
	if iconSizeMatch then
		data.DisplayIconSize = parseUDim2(iconSizeMatch)
	end

	local gradientMatch = source:match("Gradient%s*=%s*{(.-)}")
	if gradientMatch then
		data.Gradient = {}
		local numbers = {}
		local currentNumber = ""
		for i = 1, #gradientMatch do
			local char = gradientMatch:sub(i, i)
			if char:match("%d") or char == "." then
				currentNumber = currentNumber .. char
			else
				if #currentNumber > 0 then
					table.insert(numbers, tonumber(currentNumber))
					currentNumber = ""
				end
			end
		end
		if #currentNumber > 0 then
			table.insert(numbers, tonumber(currentNumber))
		end

		for i = 1, #numbers, 3 do
			if numbers[i] and numbers[i + 1] and numbers[i + 2] then
				table.insert(data.Gradient, {
					r = numbers[i],
					g = numbers[i + 1],
					b = numbers[i + 2],
				})
			end
		end
	end

	return data
end

print("Starting to process currency...")

for _, currencyEntry in pairs(CurrencyRegistryFolder:GetChildren()) do
	if currencyEntry:IsA("ModuleScript") then
		local currencyName = currencyEntry.Name
		local scriptSource = currencyEntry.Source
		totalProcessed = totalProcessed + 1

		local success, data = pcall(parseCurrency, scriptSource)
		if success and data then
			currencyData[currencyName] = data
			successCount = successCount + 1
		else
			print("[WARNING] Failed to parse currency: " .. currencyName .. "\n" .. tostring(data))
		end
	end
end

print("Processing complete!")
print("Total currencies processed: " .. totalProcessed)
print("Successfully parsed: " .. successCount)

-- Convert to JSON
local jsonString = serde.encode("json", currencyData, true)

-- Ensure the target directory exists
local targetDir = "places/common/src/shared/configuration"
if not fs.isDir(targetDir) then
	fs.writeDir(targetDir)
end

-- Write the JSON file
local jsonPath = targetDir .. "/currency-data.json"

if fs.isFile(jsonPath) then
	fs.removeFile(jsonPath)
	print("Deleted existing currency-data.json")
end

fs.writeFile(jsonPath, jsonString)

print("Currency data JSON written to: " .. jsonPath)
print("Extraction complete!")
