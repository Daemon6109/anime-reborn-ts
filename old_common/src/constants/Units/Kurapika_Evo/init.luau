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
	DisplayName = "Goora [Chained]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1450 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Scarlet Retribution", "Chain Prison"},
	Damage = 1000 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "Chain Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 2,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1500,
			AttackSpeed = 7,
			Range = 19,
			UpgradePrice = 1810,
		},
		[2] = {
			Damage = 2000,
			AttackSpeed = 6.5,
			Range = 21,
			UpgradePrice = 2260,
		},
		[3] = {
			Damage = 2250,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2830,
		},
		[4] = {
			Damage = 2500,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 3530,
			
			AttackType = "Cone",
			AttackSize = 25,
			Ability = "Chain Slam",
		},
		[5] = {
			Damage = 2800,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 4410,
		},
		[6] = {
			Damage = 3350,
			AttackSpeed = 5.5,
			Range = 27,
			AttackSize = 27,
			UpgradePrice = 5510,
		},
		[7] = {
			Damage = 3760,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 6880,
			
			AttackType = "Cone",
			AttackSize = 28,
			Ability = "Chain Barrage",
		},
		[8] = {
			Damage = 4150,
			AttackSpeed = 5.5,
			Range = 29,
			AttackSize = 29,
			UpgradePrice = 8590,
			
		},
		[9] = {
			Damage = 4640,
			AttackSpeed = 5,
			Range = 31,
			AttackSize = 31,
			UpgradePrice = 10730,
		},
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "94919223014922",
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