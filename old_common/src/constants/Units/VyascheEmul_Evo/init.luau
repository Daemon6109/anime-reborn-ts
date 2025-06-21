local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "VzazcheEnul [Fierce]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Celestial Beacon", "Lunar Veil"},
	Damage = 1000 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Magic Edge" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1500,
			AttackSpeed = 7.5,
			Range = 33,
			UpgradePrice = 2210,
		},
		[2] = {
			Damage = 1980,
			AttackSpeed = 7.5,
			Range = 34,
			UpgradePrice = 2870,
		},
		[3] = {
			Damage = 2640,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 3720,
		},
		[4] = {
			Damage = 2750,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 4840,
		},
		[5] = {
			Damage = 3860,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 6280,
			Ability = "Bunny Refinement",
			AttackType = "Circle",
			AttackSize = 24,
		},
		[6] = {
			Damage = 4350,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 10000,
		},
		[7] = {
			Damage = 4700,
			AttackSpeed = 6.5,
			Range = 37,
			UpgradePrice = 12500,
			
			Ability = "Hammer Impact",
			AttackType = "Circle",
			AttackSize = 28,
		},
		[8] = {
			Damage = 5850,
			AttackSpeed = 6.5,
			Range = 42,
			UpgradePrice = 15000,
		},
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "121870689982011",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit