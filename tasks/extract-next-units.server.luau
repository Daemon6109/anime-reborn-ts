--[[
	Unit Data Extraction Script
	Extracts unit configurations from old_common for the next batch
	Run via MCP server to get Released/Summonable values
]]

-- Next batch of units to extract (D-Units)
local unitsToExtract = {
	"Delta",
	"DioOH",
	"DioOH [Evo]",
	"Doflamingo",
	"Doflamingo [Evo]",
	"Dordoni",
	"Douma",
	"Douma [Evo]",
}

print("=== UNIT DATA EXTRACTION REPORT ===")
print("Extracting data for " .. #unitsToExtract .. " D-units...")
print("")

-- Get Released/Summonable values from live game
print("=== RELEASED/SUMMONABLE VALUES ===")
for _, unitName in ipairs(unitsToExtract) do
	local unitModule = game.ReplicatedStorage.Registry.Units:FindFirstChild(unitName)
	if unitModule then
		local released = unitModule:GetAttribute("Released")
		local summonable = unitModule:GetAttribute("Summonable")
		if released == nil then
			released = true
		end
		if summonable == nil then
			summonable = false
		end
		print(unitName .. ": Released=" .. tostring(released) .. ", Summonable=" .. tostring(summonable))
	else
		print(unitName .. ": MODULE NOT FOUND")
	end
end

print("")
print("=== CONFIGURATION DATA SAMPLE ===")
-- Get a sample of configuration data for reference
for i, unitName in ipairs(unitsToExtract) do
	if i <= 3 then -- Only show first 3 to avoid spam
		local unitModule = game.ReplicatedStorage.Registry.Units:FindFirstChild(unitName)
		if unitModule then
			local success, unitData = pcall(function()
				return require(unitModule)
			end)

			if success and unitData.configuration then
				local config = unitData.configuration
				print("--- " .. unitName .. " ---")
				print("DisplayName: " .. tostring(config.DisplayName))
				print("Rarity: " .. tostring(config.Rarity))
				print("Element: " .. tostring(config.Element))
				print("PlacementPrice: " .. tostring(config.PlacementPrice))
				print("Damage: " .. tostring(config.Damage))
				print("AttackSpeed: " .. tostring(config.AttackSpeed))
				print("Range: " .. tostring(config.Range))
				print("Ability: " .. tostring(config.Ability))
				print("AttackType: " .. tostring(config.AttackType))
				print("MaxUpgrades: " .. tostring(config.MaxUpgrades))
				print("")
			end
		end
	end
end

print("=== NEXT STEPS ===")
print("1. Extract unit configurations from old_common/src/constants/Units/")
print("2. Apply Released/Summonable values from above")
print("3. Add to units-data-clean.ts with proper TypeScript types")
print("4. Run verification script to ensure accuracy")
print("")
print("Files to check in old_common:")
for _, unitName in ipairs(unitsToExtract) do
	-- Convert live game names to old_common folder names
	local folderName = unitName:gsub(" ", "_"):gsub("%[", ""):gsub("%]", "")
	if folderName:find("_Evo") then
		folderName = folderName:gsub("_Evo", "_Evo")
	end
	print("- " .. folderName .. "/init.luau")
end
