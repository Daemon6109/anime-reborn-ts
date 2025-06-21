local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Pain"
Unit.Tradable = false
Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Payne [Chibaku]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Gravity Force II"},
	Damage = 200 :: number,
	AttackSpeed = 9 :: number,
	Range = 18 :: number,
	Ability = "Rockets" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "",
	AttackEffectDuration = 6,
	AttackEffectDurationFromPassive = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 250,
			AttackSpeed = 9,
			Range = 20,
			UpgradePrice = 2300,
		},
		[2] = {
			Damage = 300,
			AttackSpeed = 8.5,
			Range = 22,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 360,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 425,
			AttackSpeed = 8,
			Range = 23,
			UpgradePrice = 4700,
		},
		[5] = {
			Damage = 500,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 5750,
		},
		[6] = {
			Damage = 600,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 7500,
			AttackType = "Full",
			Ability = "Shinra Tensei",
		},
		[7] = {
			Damage = 700,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 9200,
		},
		[8] = {
			Damage = 800,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 9700,
		},
		[9] = {
			Damage = 1080,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 13300,
			AttackEffect = "Burning",
			Ability = "Chibaku Tensei",
			AttackType = "Circle",
			AttackSize = 15,
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
	idle = "105237950545381",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit