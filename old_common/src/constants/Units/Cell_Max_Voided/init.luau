local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Uell [Max]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Natural Evolution", "Absolute Perfection"},
	Damage = 600 :: number,
	AttackSpeed = 5.5 :: number,
	Range = 30 :: number,
	Ability = "Quake of Provocation" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 800,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 1000,
		},
		[2] = {
			Damage = 1300,
			AttackSpeed = 5.5,
			Range = 31,
			UpgradePrice = 1350,
		},
		[3] = {
			Damage = 1600,
			AttackSpeed = 5,
			Range = 31,
			UpgradePrice = 2000,
		},
		[4] = {
			Damage = 1850,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 2500,
		},
		[5] = {
			Damage = 2200,
			AttackSpeed = 5,
			Range = 33,
			UpgradePrice = 3500,
		},
		[6] = {
			Damage = 2500,
			AttackSpeed = 4.5,
			Range = 34,
			UpgradePrice = 4300,
		},
		[7] = {
			Damage = 2700,
			AttackSpeed = 4.5,
			Range = 34,
			UpgradePrice = 6200,
		},
		[8] = {
			Damage = 3200,
			AttackSpeed = 4.5,
			Range = 35,
			UpgradePrice = 9500,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "18302081944",
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