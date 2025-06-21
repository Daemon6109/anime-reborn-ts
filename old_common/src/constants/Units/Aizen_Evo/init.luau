local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Aizen"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Aizon [Butterfly]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2100 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Two Steps Ahead"},
	Damage = 743.75 :: number,
	AttackSpeed = 6 :: number,
	Range = 18 :: number,
	Ability = "Soul Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 13 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 893.75,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 3500,
		},
		[2] = {
			Damage = 1125,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 4200,
		},
		[3] = {
			Damage = 1325,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 5350,
		},
		[4] = {
			Damage = 1556.25,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 6800,
			
			AttackType = "Circle",
			Ability = "Hado #90",
			AttackSize = 10,
		},
		[5] = {
			Damage = 1968.75,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 2250,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 2637.5,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 10888,
		},
		[8] = {
			Damage = 3343.75,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 12222,
			
			UnitType = "Hybrid",
			
			AttackType = "Full",
			Ability = "Spiritual Pressure",
			AttackSize = 18,
		}, --Breakdown Sphere
		[9] = {
			Damage = 4070,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 17600,

			SpecialAbility = "Breakdown Sphere"
		}, --Breakdown Sphere
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "115626504370471",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit