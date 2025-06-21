local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Julius"
Unit.Tradable = false
Unit.ShinyTradable = true
Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Time King [True Power]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 9750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Time Acceleration", "Time Slowdown"},
	Damage = 840 :: number,
	AttackSpeed = 10 :: number,
	Range = 20 :: number,
	Ability = "Time Shot" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = true :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1080,
			AttackSpeed = 10,
			Range = 25,
			UpgradePrice = 4500,
		},
		[2] = {
			Damage = 1260,
			AttackSpeed = 9.5,
			Range = 27,
			UpgradePrice = 5600,
		},
		[3] = {
			Damage = 1350,
			AttackSpeed = 9,
			Range = 29,
			UpgradePrice = 6450,
		},
		[4] = {
			Damage = 2040,
			AttackSpeed = 12.5,
			Range = 32,
			UpgradePrice = 7500,
			
			Ability = "Time Blast",
			AttackType = "Line",
			AttackSize = 10,
		},
		[5] = {
			Damage = 2280,
			AttackSpeed = 11,
			Range = 35,
			UpgradePrice = 9000,
		},
		[6] = {
			Damage = 2460,
			AttackSpeed = 10,
			Range = 38,
			UpgradePrice = 11000,
		},
		[7] = {
			Damage = 4440,
			AttackSpeed = 15,
			Range = 40,
			UpgradePrice = 15000,
			
			Ability = "Time Barrage",
			AttackType = "Cone",
			AttackSize = 35,
			UnitType = "Hybrid",
		},
		[8] = {
			Damage = 5040,
			AttackSpeed = 14,
			Range = 42,
			UpgradePrice = 18000,
			SpecialAbility = "Time Magic: Freeze",
		},
		[9] = {
			Damage = 6100,
			AttackSpeed = 14,
			Range = 45,
			UpgradePrice = 23000,
			
			Ability = "Time Crush",
			AttackType = "Circle",
			AttackSize = 14,
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
	idle = "74170461498457",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit