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
	DisplayName = "Kele" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Wild Momentum I"},
	Damage = 600 :: number,
	AttackSpeed = 6 :: number,
	Range = 23 :: number,
	Ability = "Destructive Cannon" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 13 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 950,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 1350,
		},
		[2] = {
			Damage = 1350,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 1850,
		},
		[3] = {
			Damage = 1700,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2500,
		},
		[4] = {
			Damage = 2150,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 3320,
		},
		[5] = {
			Damage = 2300,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 4020,
			
			Ability = "Ravaging Orbs",
			AttackType = "Circle",
			AttackSize = 15,
		},
		[6] = {
			Damage = 2650,
			AttackSpeed = 5,
			Range = 28,
			UpgradePrice = 6100,
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
	idle = "115600568891875",
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