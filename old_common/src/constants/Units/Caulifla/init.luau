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
	MaxPlacementAmount = 1 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 1 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Kaulfa" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Fast Reflexes I"},
	Damage = 500 :: number,
	AttackSpeed = 6 :: number,
	Range = 22 :: number,
	Ability = "Ravaging Cannon" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 850,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 1540,
		},
		[2] = {
			Damage = 1250,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2030,
		},
		[3] = {
			Damage = 1500,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 2700,
		},
		[4] = {
			Damage = 2000,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 3500,
		},
		[5] = {
			Damage = 2000,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 4200,
			
			Ability = "Destructive Orbs",
			AttackType = "Circle",
			AttackSize = 17,
		},
		[6] = {
			Damage = 2500,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 5150,
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
	idle = "129142329827210",
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