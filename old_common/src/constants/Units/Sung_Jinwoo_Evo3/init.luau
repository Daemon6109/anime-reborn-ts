local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	MaxUpgrades = 11 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Solo Woo [MONARCH]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Arise", "Black Heart", "Monarch's Domain"},
	Damage = 1850 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Shadow Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 300 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = true :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1760, -- 1600 * 1.1
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 2090, -- 1900 * 1.1
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 2750, -- 2500 * 1.1
			AttackSpeed = 6.5,
			Range = 35,
			--UnitType = "Hybrid",
			UpgradePrice = 4850,
		},
		[4] = {
			Damage = 3800, -- 4000 * 1.1
			AttackSpeed = 6,
			Range = 36,
			Ability = "Arise: Korgolgon",
			AttackType = "Circle",
			AttackSize = 20,
			UpgradePrice = 12500,
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 4100, -- 4000 * 1.1
			AttackSpeed = 5.5,
			Range = 37,
			UpgradePrice = 7000,
		},
		[6] = {
			Damage = 4300, -- 4000 * 1.1
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 8900,
			SpecialAbility = "Monarch Destruction" :: string,
		},
		[7] = {
			Damage = 4430, -- 4250 * 1.1
			AttackSpeed = 4.5,
			Range = 40,
			UpgradePrice = 11000,
			Ability = "Arise: Shadow Warrior",
			AttackType = "Circle",
			AttackSize = 25,
		},
		[8] = {
			Damage = 4500, -- 4250 * 1.1
			AttackSpeed = 4,
			Range = 40,
			UpgradePrice = 12700,
		},
		[9] = {
			Damage = 4600, -- 5000 * 1.1
			AttackSpeed = 4,
			Range = 45,
			UpgradePrice = 25000,
			Ability = "Arise: Igros",
			AttackType = "Cone",
			AttackSize = 45,
		},
		[10] = {
			Damage = 4750, -- 5000 * 1.1
			AttackSpeed = 4,
			Range = 45,
			UpgradePrice = 25000,
			Ability = "Vengeance",
			AttackType = "Circle",
			AttackSize = 20,
		},
		[11] = {
			Damage = 5000, -- 5000 * 1.1
			AttackSpeed = 4,
			Range = 45,
			UpgradePrice = 25000,
			Ability = "Rapid Slashes",
			AttackType = "Circle",
			AttackSize = 27.5,
		}
	}

	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "95280874014863",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit