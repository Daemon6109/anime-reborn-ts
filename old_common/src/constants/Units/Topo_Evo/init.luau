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
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Koko" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1870 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Fierce Enforcement", "Fierce Strategy"},
	Damage = 1000 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 26 :: number,
	Ability = "Justice Strike" :: string, -- starting ability
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
			Damage = 1250,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 2475,
		},
		[2] = {
			Damage = 1400,
			AttackSpeed = 6.5,
			Range = 30,
			UpgradePrice = 2880,
		},
		[3] = {
			Damage = 1830,
			AttackSpeed = 6,
			Range = 31,
			UpgradePrice = 3490,
		},
		[4] = {
			Damage = 2400,
			AttackSpeed = 6,
			Range = 32,
			UpgradePrice = 3545,
		},
		[5] = {
			Damage = 2650,
			AttackSpeed = 6,
			Range = 32,
			UpgradePrice = 5275,
		},
		[6] = {
			Damage = 3000,
			AttackSpeed = 5.5,
			Range = 34,
			UpgradePrice = 6480,
			
			Ability = "Justice Beam",
			AttackType = "Line",
			AttackSize = 12,
		},
		[7] = {
			Damage = 3400,
			AttackSpeed = 5.5,
			Range = 34,
			UpgradePrice = 7225,
		},
		[8] = {
			Damage = 3850,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 8470,
			
			Ability = "Justice Reborn",
			AttackType = "Circle",
			AttackSize = 15,
		},
		[9] = {
			Damage = 4400,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 11750,
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
	idle = "114108575638076",
	EvoIdle = "111457696065004",
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