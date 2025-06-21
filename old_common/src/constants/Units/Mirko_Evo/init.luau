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
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Birko [Evo]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1300 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Critical Claw", "Critical Tempo"},
	Damage = 1000 :: number,
	AttackSpeed = 7 :: number,
	Range = 25 :: number,
	Ability = "Luna Spin" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 16 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1680,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 2650,
		},
		[2] = {
			Damage = 2230,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 3840,
		},
		[3] = {
			Damage = 2650,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 4660,
		},
		[4] = {
			Damage = 3120,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 6120,
		},
		[5] = {
			Damage = 3480,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 6590,
			Ability = "Luna Kick",
			AttackType = "Circle",
			AttackSize = 18,
		},
		[6] = {
			Damage = 3880,
			AttackSpeed = 6,
			Range = 32,
			UpgradePrice = 7260,
		},
		[7] = {
			Damage = 4350,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 8060,
			
			Ability = "Luna Fall",
			AttackType = "Circle",
			AttackSize = 24,
		},
		[8] = {
			Damage = 4700,
			AttackSpeed = 5.5,
			Range = 38,
			UpgradePrice = 12350,
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
	idle = "90387247750986",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit