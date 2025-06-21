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
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Teitan [Blaze]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Rising Sun", "Solar Inferno"},
	Damage = 600 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Fatal Cut" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1200,
			AttackSpeed = 7.5,
			Range = 30,
			UpgradePrice = 2280,
		},
		[2] = {
			Damage = 1650,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 2890,
		},
		[3] = {
			Damage = 1750,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 3660,
		},
		[4] = {
			Damage = 2000,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 4630,
		},
		[5] = {
			Damage = 3000,
			AttackSpeed = 6.5,
			Range = 37,
			UpgradePrice = 5870,
			Ability = "Blazing Slice",
			AttackType = "Circle", 
			AttackSize = 16,     
		},
		[6] = {
			Damage = 3300,
			AttackSpeed = 6.5,
			Range = 38,
			UpgradePrice = 7430,
		},
		[7] = {
			Damage = 3600,
			AttackSpeed = 7,
			Range = 40,
			UpgradePrice = 9420,
			Ability = "Rising Sun",
			AttackType = "Full", 
			AttackSize = 40,      
		},
		[8] = {
			Damage = 4500,
			AttackSpeed = 7,
			Range = 40,
			UpgradePrice = 11920,
		},
		[9] = {
			Damage = 5500,
			AttackSpeed = 7,
			Range = 42,
			AttackSize = 42,     
			UpgradePrice = 13000,
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
	idle = "139686430956563",
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