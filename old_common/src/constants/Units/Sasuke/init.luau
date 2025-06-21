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
	MaxPlacementAmount = 6 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Susake" :: string,
	Rarity = "Rare" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 600 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Rivals"},
	Damage = 20 :: number,
	AttackSpeed = 4 :: number,
	Range = 15 :: number,
	Ability = "Kunai" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Single" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Stun", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackEffectDamageMultiplier = 1,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 25,
			AttackSpeed = 4,
			Range = 15,
			UpgradePrice = 750,
		},
		[2] = {
			Damage = 30,
			AttackSpeed = 4,
			Range = 17,
			UpgradePrice = 1000,
		},
		[3] = {
			Damage = 35,
			AttackSpeed = 4,
			Range = 20,
			UpgradePrice = 1350,
		},
		[4] = {
			Damage = 40,
			AttackSpeed = 4,
			Range = 22,
			UpgradePrice = 1500,
		},
		[5] = {
			AttackEffect = "Burning",	
			AttackEffectDuration = 6,
			AttackType = "Cone",
			AttackSize = 15,
			Ability = "Fire Jutsu",
			Damage = 45,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 2100,
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
	idle = "95385046185816",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit