local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Cat Girl" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 350 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 25 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Radial Explosion" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "Weak Point", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 1001,
		},
		[2] = {
			Damage = 1500,
			AttackSpeed = 6,
			Range = 19,
			UpgradePrice = 2000,
		},
		[3] = {
			Damage = 1650,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 3333,
		},
		[4] = {
			Damage = 1700.5,
			AttackSpeed = 5.5,
			Range = 22,
			UpgradePrice = 5000,
		},
		[5] = {
			Damage = 1800,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 6750,

			Ability = "Sphere of Domination",
			AttackSize = 12,
			AttackType = "Circle",
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
	idle = "134452293324965",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit