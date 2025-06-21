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
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Ant King [Marshal]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1780 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Heavy Hits", "Predator's Hunch"},
	Damage = 1050.5 :: number,
	AttackSpeed = 11 :: number,
	Range = 28 :: number,
	Ability = "Revengeful Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Poison", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1375.5, -- +10%
			AttackSpeed = 11,
			Range = 28,
			UpgradePrice = 3500,
		},
		[2] = {
			Damage = 1781.25, -- +10%
			AttackSpeed = 10.5,
			Range = 29,
			UpgradePrice = 5000,
		},
		[3] = {
			Damage = 2312.5, -- +10%
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 6000,
			Ability = "Toxin Spit",
			AttackType = "Line",
			AttackSize = 20,
		},
		[4] = {
			Damage = 2850, -- +10%
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 6500,
		},
		[5] = {
			Damage = 3337.5, -- +10%
			AttackSpeed = 6.5,
			Range = 33,
			UpgradePrice = 7500,
		},
		[6] = {
			Damage = 3750, -- +10%
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 9500,
			Ability = "Impalation",
			AttackType = "Circle",
			AttackSize = 16
		},
		[7] = {
			Damage = 4000, -- +10%
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 10000,
		},
		[8] = {
			Damage = 4375, -- +10%
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 11000,
		},
		[9] = {
			Damage = 4400, -- +10%
			AttackSpeed = 4.5,
			Range = 40,
			UpgradePrice = 13500,
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
	idle = "109103009156297",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit