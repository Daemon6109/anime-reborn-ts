local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Piccolo Orange"
Unit.Tradable = true
Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Pikkora Yellow [Full Power]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"PurePower", "Shared Misery"},
	Damage = 232 :: number,
	AttackSpeed = 7 :: number,
	Range = 17 :: number,
	Ability = "Rock Slam" :: string, -- starting ability
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
			Damage = 294,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 382,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 3200,
		},
		[3] = {
			Damage = 456,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 4100,
		},
		[4] = {
			Damage = 575,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 5000,
		},
		[5] = {
			Damage = 669,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 5600,
			AttackType = "Line",
			Ability = "Special Energy Cannon",
			AttackSize = 10,
		},
		[6] = {
			Damage = 763,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 6700,
		},
		[7] = {
			Damage = 919,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 8000,
		},
		[8] = {
			Damage = 1032,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 9350,
		},
		[9] = {
			Damage = 1270,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 11500,
			AttackType = "Full",
			Ability = "Gigantification",
			AttackSize = 14,
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
	idle = "102343566290153",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit