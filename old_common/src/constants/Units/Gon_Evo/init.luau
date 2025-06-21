local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Bon [Darkness]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Reckless Courage", "Jajanken Mastery", "Ultimate Resolve"},
	Damage = 900 :: number,
	AttackSpeed = 8 :: number,
	Range = 20 :: number,
	Ability = "Jajaken Rock" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1140,
			AttackSpeed = 7.5,
			Range = 22,
			UpgradePrice = 2210,
		},
		[2] = {
			Damage = 1500,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 2870,
		},
		[3] = {
			Damage = 1650,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 3720,
		},
		[4] = {
			Damage = 1900,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 4840,
			
			Ability = "Jajaken Paper",
			AttackType = "Circle",
			AttackSize = 16, 

			UnitType = "Hybrid"
		},
		[5] = {
			Damage = 2000,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 6280,
		},
		[6] = {
			Damage = 2450,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 8160,
		},
		[7] = {
			Damage = 2700,
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 10590,
			

			Ability = "Stone Flip",
			AttackType = "Circle",
			AttackSize = 20,
		},
		[8] = {
			Damage = 3500,
			AttackSpeed = 5,
			Range = 42,
			UpgradePrice = 13760,
		},
		
		[9] = {
			Damage = 5500,
			AttackSpeed = 5,
			Range = 42,
			UpgradePrice = 16500,
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
	idle = "124432889455195",
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