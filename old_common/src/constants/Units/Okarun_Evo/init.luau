local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "Okarun"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Oktawalk [Turbo]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1860 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Turbocharger", "Careless Acceleration"},
	Damage = 618 :: number,
	AttackSpeed = 3.5 :: number,
	Range = 20 :: number,
	Ability = "Granny Headbut" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 11 :: Enums.AttackSizeTypes,
	AttackEffect = "Paralysis", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
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

	--	EvolvesInto = "Android 21 [Demon]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 937,
			AttackSpeed = 3.5,
			Range = 21,
			UpgradePrice = 2800,
		},
		[2] = {
			Damage = 1300,
			AttackSpeed = 3.5,
			Range = 24,
			UpgradePrice = 4000,
		},
		[3] = {
			Damage = 1550,
			AttackSpeed = 3.5,
			Range = 25,
			UpgradePrice = 6100,
		},
		[4] = {
			Damage = 2325,
			AttackSpeed = 4.5,
			Range = 27,
			UpgradePrice = 8250,

			Ability = "After-Images",
			AttackType = "Circle",
			AttackSize = 18, 
		},
		[5] = {
			Damage = 2675,
			AttackSpeed = 4.5,
			Range = 28,
			UpgradePrice = 10900,
		},
		[6] = {
			Damage = 3000,
			AttackSpeed = 4,
			Range = 30,
			UpgradePrice = 12444,
		},
		[7] = {
			Damage = 3305,
			AttackSpeed = 4,
			Range = 32,
			UpgradePrice = 16500,
		},
		[8] = {
			Damage = 3750,
			AttackSpeed = 5,
			Range = 34,
			UpgradePrice = 20000,

			Ability = "Turbo Barrage",
			AttackType = "Circle",
			AttackSize = 20, 

			UnitType = "Hybrid"
		},
		[9] = {
			Damage = 4075,
			AttackSpeed = 4.5,
			Range = 35,
			UpgradePrice = 24000,
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
	idle = "112982144395980",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit