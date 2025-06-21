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
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Woogy" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Bara Bara Barrage"},
	Damage = 1000 :: number,
	AttackSpeed = 8 :: number,
	Range = 20 :: number,
	Ability = "Spin Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "Scar", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1500,
			AttackSpeed = 7.5,
			Range = 20,
			UpgradePrice = 1140,
		},
		[2] = {
			Damage = 1980,
			AttackSpeed = 7.5,
			Range = 22,
			UpgradePrice = 1850,
		},
		[3] = {
			Damage = 2640,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 2650,
		},
		[4] = {
			Damage = 2750,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 4580,
			
			Ability = "Spin Barrage",
			AttackType = "Circle",
			AttackSize = 18,
		},
		[5] = {
			Damage = 3350,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 5600,
		},
		[6] = {
			Damage = 3700,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 6500,
		},
		[7] = {
			Damage = 4000,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 8000,
		},
		[8] = {
			Damage = 4500,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 12650,
			
			Ability = "Missile Blast",
			AttackType = "Line",
			AttackSize = 18,
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
	idle = "119598471628661",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit