local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Beerus"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Beruus [Destruction]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"God Of Destruction", "God's Presence"},
	Damage = 693.75 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 18 :: number,
	Ability = "Continous Ki Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "Fear", --effects that applies on the enemy when attacked
	AttackEffectDuration = 9999999,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 862.5,
			AttackSpeed = 7.5,
			Range = 20,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1000,
			AttackSpeed = 7.5,
			Range = 23,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 1212.5,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 1468.75,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 6700,
		},
		[5] = {
			Damage = 1750,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 8000,

			AttackType = "Line",
			Ability = "Cataclysmic Orbs",
			AttackSize = 10,
		},
		[6] = {
			Damage = 2112.5,
			AttackSpeed = 6.5,
			Range = 30,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 2500,
			AttackSpeed = 6.5,
			Range = 31,
			UpgradePrice = 10420,
		},
		[8] = {
			Damage = 3000,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 11500,
		},
		[9] = {
			Damage = 3750,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 12800,
			
			UnitType = "Hybrid",
			
			AttackType = "Circle",
			Ability = "Sphere of Destruction",
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
	idle = "83304444773538",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit