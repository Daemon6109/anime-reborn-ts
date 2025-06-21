local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "MrMantisShrimp"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Mr. Shrimpy" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Shrimp Boxing II"},
	Damage = 618.75 :: number,
	AttackSpeed = 6 :: number,
	Range = 18 :: number,
	Ability = "Flashy Fist" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 6,
			Range = 19.5,
			UpgradePrice = 2600,
		},
		[2] = {
			Damage = 1025,
			AttackSpeed = 6,
			Range = 21.5,
			UpgradePrice = 4000,
		},
		[3] = {
			Damage = 1337.5,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 5850,
		},
		[4] = {
			Damage = 1793.75,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 6700,

			Ability = "Jet Punch",
			AttackType = "Circle",
			AttackSize = 15, 
		},
		[5] = {
			Damage = 2187.5,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 8145,
		},
		[6] = {
			Damage = 2500,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 9888,
		},
		[7] = {
			Damage = 2875,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 11140,
		},
		[8] = {
			Damage = 3145,
			AttackSpeed = 4.5,
			Range = 29,
			UpgradePrice = 13450,

			Ability = "Salary Uppercut",
			AttackType = "Circle",
			AttackSize = 16.5, 
		},
		[9] = {
			Damage = 3465,
			AttackSpeed = 4.5,
			Range = 29,
			UpgradePrice = 15200,
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
	idle = "75275715420023",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit