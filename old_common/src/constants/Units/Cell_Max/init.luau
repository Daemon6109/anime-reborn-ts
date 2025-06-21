local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

--Unit.height = .15
Unit.Radius = 3
Unit.Tradable = true

Unit.configuration = {
	CameraOffset = CFrame.new(-.5,0,.05),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.5, -0.02, -3) * CFrame.Angles(0,math.rad(-160),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Uell [Max]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Natural Evolution", "Absolute Perfection"},
	Damage = 550 :: number,
	AttackSpeed = 10 :: number,
	Range = 15 :: number,
	Ability = "Chou Energy Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["RedBlaster"] = 1,
	--			["BlueBlaster"] = 1,
	--			["RainbowStar"] = 2,
	--			["LightStone"] = 5,				
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};
		
	--	DisplayBuffs = {
	--		"+20% Damage";
	--		"+1 New Special Move: Core Breaker";
	--		"+1 New Passive: Delta Two";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Gamma Brothers [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 630,
			AttackSpeed = 9,
			Range = 15,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 730,
			AttackSpeed = 9,
			Range = 18,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 930,
			AttackSpeed = 8,
			Range = 20,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 1050,
			AttackSpeed = 8,
			Range = 20,
			UpgradePrice = 5000,
		
		},
		[5] = {
			Damage = 1300,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 5750,
			UnitType = "Hybrid",
			Ability = "Disaster Ray",
			AttackSize = 15,
			AttackType = "Circle",
		},
		[6] = {
			Damage = 1500,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 6600,
		},
		[7] = {
			Damage = 1740,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 9000,
		},
		[8] = {
			Damage = 1850,
			AttackSpeed = 9,
			Range = 22,
			UpgradePrice = 10200,
			Ability = "MAX Energy Orb",
			AttackSize = 10,
			AttackType = "Line",
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
	idle = "129719213465572",
	walk = "17264216432", 
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit