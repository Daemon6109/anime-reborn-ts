local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Hit" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Perfect Timing"},
	Damage = 800 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 27 :: number,
	Ability = "Ki Blast" :: string, -- starting ability
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
			Damage = 1100,
			AttackSpeed = 6.5,
			Range = 27,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1600,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 2800,
		},
		[3] = {
			Damage = 2050,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 3200,
		},
		[4] = {
			Damage = 2400,
			AttackSpeed = 6,
			Range = 29,
			UpgradePrice = 4100,
		},
		[5] = {
			Damage = 2800,
			AttackSpeed = 6,
			Range = 29,
			UpgradePrice = 5320,
			AttackType = "Circle",
			AttackSize = 15,
			Ability = "Time Stomp",
		},
		[6] = {
			Damage = 3120,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 6380,
		},
		[7] = {
			Damage = 3400,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 7000,
		},
		[8] = {
			Damage = 3900,
			AttackSpeed = 5.5,
			Range = 34,
			UpgradePrice = 7800,
			AttackType = "Line",
			AttackSize = 15,
			Ability = "Dynamic Retribution",
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
	idle = "97612056143859",
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