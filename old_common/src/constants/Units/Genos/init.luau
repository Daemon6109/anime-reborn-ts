local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-1.15, .4, -1.3)*CFrame.Angles(0,math.rad(225),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Jonas" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 825 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Scorching Engine"},
	Damage = 90 :: number,
	AttackSpeed = 7 :: number,
	Range = 13 :: number,
	Ability = "Fireball" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 1 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 100,
			AttackSpeed = 7,
			Range = 14,
			UpgradePrice = 1150,
		},
		[2] = {
			Damage = 110,
			AttackSpeed = 7,
			Range = 15,
			UpgradePrice = 1745,
		},
		[3] = {
			Damage = 125,
			AttackSpeed = 7,
			Range = 16,
			UpgradePrice = 2150,
			Ability = "Incinerate" :: string, 
			AttackType = "Line" :: Enums.AttackTypes,
		},
		[4] = {
			Damage = 160,
			AttackSpeed = 7,
			Range = 17.5,
			UpgradePrice = 3150,
		},
		[5] = {
			Damage = 220,
			AttackSpeed = 6.5,
			Range = 16,
			UpgradePrice = 4500,
			Ability = "Jet Drive Arrow" :: string, 
			AttackType = "Circle" :: Enums.AttackTypes,
		},
		[6] = {
			Damage = 280,
			AttackSpeed = 6.5,
			Range = 19.5,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 320,
			AttackSpeed = 6.5,
			Range = 20.5,
			UpgradePrice = 7500,
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
	idle = "115901211490689",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit