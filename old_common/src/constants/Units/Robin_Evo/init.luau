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
	DisplayName = "Roben [Demon]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1050 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Cien Fleur Bind", "Submission Lock"},
	Damage = 1000 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Flower Fall" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 1.5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1500,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1980,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 3200,
		},
		[3] = {
			Damage = 2640,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 4300,
		},
		[4] = {
			Damage = 2750,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5660,
		},
		[5] = {
			Damage = 3860,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 6590,
			Ability = "Crushing Fall",
			AttackType = "Circle",
			AttackSize = 18,
		},
		[6] = {
			Damage = 4350,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 9360,
		},
		[7] = {
			Damage = 4700,
			AttackSpeed = 6,
			Range = 34,
			UpgradePrice = 13300,
			
			Ability = "Ground Breaker",
			AttackType = "Circle",
			AttackSize = 26,
		},
		[8] = {
			Damage = 5120,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 17000,
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
	idle = "96744903996219",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit