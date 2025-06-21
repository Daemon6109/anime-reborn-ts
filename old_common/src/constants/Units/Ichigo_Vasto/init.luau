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
	DisplayName = "Ihigo [Vasto]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Duality", "Bestial"},
	Damage = 1562.5 :: number,
	AttackSpeed = 15 :: number,
	Range = 23 :: number,
	Ability = "The Horse" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 13 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 2500,
			AttackSpeed = 14.5,
			Range = 24,
			UpgradePrice = 2650,
		},
		[2] = {
			Damage = 2937.5,
			AttackSpeed = 14,
			Range = 24,
			UpgradePrice = 3500,
			AttackType = "Circle",
			AttackSize = 22,
			Ability = "Devastation Swing",
		},
		[3] = {
			Damage = 3125,
			AttackSpeed = 13.5,
			Range = 26,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 3312.5,
			AttackSpeed = 13.5,
			Range = 26,
			UpgradePrice = 5425,
		},
		[5] = {
			Damage = 3437.5,
			AttackSpeed = 13,
			Range = 27,
			UpgradePrice = 6450,
			
		
		},
		[6] = {
			Damage = 4375,
			AttackSpeed = 11,
			Range = 30,
			UpgradePrice = 7825,
			AttackType = "Line",
			AttackSize = 23,
			Ability = "The King",
		},
		[7] = {
			Damage = 5000,
			AttackSpeed = 10.5,
			Range = 31,
			UpgradePrice = 9480,
		},
		[8] = {
			Damage = 6500,
			AttackSpeed = 10.5,
			Range = 31,
			UpgradePrice = 10760,
			AttackType = "Line",
			AttackSize = 25,
			Ability = "Hollowfied Beam",
		},
		[9] = {
			Damage = 7175,
			AttackSpeed = 8,
			Range = 32,
			UpgradePrice = 11850,
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
	idle = "98730294358705",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit