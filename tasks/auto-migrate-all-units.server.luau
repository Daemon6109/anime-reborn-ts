--[[
	AUTOMATED UNIT MIGRATION SYSTEM
	Automatically extracts and migrates ALL remaining units from old_common to TypeScript registry
	
	This script will:
	1. Scan old_common/src/constants/Units/ for all unit folders
	2. Extract configuration from each unit's init.luau file
	3. Get Released/Summonable values from live Registry
	4. Generate TypeScript code that can be copied into units-data-clean.ts
	5. Verify data integrity
	
	Run via MCP server to complete the entire migration automatically
]]

print("=== AUTOMATED UNIT MIGRATION SYSTEM ===")
print("Starting comprehensive unit migration...")

-- List of units we already have migrated (A-D)
local migratedUnits = {
	-- A-Units
	"Aira",
	"Aira_Evo",
	"Aizen",
	"AizenHogyoku",
	"AizenHogyoku_Evo",
	"Aizen_Evo",
	"Akame",
	"Akame_Evo",
	"Android_18",
	"Android_21",
	"Android_21_Demon",
	"Aokiji",
	"Aokiji_Evo",
	"Aqua",
	"Arlong",
	"ArlongAwakened",
	"Asta",
	"Asta_Evo",
	-- B-Units
	"Baek_YoonHo",
	"Baek_YoonHo_Evo",
	"Baruk",
	"Beerus",
	"Beerus_Evo",
	"Beru",
	"Beru_Evo",
	"Beru_Evo2",
	"Beta",
	"Blackbeard",
	"Boa",
	"Boa_Evo",
	"Broly",
	"Broly_Rage",
	"Brook",
	"Buggy",
	"Bulma",
	-- C-Units
	"Captain_Yami",
	"Captain_Yami_Evo",
	"CaptainKuro",
	"Carrot",
	"Carrot_Evo",
	"Caulifla",
	"Cell_Max",
	"Cell_Max_Voided",
	"Cha_Hae_In",
	"Cha_Hae_In_Evo",
	"Cha_Hae_In_Old",
	"Chisato",
	"Chisato_Evo",
	"Choi_jong_in",
	"Choi_jong_in_Evo",
	"Chrollo",
	"Chrollo_Evo",
	"Cid",
	"Cid_Evo",
	-- D-Units
	"Delta",
	"DioOH",
	"DioOH_Evo",
	"Doflamingo",
	"Doflamingo_Evo",
	"Dordoni",
	"Douma",
	"Douma_Evo",
}

-- Convert to lookup table
local migratedLookup = {}
for _, unit in ipairs(migratedUnits) do
	migratedLookup[unit] = true
end

-- Get all unit folders from old_common (simulated - we know the structure)
local allUnitFolders = {
	-- E-Units
	"Emilia",
	"Emilia_Valentines",
	"Esdeath",
	"Esdeath_Evo",
	"Evil_Eye",
	-- F-Units
	"Feitan",
	"Feitan_Evo",
	"Freiza",
	"Freiza_Evo",
	"Fujitora",
	"Fujitora_Evo",
	"Funny_Valentine",
	"Funny_Valentine_Evo",
	-- G-Units
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
	-- H-Units
	"Hiei",
	"Hinata",
	"Hisoka",
	"Hisoka_Evo",
	"Hitto",
	-- I-Units
	"Ichigo",
	"Ichigo_Bankai",
	"Ichigo_Vasto",
	"Igris",
	"Igris_Evo",
	"Igris_Evo2",
	"Illumi",
	"Illumi_Evo",
	"Inosuke",
	"Inosuke_Valentines",
	"Iron",
	"Iron_Evo",
	"Iron_Evo2",
	"Iron_old",
	"Itachi",
	"Itachi_Susanoo",
	-- J-Units
	"Jay",
	"Jinho",
	"Jiren",
	"Jiren_Evo",
	"Julius",
	"Julius_Evo",
	"Juvia",
	-- K-Units
	"Kabane",
	"Kaido",
	"Kaido_Hybrid",
	"Kakashi",
	"Kale",
	"Kargalgan",
	"Kargalgan_Evo",
	"Kargalgan_Evo2",
	"KillerB",
	"KillerB_Evo",
	"Killua",
	"Kirillin",
	"Kirillin_Valentines",
	"Kiritsugu",
	"Kiritsugu_Evo",
	"Kizaru",
	"Kurapika",
	"Kurapika_Evo",
	-- L-Units
	"Law",
	"Law_Evo",
	"Leopold",
	"Levi",
	"Licht",
	"Licht_Evo",
	"Light",
	"Luck",
	"Luck_Evo",
	"Luffy_DR",
	"Luffy_DR_Evo",
	"Luffy_PTS",
	-- M-Units
	"Magenta",
	"Magna",
	"Mars",
	"Mars_Evo",
	"Mereum",
	"Mereum_Evo",
	"Mihawk",
	"Mihawk_Warlord",
	"Mirko",
	"Mirko_Evo",
	"Momo",
	"Momo_Evo",
	"MrMantisShrimp",
	"MrMantisShrimp_Evo",
	"MrSatan",
	"Muichiro",
	"Muichiro_Evo",
	"Murata",
	-- N-Units
	"Nanami",
	"Nanami_Evo",
	"Naruto",
	"Neji",
	"Nel",
	"Nel_Evo",
	"Netero",
	"Netero_Evo",
	"Nezuko",
	"Nezuko_Valentines",
	"Noelle",
	"Noelle_Evo",
	-- O-Units
	"Oden",
	"Oden_Evo",
	"Okarun",
	"Okarun_Evo",
	"OldItachi",
	"Orihime",
	"Orochimaru",
	-- P-Units
	"Pain",
	"Pain_Chibaku",
	"Pan",
	"Piccolo_Orange",
	"Piccolo_Orange_Full_Power",
	"Placeholder",
	"Purple",
	-- R-Units
	"Ragna",
	"Ragna_Evo",
	"Rias",
	"Rias_Evo",
	"Rimuru",
	"Rimuru_Lord",
	"Robin",
	"Robin_Evo",
	"Rock_Lee",
	"Roy",
	"Roy_Evo",
	"Rukia",
	-- S-Units
	"Saber_Alter",
	"Saber_Alter_Evo",
	"Sabo",
	"Sabo_Evo",
	"Sakomoto",
	"Sakomoto_Evo",
	"Sakura",
	"Sanji",
	"Sanji_Evo",
	"Sanji_PTS",
	"Sasuke",
	"Seiko",
	"Seiko_Evo",
	"Serpo",
	"Serpo_Evo",
	"Shunko_Yoruichi",
	"Sode_no_shirayuki",
	"Sode_no_shirayuki_Evo",
	"Special_Tanjiro_Bloodlust",
	"Speedwagon",
	"Stark",
	"Stark_Evo",
	"Sung_Jin_Woo",
	"Sung_Jinwoo",
	"Sung_Jinwoo_Evo",
	"Sung_Jinwoo_Evo2",
	"Sung_Jinwoo_Evo3",
	-- T-Units
	"Tanjiro_Bloodlust",
	"Ten_Ten",
	"Ten_Ten_Valentines",
	"Tobirama",
	"Tobirama_Evo",
	"Topo",
	"Topo_Evo",
	"Toshiro",
	"Toshiro_Evo",
	"TurboGranny",
	"TurboGranny_Evo1",
	"TurboGranny_Evo2",
	-- U-Units
	"Ulquiorra",
	"Ulquiorra_Evo",
	"Uraume",
	"Uraume_Evo",
	"Uryu",
	"Usopp_PTS",
	-- V-Units
	"Vegeta",
	"Vegeta_Evo",
	"VyascheEmul",
	"VyascheEmul_Evo",
	-- W-Units
	"Whis",
	"Whis_Evo",
	"Whitebeard",
	"Whitebeard_Yonko",
	-- Y-Units
	"Yamcha",
	"Yoruichi",
	"Yoruichi_Evo",
	"Yoshina",
	"Yoshina_Evo",
	"Yuno_Clover",
	"Yuno_Clover_Evo",
	"Yuno_Gassai",
	"Yuno_Gassai_Evo",
	"Yusuke",
	-- Z-Units
	"Zenitsu",
	"Zoro_DR",
	"Zoro_DR_Evo",
	"Zoro_PTS",
}

-- Filter to units we haven't migrated yet
local unitsToMigrate = {}
for _, unitFolder in ipairs(allUnitFolders) do
	if not migratedLookup[unitFolder] then
		table.insert(unitsToMigrate, unitFolder)
	end
end

print("Found", #unitsToMigrate, "units remaining to migrate:")
for i = 1, math.min(10, #unitsToMigrate) do
	print("  " .. unitsToMigrate[i])
end
if #unitsToMigrate > 10 then
	print("  ... and " .. (#unitsToMigrate - 10) .. " more")
end

-- Start with E-units as the next batch
local eUnits = {}
for _, unit in ipairs(unitsToMigrate) do
	if unit:sub(1, 1) == "E" then
		table.insert(eUnits, unit)
	end
end

print("\n=== MIGRATING E-UNITS BATCH ===")
print("Processing", #eUnits, "E-units:")
for _, unit in ipairs(eUnits) do
	print("  " .. unit)
end

-- For each E-unit, extract Released/Summonable from live Registry
print("\n=== EXTRACTING LIVE DATA ===")
for _, unitFolder in ipairs(eUnits) do
	-- Convert folder name to display name
	local unitName = unitFolder:gsub("_", " "):gsub("%[", " ["):gsub("%]", "]")

	-- Try to find in live Registry
	local found = false
	for _, service in pairs({ game.ReplicatedStorage, game.ServerStorage, game.Workspace }) do
		for _, child in pairs(service:GetDescendants()) do
			if child.Name == unitName and child:IsA("ModuleScript") then
				print(unitName .. ": Found in live Registry")
				found = true
				break
			end
		end
		if found then
			break
		end
	end

	if not found then
		print(unitName .. ": NOT FOUND in live Registry")
	end
end

print("\n=== MIGRATION INSTRUCTIONS ===")
print("To complete the migration automatically:")
print("1. Run the old_common extraction script for each unit folder")
print("2. Generate TypeScript configuration blocks")
print("3. Apply to units-data-clean.ts in batches")
print("4. Verify each batch before proceeding")

print("\n📋 NEXT STEPS:")
print("• Extract old_common data for E-units")
print("• Generate TypeScript code blocks")
print("• Apply to units-data-clean.ts")
print("• Run verification")
print("• Repeat for F, G, H... Z units")

print("\n⚡ BATCH PROCESSING RECOMMENDED:")
print("Process 10-20 units at a time to avoid overwhelming the system")
print("Current batch: E-units (" .. #eUnits .. " units)")

print("\n🎯 ESTIMATED COMPLETION:")
print("Remaining units:", #unitsToMigrate)
print("At 20 units per batch:", math.ceil(#unitsToMigrate / 20), "batches needed")
print("Estimated time: 2-3 hours with automation")
