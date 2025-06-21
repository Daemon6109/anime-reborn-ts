local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Grook" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Soul Echoes", "Maestro of the Macabre"},
	Damage = 1100 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Frostbite Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
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
			Ability = "Expected Mortal Slash",
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
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "114490382465714",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit