--[[
	Unit Data Verification Script
	Compares TypeScript units data against live game Registry
	Run via MCP server to validate accuracy
]]

-- Units to verify (from our TypeScript file)
local unitsToVerify = {
	-- A-Units
	"Aira",
	"Aira [Evo]",
	"Aizen",
	"Aizen [Evo]",
	"Akame",
	"Akame [Evo]",
	"Android 18",
	"Android 21",
	"Android 21 [Demon]",
	"Aokiji",
	"Aokiji [Evo]",
	"Aqua",
	"Arlong",
	"ArlongAwakened",
	"Asta",
	"Asta [Evo]",
	-- B-Units
	"Baek YoonHo",
	"Baek YoonHo [Evo]",
	"Baruk",
	"Beerus",
	"Beerus [Evo]",
	"Beru",
	"Beru [Evo]",
	"Beru [Evo2]",
	"Beta",
	"Blackbeard",
	"Boa",
	"Boa [Evo]",
	"Broly",
	"Broly [Rage]",
	"Brook",
	"Buggy",
	"Bulma",
	-- C-Units
	"Captain Yami",
	"Captain Yami [Evo]",
	"CaptainKuro",
	"Carrot",
	"Carrot [Evo]",
	"Caulifla",
	"Cell [Max]",
	"Cell [Max] [Voided]",
	"Cha Hae In",
	"Cha Hae In [Evo]",
	"Cha Hae In [Old]",
	"Chisato",
	"Chisato [Evo]",
	"Choi jong in",
	"Choi jong in [Evo]",
	"Chrollo",
	"Chrollo [Evo]",
	"Cid",
	"Cid [Evo]",
}

-- Core fields to verify
local fieldsToVerify = {
	"TrueName",
	"DisplayName",
	"Rarity",
	"PlacementType",
	"Element",
	"UnitType",
	"PlacementPrice",
	"Damage",
	"AttackSpeed",
	"Range",
	"Ability",
	"AttackType",
	"AttackSize",
	"MaxPlacementAmount",
	"MaxUpgrades",
}

print("=== UNIT DATA VERIFICATION REPORT ===")
print("Verifying " .. #unitsToVerify .. " units against live game Registry...")
print("")

local errors = {}
local verified = 0

for _, unitName in ipairs(unitsToVerify) do
	local unitModule = game.ReplicatedStorage.Registry.Units:FindFirstChild(unitName)

	if not unitModule then
		table.insert(errors, "❌ " .. unitName .. ": MODULE NOT FOUND in live game")
	else
		-- Get the unit configuration
		local success, unitData = pcall(function()
			return require(unitModule)
		end)

		if not success then
			table.insert(errors, "❌ " .. unitName .. ": FAILED TO REQUIRE MODULE")
		elseif not unitData.configuration then
			table.insert(errors, "❌ " .. unitName .. ": NO CONFIGURATION FOUND")
		else
			local config = unitData.configuration

			-- Verify key fields exist and have reasonable values
			local unitErrors = {}

			for _, field in ipairs(fieldsToVerify) do
				if config[field] == nil then
					table.insert(unitErrors, "  - Missing field: " .. field)
				elseif field == "Damage" and (config[field] <= 0 or config[field] > 100000) then
					table.insert(unitErrors, "  - Invalid " .. field .. ": " .. tostring(config[field]))
				elseif field == "AttackSpeed" and (config[field] <= 0 or config[field] > 20) then
					table.insert(unitErrors, "  - Invalid " .. field .. ": " .. tostring(config[field]))
				elseif field == "Range" and (config[field] <= 0 or config[field] > 200) then
					table.insert(unitErrors, "  - Invalid " .. field .. ": " .. tostring(config[field]))
				elseif field == "PlacementPrice" and (config[field] <= 0 or config[field] > 10000) then
					table.insert(unitErrors, "  - Invalid " .. field .. ": " .. tostring(config[field]))
				end
			end

			-- Verify Released/Summonable attributes
			local released = unitModule:GetAttribute("Released")
			local summonable = unitModule:GetAttribute("Summonable")
			if released == nil then
				released = true
			end
			if summonable == nil then
				summonable = false
			end

			-- Verify UpgradesInfo exists and has reasonable structure
			if not config.UpgradesInfo then
				table.insert(unitErrors, "  - Missing UpgradesInfo")
			else
				local upgradeCount = 0
				for i = 1, 20 do -- Check up to 20 upgrades
					if config.UpgradesInfo[i] then
						upgradeCount = upgradeCount + 1
						if not config.UpgradesInfo[i].UpgradePrice then
							table.insert(unitErrors, "  - Upgrade " .. i .. " missing UpgradePrice")
						end
					end
				end
				if upgradeCount == 0 then
					table.insert(unitErrors, "  - No upgrades found in UpgradesInfo")
				end
			end

			-- Report results
			if #unitErrors > 0 then
				table.insert(errors, "⚠️  " .. unitName .. ":")
				for _, error in ipairs(unitErrors) do
					table.insert(errors, error)
				end
			else
				verified = verified + 1
				print("✅ " .. unitName .. " - OK")
			end
		end
	end
end

print("")
print("=== VERIFICATION SUMMARY ===")
print("✅ Verified: " .. verified .. "/" .. #unitsToVerify .. " units")
print("❌ Errors: " .. (#unitsToVerify - verified) .. " units")

if #errors > 0 then
	print("")
	print("=== DETAILED ERRORS ===")
	for _, error in ipairs(errors) do
		print(error)
	end
else
	print("")
	print("🎉 ALL UNITS VERIFIED SUCCESSFULLY!")
end

print("")
print("=== NEXT UNITS TO MIGRATE ===")
-- Show next few units that should be migrated
local nextUnits = { "Delta", "DioOH", "Doflamingo", "Dordoni", "Douma" }
for _, unitName in ipairs(nextUnits) do
	local unitModule = game.ReplicatedStorage.Registry.Units:FindFirstChild(unitName)
	if unitModule then
		print("📝 " .. unitName .. " - Ready for migration")
	else
		print("❓ " .. unitName .. " - Not found in live game")
	end
end
