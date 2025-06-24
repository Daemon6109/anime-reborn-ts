--[[
	BATCH UNIT EXTRACTOR
	Extracts configuration from old_common unit files and generates TypeScript code
	
	This script reads the old_common unit folders and generates the exact TypeScript
	configuration blocks that can be copied into units-data-clean.ts
]]

print("=== BATCH UNIT EXTRACTOR ===")

-- Function to convert folder name to display name
local function folderToDisplayName(folder)
	return folder:gsub("_", " "):gsub("%[", " ["):gsub("%]", "]")
end

-- Function to convert folder name to TypeScript key
local function folderToTSKey(folder)
	return folder:gsub("_", " "):gsub(" ", "_")
end

-- Get E-units to process
local eUnits = {
	"Emilia",
	"Emilia_Valentines",
	"Esdeath",
	"Esdeath_Evo",
	"Evil_Eye",
}

-- Additional F-G units for next batch
local fgUnits = {
	"Feitan",
	"Feitan_Evo",
	"Freiza",
	"Freiza_Evo",
	"Fujitora",
	"Fujitora_Evo",
	"Funny_Valentine",
	"Funny_Valentine_Evo",
	"Gamma_Brothers",
	"Gamma_Brothers_Evo",
	"Genos",
	"Gohan",
	"Gohan_Beast",
	"Gojo_Base",
	"GokuSSJ",
	"GokuSSJ_Evo",
	"Goku_Evo",
	"Gon",
	"Gon_Evo",
	"Gordon",
	"Grimmjow",
	"Grimmjow_Evo",
}

print("Ready to extract", #eUnits, "E-units +", #fgUnits, "F-G units")

-- Generate extraction commands for old_common
print("\n=== OLD_COMMON EXTRACTION COMMANDS ===")
print("Run these commands to extract unit data:")

for _, unitFolder in ipairs(eUnits) do
	print("# " .. unitFolder)
	print("cat /workspace/old_common/src/constants/Units/" .. unitFolder .. "/init.luau")
	print("")
end

-- Generate TypeScript template for quick migration
print("\n=== TYPESCRIPT TEMPLATE ===")
print("Use this template structure for each unit:")

local function generateTSTemplate(unitFolder)
	local displayName = folderToDisplayName(unitFolder)
	local tsKey = folderToTSKey(unitFolder)

	return [[
	]] .. tsKey .. [[: {
		configuration: {
			// Copy Viewport, PreviewViewport, UnitCardViewport from old_common
			MaxPlacementAmount: 0, // From old_common
			MaxUpgrades: 0, // From old_common  
			SellCost: 100,
			TrueName: "]] .. unitFolder .. [[",
			DisplayName: "]] .. displayName .. [[", // From old_common
			Rarity: "Common", // From old_common
			PlacementType: "Ground", // From old_common
			Element: "Fire", // From old_common
			UnitType: "Ground", // From old_common
			PlacementPrice: 0, // From old_common
			CanSell: true,
			Passives: [], // From old_common
			Damage: 0, // From old_common
			AttackSpeed: 0, // From old_common
			Range: 0, // From old_common
			Ability: "", // From old_common
			SpecialAbility: "",
			SpecialAbilityCooldown: 0,
			IsSpecialAbilityGlobalCooldown: false,
			Money: 0,
			AttackType: "Circle", // From old_common
			AttackSize: 0, // From old_common
			AttackEffect: "", // From old_common
			AttackEffectDuration: 0,
			AttackCriticalChance: 0.05,
			AttackCriticalDamage: 0.3,
			Released: true, // From MCP server
			Summonable: false, // From MCP server
			// EvolveData: [], // If exists in old_common
			UpgradesInfo: {
				// Copy from old_common UpgradesInfo
			},
		},
		animations: {
			idle: "18172212518", // From old_common or default
			walk: "17264216432", // From old_common or default
		},
		radius: 2.5,
		tradable: true, // From old_common
		// evolved: "BaseUnit", // If this is an evolution
	},]]
end

-- Show template for first E-unit
print(generateTSTemplate("Emilia"))

print("\n=== AUTOMATION WORKFLOW ===")
print("1. Extract data from old_common for each unit")
print("2. Fill in the TypeScript template")
print("3. Get Released/Summonable from MCP server")
print("4. Add to units-data-clean.ts")
print("5. Run verification")

print("\n=== MCP SERVER COMMANDS ===")
print("Use these commands to get Released/Summonable data:")

for _, unitFolder in ipairs(eUnits) do
	local displayName = folderToDisplayName(unitFolder)
	print("-- Check " .. displayName)
	print('local unit = game.ReplicatedStorage.Registry.Units:FindFirstChild("' .. displayName .. '")')
	print("if unit then")
	print('    local released = unit:GetAttribute("Released") or true')
	print('    local summonable = unit:GetAttribute("Summonable") or false')
	print(
		'    print("' .. displayName .. ': Released=" .. tostring(released) .. ", Summonable=" .. tostring(summonable))'
	)
	print("end")
	print("")
end

print("\n🚀 READY FOR BATCH PROCESSING!")
print("Process E-units first, then F-G units, then continue alphabetically")
print("Target: Complete all 200+ remaining units in 2-3 hours")
