local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Evolved = "Broly"
Unit.Tradable = false
Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Brolio [Rage]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	Passives = {"Legendary Rage", "Legendary Wrath"},
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1800 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 175 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 15 :: number,
	Ability = "Raging jump" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 225,
			AttackSpeed = 6.5,
			Range = 15,
			UpgradePrice = 2450,
		},
		[2] = {
			Damage = 300,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 3350,
		},
		[3] = {
			Damage = 500,
			AttackSpeed = 7,
			Range = 18,
			AttackType = "Circle",
			Ability = "Energy Ball",
			AttackSize = 10,
			UpgradePrice = 4650,
		},
		[4] = {
			Damage = 582,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 5600,
		},
		[5] = {
			Damage = 688,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 6650,
		},
		[6] = {
			Damage = 707,
			AttackSpeed = 6,
			Range = 19,
			AttackType = "Line",
			Ability = "Energy Beam",
			AttackSize = 7,
			UpgradePrice = 7200,
		},
		[7] = {
			Damage = 763,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 9000,
		},
		[8] = {
			Damage = 813,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 10100,
		},
		[9] = {
			Damage = 1040,
			AttackSpeed = 8.5,
			Range = 25,
			AttackType = "Full",
			Ability = "Unstable barrage",
			UpgradePrice = 15500,
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
	idle = "121684041207619",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit