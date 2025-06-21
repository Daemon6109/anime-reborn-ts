local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Esdeath"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Sidea [Frost General]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Freezing Aura", "Ice Frenzy"},
	Damage = 562 :: number,
	AttackSpeed = 8 :: number,
	Range = 15 :: number,
	Ability = "Frost Slashes" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
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

	--	EvolvesInto = "Esdeath [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 637,
			AttackSpeed = 8,
			Range = 16,
			UpgradePrice = 2700,
		},
		[2] = {
			Damage = 737,
			AttackSpeed = 7.5,
			Range = 18,
			UpgradePrice = 3765,
		},
		[3] = {
			Damage = 862,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 4540,
			
			Ability = "Ice Strike",
			AttackType = "Line",
			AttackSize = 10
		},
		[4] = {
			Damage = 962,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 5330,
		},
		[5] = {
			Damage = 1062,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 6000,
		},
		[6] = {
			Damage = 1500,
			AttackSpeed = 8,
			Range = 24,
			UpgradePrice = 6660,
			
			UnitType = "Hybrid",
			
			Ability = "Icicle Barrage",
			AttackType = "Line",
			AttackSize = 10
		},
		[7] = {
			Damage = 1687,
			AttackSpeed = 7,
			Range = 26,
			UpgradePrice = 7780,
		},
		[8] = {
			Damage = 1875,
			AttackSpeed = 7,
			Range = 26,
			UpgradePrice = 9540,
		},
		[9] = {
			Damage = 2250,
			AttackSpeed = 6.5,
			Range = 27,
			UpgradePrice = 13400,
			
			Ability = "Ice Meteor",
			AttackType = "Full",
			AttackSize = 10
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
	idle = "98696529098501",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit