local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.2, .4, -1.3)*CFrame.Angles(0,math.rad(-180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 4 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Captain Koru" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 650 :: number,
	AttackSpeed = 8 :: number,
	Range = 28 :: number,
	Ability = "Violent Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--

	UpgradesInfo = {
		[1] = {
			Damage = 1608,
			AttackSpeed = 7.5,
			Range = 30,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 2150,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 2350,
		},
		[3] = {
			Damage = 2900,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 3500,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 3400,
		},
		[5] = {
			Damage = 4000,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 4580,
		},
		[6] = {
			Damage = 4300,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 5000,
		},
		[7] = {
			Damage = 4850,
			AttackSpeed = 6.5,
			Range = 38,
			UpgradePrice = 6000,
			Ability = "Brutal Strike",
			AttackType = "Circle",
			AttackSize = 25,
		},
		[8] = {
			Damage = 5000,
			AttackSpeed = 6.5,
			Range = 42,
			UpgradePrice = 8000,
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
	idle = "83496529191125",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit