local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Licht"
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
	DisplayName = "Light [Sparkling]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Pure Light", "LightSummon"},
	Damage = 213 :: number,
	AttackSpeed = 5 :: number,
	Range = 19 :: number,
	Ability = "Light Sword" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
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
			Damage = 300,
			AttackSpeed = 4.5,
			Range = 20,
			UpgradePrice = 2050,
		},
		[2] = {
			Damage = 388,
			AttackSpeed = 4.5,
			Range = 23,
			UpgradePrice = 2450,
		},
		[3] = {
			Damage = 500,
			AttackSpeed = 4,
			Range = 23,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 675,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 4250,

			Ability = "Light Sword Barrage",
			AttackType = "Line",
			AttackSize = 10,
		},
		[5] = {
			Damage = 813,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 4750,
		},
		[6] = {
			Damage = 875,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 1250,
			AttackSpeed = 8.5,
			Range = 24,
			UpgradePrice = 7500,

			Ability = "Arrows Of Judgement",
			AttackType = "Full",
			UnitType = "Hybrid",
			AttackSize = 1,
		},
		[8] = {
			Damage = 1813,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 8750,
		},
		[9] = {
			Damage = 2267,
			AttackSpeed = 9,
			Range = 25,
			UpgradePrice = 11000,
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
	idle = "103922394288913",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit