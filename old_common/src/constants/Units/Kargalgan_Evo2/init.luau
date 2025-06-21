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
	DisplayName = "Tusk [General]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Hymn of Fate"},
	Damage = 655 :: number,
	AttackSpeed = 11 :: number,
	Range = 20 :: number,
	Ability = "Chant of Blazing Fire" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 687.5, -- 625 * 1.10
			AttackSpeed = 11,
			Range = 20,
			UpgradePrice = 1650,
		},
		[2] = {
			Damage = 1375, -- 1250 * 1.10
			AttackSpeed = 11,
			Range = 20,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 1718.75, -- 1562.5 * 1.10
			AttackSpeed = 11,
			Range = 22,
			UpgradePrice = 3650,
		},
		[4] = {
			Damage = 2062.5, -- 1875 * 1.10
			AttackSpeed = 11,
			Range = 23,
			UpgradePrice = 4500,
			AttackType = "Full",
			AttackSize = 15,
			Ability = "Chant of Giants",
		},
		[5] = {
			Damage = 2750, -- 2500 * 1.10
			AttackSpeed = 10.5,
			Range = 25,
			UpgradePrice = 6000,
		},
		[6] = {
			Damage = 3162.5, -- 2875 * 1.10
			AttackSpeed = 10.5,
			Range = 30,
			UpgradePrice = 7500,
		},
		[7] = {
			Damage = 3437.5, -- 3125 * 1.10
			AttackSpeed = 10.5,
			Range = 32,
			UpgradePrice = 9000,
		},
		[8] = {
			Damage = 3643.75, -- 3312.5 * 1.10
			AttackSpeed = 10,
			Range = 34,
			UpgradePrice = 10500,
		},
		[9] = {
			Damage = 4125, -- 3750 * 1.10
			AttackSpeed = 9,
			Range = 35,
			UpgradePrice = 12200,

		},
		[10] = {
			Damage = 4400, -- 4000 * 1.10
			AttackSpeed = 7,
			Range = 41,
			UpgradePrice = 13500,
			AttackType = "Line",
			AttackSize = 25,
			Ability = "Chant of the Fire Dragon",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
	}
	--============================--
}
Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "98147474589165",
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