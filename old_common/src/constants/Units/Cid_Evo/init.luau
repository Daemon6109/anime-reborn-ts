local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Cid"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Cod [Atomic]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Ego"},
	Damage = 806.25 :: number,
	AttackSpeed = 6 :: number,
	Range = 16 :: number,
	Ability = "Atomic Strike" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1000,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 2255,
		},
		[2] = {
			Damage = 1235,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 1456.25,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 1875,
			AttackSpeed = 5.5,
			Range = 24,
			UpgradePrice = 5500,

			AttackType = "Circle",
			Ability = "Shadow Ambush",
			AttackSize = 18,
		},
		[5] = {
			Damage = 2168.75,
			AttackSpeed = 5.5,
			Range = 24,
			UpgradePrice = 6750,
		},
		[6] = {
			Damage = 2625,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 8800,
		},
		[7] = {
			Damage = 3332.5,
			AttackSpeed = 5,
			Range = 26,
			UpgradePrice = 10000,
		},
		[8] = {
			Damage = 3556.25,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 14500,
		},
		[9] = {
			Damage = 4275,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 25000,

			AttackType = "Full",
			Ability = "Atomic",
			AttackSize = 18,
			
			SpecialAbility = "All Range: Atomic"
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
	idle = "110963979478234",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit