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
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Murutu" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 720 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 72 :: number,
	AttackSpeed = 7 :: number,
	Range = 15 :: number,
	Ability = "WaterWheel" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 90,
			AttackSpeed = 6.5,
			Range = 16,
			UpgradePrice = 100,
		},
		[2] = {
			Damage = 140,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 1160,
		},
		[3] = {
			Damage = 180,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 1500,
		},
		[4] = {
			Damage = 205,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 1900,
			

			AttackType = "Circle",
			Ability = "Waterfall",
			AttackSize = 10,
		},
		[5] = {
			Damage = 250,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 2275,
		},
		[6] = {
			Damage = 275,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2700,
		},
		[7] = {
			Damage = 322,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 3500,
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
	idle = "95775117346176",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit