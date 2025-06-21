local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Droid 18" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Finishing Blow"},
	Damage = 70 :: number,
	AttackSpeed = 5 :: number,
	Range = 20 :: number,
	Ability = "Energy Release Wave" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 85,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 1100,
		},
		[2] = {
			Damage = 105,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 1750,
		},
		[3] = {
			Damage = 140,
			AttackSpeed = 4,
			Range = 25,
			UpgradePrice = 2350,
		},
		[4] = {
			Ability = "Energy Blast",
			AttackType = "Circle",
			AttackSize = 9,
			Damage = 190,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2600,
		},
		[5] = {
			Damage = 230,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 3100,
		},
		[6] = {
			Damage = 280,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 4200,
		},
		[7] = {
			Damage = 325,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 5100,
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
	idle = "134468281047458",
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