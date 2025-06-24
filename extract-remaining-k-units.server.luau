-- Extract remaining K-units data and generate TypeScript blocks
local remainingKUnits = {
	"KillerB_Evo",
	"Kirillin",
	"Kirillin_Valentines",
	"Kiritsugu",
	"Kiritsugu_Evo",
	"Kizaru",
	"Kurapika",
	"Kurapika_Evo",
}

-- Helper function to format enum values
local function formatEnumValue(value, enumType)
	if enumType == "Rarity" then
		return '"' .. value .. '"'
	elseif enumType == "PlacementType" then
		return '"' .. value .. '"'
	elseif enumType == "Element" then
		return '"' .. value .. '"'
	elseif enumType == "UnitType" then
		return '"' .. value .. '"'
	elseif enumType == "AttackType" then
		return '"' .. value .. '"'
	else
		return value
	end
end

-- Helper function to format upgrade info
local function formatUpgrade(upgradeData)
	local result = "{\n"

	for key, value in pairs(upgradeData) do
		if key == "UnitType" then
			result = result .. "        " .. key .. ": " .. formatEnumValue(value, "UnitType") .. ",\n"
		elseif key == "AttackType" then
			result = result .. "        " .. key .. ": " .. formatEnumValue(value, "AttackType") .. ",\n"
		elseif type(value) == "string" then
			result = result .. "        " .. key .. ': "' .. value .. '",\n'
		else
			result = result .. "        " .. key .. ": " .. tostring(value) .. ",\n"
		end
	end

	result = result .. "      }"
	return result
end

-- Generate TypeScript blocks for each unit
for _, unitName in ipairs(remainingKUnits) do
	-- Read the unit file
	local path = "/workspace/old_common/src/constants/Units/" .. unitName .. "/init.luau"
	local file = io.open(path, "r")

	if file then
		local content = file:read("*all")
		file:close()

		-- Extract basic unit data from content
		local displayName = content:match('DisplayName = "([^"]*)"') or unitName
		local rarity = content:match('Rarity = "([^"]*)"') or "Unknown"
		local placementType = content:match('PlacementType = "([^"]*)"') or "Ground"
		local element = content:match('Element = "([^"]*)"') or "None"
		local unitType = content:match('UnitType = "([^"]*)"') or "Ground"
		local placementPrice = content:match("PlacementPrice = (%d+)") or "0"
		local maxPlacementAmount = content:match("MaxPlacementAmount = (%d+)") or "1"
		local maxUpgrades = content:match("MaxUpgrades = (%d+)") or "5"
		local damage = content:match("Damage = (%d+)") or "0"
		local attackSpeed = content:match("AttackSpeed = (%d+)") or "1"
		local range = content:match("Range = (%d+)") or "1"
		local ability = content:match('Ability = "([^"]*)"') or ""
		local attackType = content:match('AttackType = "([^"]*)"') or "Circle"
		local attackSize = content:match("AttackSize = (%d+)") or "1"
		local attackEffect = content:match('AttackEffect = "([^"]*)"') or ""
		local attackCriticalChance = content:match("AttackCriticalChance = ([%d%.]+)") or "0"
		local attackCriticalDamage = content:match("AttackCriticalDamage = ([%d%.]+)") or "0"
		local tradable = content:match("Tradable = (%w+)") or "true"
		local evolved = content:match('Evolved = "([^"]*)"') or nil

		print("=== " .. unitName .. " ===")
		print('  "' .. unitName:gsub("_", " "):gsub("%[", " ["):gsub("%]", "]") .. '": {')
		print("    Configuration: {")
		print('      DisplayName: "' .. displayName .. '",')
		print("      Rarity: " .. formatEnumValue(rarity, "Rarity") .. ",")
		print("      PlacementType: " .. formatEnumValue(placementType, "PlacementType") .. ",")
		print("      Element: " .. formatEnumValue(element, "Element") .. ",")
		print("      UnitType: " .. formatEnumValue(unitType, "UnitType") .. ",")
		print("      PlacementPrice: " .. placementPrice .. ",")
		print("      MaxPlacementAmount: " .. maxPlacementAmount .. ",")
		print("      MaxUpgrades: " .. maxUpgrades .. ",")
		print("      Damage: " .. damage .. ",")
		print("      AttackSpeed: " .. attackSpeed .. ",")
		print("      Range: " .. range .. ",")
		print('      Ability: "' .. ability .. '",')
		print("      AttackType: " .. formatEnumValue(attackType, "AttackType") .. ",")
		print("      AttackSize: " .. attackSize .. ",")

		if attackEffect ~= "" then
			print('      AttackEffect: "' .. attackEffect .. '",')
		end

		print("      AttackCriticalChance: " .. attackCriticalChance .. ",")
		print("      AttackCriticalDamage: " .. attackCriticalDamage .. ",")
		print("      Tradable: " .. tradable .. ",")

		if evolved then
			print('      Evolved: "' .. evolved .. '",')
		end

		print("    },")
		print("    Upgrades: {")

		-- Parse upgrades (simplified - just show structure)
		local upgradeCount = tonumber(maxUpgrades) or 5
		for i = 1, upgradeCount do
			local upgradePattern = "%[" .. i .. "%] = {([^}]*)}"
			local upgradeMatch = content:match(upgradePattern)
			if upgradeMatch then
				print("      [" .. i .. "]: {")

				-- Extract upgrade values
				local upgradeDamage = upgradeMatch:match("Damage = (%d+)") or damage
				local upgradeAttackSpeed = upgradeMatch:match("AttackSpeed = (%d+)") or attackSpeed
				local upgradeRange = upgradeMatch:match("Range = (%d+)") or range
				local upgradePrice = upgradeMatch:match("UpgradePrice = (%d+)") or "100"
				local upgradeAbility = upgradeMatch:match('Ability = "([^"]*)"')
				local upgradeAttackType = upgradeMatch:match('AttackType = "([^"]*)"')
				local upgradeAttackSize = upgradeMatch:match("AttackSize = (%d+)")
				local upgradeUnitType = upgradeMatch:match('UnitType = "([^"]*)"')

				print("        Damage: " .. upgradeDamage .. ",")
				print("        AttackSpeed: " .. upgradeAttackSpeed .. ",")
				print("        Range: " .. upgradeRange .. ",")
				print("        UpgradePrice: " .. upgradePrice .. ",")

				if upgradeAbility then
					print('        Ability: "' .. upgradeAbility .. '",')
				end
				if upgradeAttackType then
					print("        AttackType: " .. formatEnumValue(upgradeAttackType, "AttackType") .. ",")
				end
				if upgradeAttackSize then
					print("        AttackSize: " .. upgradeAttackSize .. ",")
				end
				if upgradeUnitType then
					print("        UnitType: " .. formatEnumValue(upgradeUnitType, "UnitType") .. ",")
				end

				print("      },")
			end
		end

		print("    },")
		print("    Released: true,") -- Will be updated based on live data
		print("    Summonable: false,") -- Will be updated based on live data
		print("  },")
		print()
	else
		print("Could not read file for " .. unitName)
	end
end
