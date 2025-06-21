local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Rias"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Rise [Queen]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2222 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Heir of the Throne", "Ultimate-Class Devil King"},
	Damage = 937 :: number,
	AttackSpeed = 8 :: number,
	Range = 25 :: number,
	Ability = "Destruction Orbs" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable
		
	--	[1] = {
	--		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--			Items = { -- List of items to check. Index = name, Value = amount
	--				["BlueStar"] = 10,
	--				["GreenStar"] = 10,
	--				["OrangeStar"] = 10,
	--				["PurpleStar"] = 10,
	--				["RedStar"] = 10,
	--				["Cupcake"] = 15;
	--				["RainbowStar"] = 2,
	--			};
	
	--			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--			};

	--			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--			--	return true
	--			--end,
	--		};
		
	--		DisplayBuffs = {
	--			"+25% Damage";
	--			"+1 New Move: Death Ball";
	--			"+1 New Passive: Together we shine";
	--		};

	--		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--		EvolvesInto = "Android 21 [Demon]" :: string; -- The unit to evolve into
	--	}
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1250,
			AttackSpeed = 7.5,
			Range = 27,
			UpgradePrice = 3000,
		},
		[2] = {
			Damage = 1625,
			AttackSpeed = 7.5,
			Range = 28,
			UpgradePrice = 3850,
		},
		[3] = {
			Damage = 2000,
			AttackSpeed = 7.5,
			Range = 29,
			UpgradePrice = 4900,
		},
		[4] = {
			Damage = 2500,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 6075,
			
			UnitType = "Hybrid",
			
			Ability = "Purgatory",
			AttackType = "Circle",
			AttackSize = 14
		},
		[5] = {
			Damage = 2937,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 7500,
		},
		[6] = {
			Damage = 3375,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 9250,
		},
		[7] = {
			Damage = 3875,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 4687,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 13750,
		},
		[9] = {
			Damage = 5500,
			AttackSpeed = 7,
			Range = 37,
			UpgradePrice = 15000,
			
			Ability = "Extinguished Fallen Star",
			AttackType = "Line",
			AttackSize = 15
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
	idle = "134610752092492",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit