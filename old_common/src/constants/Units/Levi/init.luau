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
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Vevi" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1150 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Giant Slayer"},
	Damage = 1100 :: number,
	AttackSpeed = 8 :: number,
	Range = 32 :: number,
	Ability = "Fatal Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 16 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1450,
			AttackSpeed = 8,
			Range = 32,
			UpgradePrice = 1450,
		},
		[2] = {
			Damage = 2050,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 1850,
		},
		[3] = {
			Damage = 2700,
			AttackSpeed = 7.5,
			Range = 34,
			UpgradePrice = 2650,
		},
		[4] = {
			Damage = 2800,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 4580,
		},
		[5] = {
			Damage = 3450,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 5850,
		},
		[6] = {
			Damage = 4000,
			AttackSpeed = 7,
			Range = 36,
			UpgradePrice = 6500,
		},
		[7] = {
			Damage = 4150,
			AttackSpeed = 6.5,
			Range = 38,
			UpgradePrice = 8500,
			
			Ability = "Relentless Slashes",
			AttackType = "Circle" :: Enums.AttackTypes,
			AttackSize = 26 :: Enums.AttackSizeTypes,
		},
		[8] = {
			Damage = 4300,
			AttackSpeed = 6,
			Range = 41,
			UpgradePrice = 13000,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Shiny"),
}

Unit.animations = {
	idle = "114143458409018",
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