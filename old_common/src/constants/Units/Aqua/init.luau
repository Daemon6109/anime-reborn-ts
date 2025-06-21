local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Water Goddess" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 45 :: number,
	AttackSpeed = 7 :: number,
	Range = 15 :: number,
	Ability = "Sacred Create Water" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 60,
			AttackSpeed = 7,
			Range = 15,
			UpgradePrice = 830,
		},
		[2] = {
			Damage = 75,
			AttackSpeed = 7,
			Range = 15,
			UpgradePrice = 1000,
		},
		[3] = {
			Damage = 95,
			AttackSpeed = 8,
			Range = 15,
			UpgradePrice = 1350,
		},
		[4] = {
			Damage = 115,
			AttackSpeed = 7,
			Range = 15,
			SpecialAbility = "Goddesses Grace: Might",
			UpgradePrice = 1750,
		},
		[5] = {
			Damage = 140,
			AttackSpeed = 6.5,
			Range = 15,
			AttackSize = 15,
			UpgradePrice = 2400,
		},
		[6] = {
			Damage = 150,
			AttackSpeed = 6,
			Range = 15,
			UpgradePrice = 3000,
		},
		[7] = {
			Damage = 185,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 4350,
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
	idle = "17893593497",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit