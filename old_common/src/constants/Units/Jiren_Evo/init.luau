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
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Biren [Unleashed]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Inner Tactics", "Pure Progress"},
	Damage = 680 :: number,
	AttackSpeed = 6 :: number,
	Range = 23 :: number,
	Ability = "Justice Blast" :: string, -- starting ability
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
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2790,
		},
		[2] = {
			Damage = 1370,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 3360,
		},
		[3] = {
			Damage = 1400,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 4200,
		},
		[4] = {
			Damage = 1650,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 5360,
		},
		[5] = {
			Damage = 1750,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 6200,
		},
		[6] = {
			Damage = 2000,
			AttackSpeed = 5,
			Range = 30,
			UpgradePrice = 7000,
			
			Ability = "Justice Barrage",
			AttackType = "Circle",
			AttackSize = 15,
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[7] = {
			Damage = 2650,
			AttackSpeed = 5,
			Range = 31,
			UpgradePrice = 8200,
		},
		[8] = {
			Damage = 3400,
			AttackSpeed = 5,
			Range = 31,
			UpgradePrice = 9800,
			
			Ability = "Justice Explosion",
			AttackType = "Full",
			AttackSize = 31,
		},
		[9] = {
			Damage = 4300,
			AttackSpeed = 4.5,
			Range = 32,
			UpgradePrice = 11200,
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
	idle = "133039843609864",
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