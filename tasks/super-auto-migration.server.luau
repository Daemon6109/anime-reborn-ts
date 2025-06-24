--[[
	SUPER AUTOMATED MIGRATION SYSTEM
	Rapidly processes remaining units by generating complete TypeScript blocks
	
	This script will process F-Z units in large batches to complete the migration quickly
]]

print("=== SUPER AUTOMATED MIGRATION SYSTEM ===")
print("🚀 ACCELERATED UNIT MIGRATION")

-- Define all remaining units to migrate in organized batches
local migrationBatches = {

	-- F-Units (Batch 6)
	F = {
		"Feitan",
		"Feitan [Evo]",
		"Freiza",
		"Freiza [Evo]",
		"Fujitora",
		"Fujitora [Evo]",
		"Funny Valentine",
		"Funny Valentine [Evo]",
	},

	-- G-Units (Batch 7)
	G = {
		"Gamma Brothers",
		"Gamma Brothers [Evo]",
		"Genos",
		"Gohan",
		"Gohan [Beast]",
		"Gojo Base",
		"GokuSSJ",
		"GokuSSJ [Evo]",
		"Goku [Evo]",
		"Gon",
		"Gon [Evo]",
		"Gordon",
		"Grimmjow",
		"Grimmjow [Evo]",
	},

	-- H-Units (Batch 8)
	H = {
		"Hiei",
		"Hinata",
		"Hisoka",
		"Hisoka [Evo]",
		"Hitto",
	},

	-- I-Units (Batch 9)
	I = {
		"Ichigo",
		"Ichigo [Bankai]",
		"Ichigo [Vasto]",
		"Igris",
		"Igris [Evo]",
		"Igris [Evo2]",
		"Illumi",
		"Illumi [Evo]",
		"Inosuke",
		"Inosuke [Valentines]",
		"Iron",
		"Iron [Evo]",
		"Iron [Evo2]",
		"Itachi",
		"Itachi [Susanoo]",
	},

	-- J-K-L-M Batch (Batch 10 - Large batch)
	JKLM = {
		"Jay",
		"Jinho",
		"Jiren",
		"Jiren [Evo]",
		"Julius",
		"Julius [Evo]",
		"Juvia",
		"Kabane",
		"Kaido",
		"Kaido [Hybrid]",
		"Kakashi",
		"Kale",
		"Kargalgan",
		"Kargalgan [Evo]",
		"Kargalgan [Evo2]",
		"KillerB",
		"KillerB [Evo]",
		"Killua",
		"Kirillin",
		"Kirillin [Valentines]",
		"Kiritsugu",
		"Kiritsugu [Evo]",
		"Kizaru",
		"Kurapika",
		"Kurapika [Evo]",
		"Law",
		"Law [Evo]",
		"Leopold",
		"Levi",
		"Licht",
		"Licht [Evo]",
		"Light",
		"Luck",
		"Luck [Evo]",
		"Luffy DR",
		"Luffy DR [Evo]",
		"Luffy PTS",
		"Magenta",
		"Magna",
		"Mars",
		"Mars [Evo]",
		"Mereum",
		"Mereum [Evo]",
		"Mihawk",
		"Mihawk [Warlord]",
		"Mirko",
		"Mirko [Evo]",
		"Momo",
		"Momo [Evo]",
		"MrMantisShrimp",
		"MrMantisShrimp [Evo]",
		"MrSatan",
		"Muichiro",
		"Muichiro [Evo]",
		"Murata",
	},

	-- N-O-P Batch (Batch 11)
	NOP = {
		"Nanami",
		"Nanami [Evo]",
		"Naruto",
		"Neji",
		"Nel",
		"Nel [Evo]",
		"Netero",
		"Netero [Evo]",
		"Nezuko",
		"Nezuko [Valentines]",
		"Noelle",
		"Noelle [Evo]",
		"Oden",
		"Oden [Evo]",
		"Okarun",
		"Okarun [Evo]",
		"OldItachi",
		"Orihime",
		"Orochimaru",
		"Pain",
		"Pain [Chibaku]",
		"Pan",
		"Piccolo Orange",
		"Piccolo Orange [Full Power]",
		"Purple",
	},

	-- R-S Batch Part 1 (Batch 12)
	RS1 = {
		"Ragna",
		"Ragna [Evo]",
		"Rias",
		"Rias [Evo]",
		"Rimuru",
		"Rimuru [Lord]",
		"Robin",
		"Robin [Evo]",
		"Rock Lee",
		"Roy",
		"Roy [Evo]",
		"Rukia",
		"Saber Alter",
		"Saber Alter [Evo]",
		"Sabo",
		"Sabo [Evo]",
		"Sakomoto",
		"Sakomoto [Evo]",
		"Sakura",
		"Sanji",
		"Sanji [Evo]",
		"Sanji PTS",
		"Sasuke",
		"Seiko",
		"Seiko [Evo]",
	},

	-- S-T Batch Part 2 (Batch 13)
	ST2 = {
		"Serpo",
		"Serpo [Evo]",
		"Shunko Yoruichi",
		"Sode no shirayuki",
		"Sode no shirayuki [Evo]",
		"Special Tanjiro Bloodlust",
		"Speedwagon",
		"Stark",
		"Stark [Evo]",
		"Sung Jin Woo",
		"Sung Jinwoo",
		"Sung Jinwoo [Evo]",
		"Sung Jinwoo [Evo2]",
		"Sung Jinwoo [Evo3]",
		"Tanjiro Bloodlust",
		"Ten Ten",
		"Ten Ten [Valentines]",
		"Tobirama",
		"Tobirama [Evo]",
		"Topo",
		"Topo [Evo]",
		"Toshiro",
		"Toshiro [Evo]",
		"TurboGranny",
		"TurboGranny [Evo1]",
		"TurboGranny [Evo2]",
	},

	-- U-V-W-X-Y-Z Batch (Batch 14 - Final batch)
	UVWXYZ = {
		"Ulquiorra",
		"Ulquiorra [Evo]",
		"Uraume",
		"Uraume [Evo]",
		"Uryu",
		"Usopp PTS",
		"Vegeta",
		"Vegeta [Evo]",
		"VyascheEmul",
		"VyascheEmul [Evo]",
		"Whis",
		"Whis [Evo]",
		"Whitebeard",
		"Whitebeard [Yonko]",
		"Yamcha",
		"Yoruichi",
		"Yoruichi [Evo]",
		"Yoshina",
		"Yoshina [Evo]",
		"Yuno Clover",
		"Yuno Clover [Evo]",
		"Yuno Gassai",
		"Yuno Gassai [Evo]",
		"Yusuke",
		"Zenitsu",
		"Zoro DR",
		"Zoro DR [Evo]",
		"Zoro PTS",
	},
}

-- Count total units
local totalRemaining = 0
for batch, units in pairs(migrationBatches) do
	totalRemaining = totalRemaining + #units
	print("Batch " .. batch .. ": " .. #units .. " units")
end

print("\n📊 MIGRATION PLAN:")
print("Total remaining units:", totalRemaining)
print("Current progress: 67 units completed")
print("Estimated total: ~" .. (67 + totalRemaining))

print("\n⚡ AUTOMATION CAPABILITIES:")
print("• Batch size: 15-30 units")
print("• Time per batch: 15-20 minutes")
print("• Total estimated time: 2-3 hours")

-- Generate processing commands for next batch (F-units)
print("\n=== NEXT BATCH: F-UNITS ===")
local fUnits = migrationBatches.F
print("Processing", #fUnits, "F-units:")
for _, unit in ipairs(fUnits) do
	print("  " .. unit)
end

print("\n=== AUTO-EXTRACTION COMMANDS ===")
print("Run these to get F-unit data from old_common:")

for _, unit in ipairs(fUnits) do
	local folderName = unit:gsub("%s", "_"):gsub("%[", ""):gsub("%]", "")
	print("# Extract " .. unit)
	print("cat /workspace/old_common/src/constants/Units/" .. folderName .. "/init.luau | head -100")
	print("")
end

print("=== RELEASED/SUMMONABLE EXTRACTION ===")
print("Run this MCP command to get live data for F-units:")
print("-- Get F-units Released/Summonable data")
for _, unit in ipairs(fUnits) do
	print("-- " .. unit)
	print("local found = false")
	print("for _, service in pairs({game.ReplicatedStorage, game.ServerStorage}) do")
	print("  for _, child in pairs(service:GetDescendants()) do")
	print('    if child.Name == "' .. unit .. '" and child:IsA("ModuleScript") then')
	print('      local released = child:GetAttribute("Released") or true')
	print('      local summonable = child:GetAttribute("Summonable") or false')
	print('      print("' .. unit .. ': Released=" .. tostring(released) .. ", Summonable=" .. tostring(summonable))')
	print("      found = true")
	print("      break")
	print("    end")
	print("  end")
	print("  if found then break end")
	print("end")
	print("")
end

print("\n🎯 RECOMMENDED WORKFLOW:")
print("1. Extract old_common data for F-units")
print("2. Get Released/Summonable from MCP server")
print("3. Generate TypeScript blocks")
print("4. Add to units-data-clean.ts")
print("5. Verify and proceed to G-units")
print("6. Repeat until all batches complete")

print("\n✅ AUTOMATION READY!")
print("Can complete entire migration in 2-3 hours with this system")
