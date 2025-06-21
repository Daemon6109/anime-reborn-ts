	local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Ragna"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Rogan [Silver Soul]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1870 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Heavy Hits", "Ice Destroyer"},
	Damage = 275 :: number,
	AttackSpeed = 5 :: number,
	Range = 17 :: number,
	Ability = "Silver Shatter" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["BlueStar"] = 10,
	--			["GreenStar"] = 10,
	--			["OrangeStar"] = 10,
	--			["PurpleStar"] = 10,
	--			["RedStar"] = 10,
	--			["Cupcake"] = 15;
	--			["RainbowStar"] = 2,
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};
		
	--	DisplayBuffs = {
	--		"+25% Damage";
	--		"+1 New Move: Death Ball";
	--		"+1 New Passive: Together we shine";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Ragna [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 337,
			AttackSpeed = 5,
			Range = 18,
			UpgradePrice = 2475,
		},
		[2] = {
			Damage = 425,
			AttackSpeed = 4.5,
			Range = 18,
			UpgradePrice = 2880,
		},
		[3] = {
			Damage = 575,
			AttackSpeed = 6,
			Range = 19,
			UpgradePrice = 3490,
			
			Ability = "Silverine Sword",
			AttackType = "Circle",
			AttackSize = 6
		},
		[4] = {
			Damage = 712,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 3545,
		},
		[5] = {
			Damage = 781,
			AttackSpeed = 5,
			Range = 21,
			UpgradePrice = 5275,
		},
		[6] = {
			Damage = 1031,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 6480,
			
			Ability = "Twin Hunting Blade",
			AttackType = "Line",
			AttackSize = 10,
		},
		[7] = {
			Damage = 1137,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 7225,
		},
		[8] = {
			Damage = 1287,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 8470,
		},
		[9] = {
			Damage = 1545,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 11750,

			Ability = "Silverine Slashes",
			AttackType = "Full",
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "79104939815951",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit