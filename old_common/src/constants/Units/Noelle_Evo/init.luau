local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Noelle"
Unit.Tradable = false
Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Noille [Awakened]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1100 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Royal Family", "TsunamiSummon"},
	Damage = 200 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Water Current" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 25 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 250,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 1800,
		},
		[2] = {
			Damage = 275,
			AttackSpeed = 6.5,
			Range = 24,
			UpgradePrice = 2300,
		},
		[3] = {
			Damage = 438,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2800,
		},
		[4] = {
			Damage = 513,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 3500,

			Ability = "Water Smash",
			AttackType = "Circle",
			AttackSize = 10,
		},
		[5] = {
			Damage = 594,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 4450,
		},
		[6] = {
			Damage = 657,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 5000,
		},
		[7] = {
			Damage = 794,
			AttackSpeed = 8,
			Range = 32,
			UpgradePrice = 5700,
			
			Ability = "Water Barrage",
			AttackType = "Circle",
			AttackSize = 12,
		},
		[8] = {
			Damage = 850,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 7000,
		},
		[9] = {
			Damage = 1250,
			AttackSpeed = 6.5,
			Range = 33,
			UpgradePrice = 8200,
			
			Ability = "Water Dragon",
			AttackType = "Line",
			AttackSize = 10,
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
	idle = "119476935664752",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit