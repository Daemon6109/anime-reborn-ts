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
	DisplayName = "Orechamira" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 805 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 102 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 15 :: number,
	Ability = "Fire Wave" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 140,
			AttackSpeed = 7.5,
			Range = 17,
			UpgradePrice = 1105,
		},
		[2] = {
			Damage = 185,
			AttackSpeed = 7,
			Range = 17,
			UpgradePrice = 1750,
		},
		[3] = {
			Damage = 240,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 2150,
		},
		[4] = {
			Damage = 290,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 3200,
		},
		[5] = {
			Damage = 325,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 4000,
		},
		[6] = {
			Damage = 360,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 4700,
		},
		[7] = {
			Damage = 400,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 5200,
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
	idle = "106444596396341",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit