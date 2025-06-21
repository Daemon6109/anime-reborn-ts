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
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yoshina [Evo]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1780 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Ice Blessing", "Gentle Blizzard"},
	Damage = 950 :: number,
	AttackSpeed = 5 :: number,
	Range = 20 :: number,
	Ability = "Ice Tornado" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 12:: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1300,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 2920,
		},
		[2] = {
			Damage = 1600,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 3560,
		},
		[3] = {
			Damage = 2130,
			AttackSpeed = 4.5,
			Range = 23,
			UpgradePrice = 4330,
		},
		[4] = {
			Damage = 2340,
			AttackSpeed = 4.5,
			Range = 25,
			UpgradePrice = 5280,
		},
		[5] = {
			Damage = 2730,
			AttackSpeed = 4.5,
			Range = 26,
			UpgradePrice = 6430,
			Ability = "Ice Barrage",
			AttackType = "Cone",
			AttackSize = 15,
		},
		[6] = {
			Damage = 2900,
			AttackSpeed = 4,
			Range = 30,
			UpgradePrice = 7500,
		},
		[7] = {
			Damage = 3300,
			AttackSpeed = 4,
			Range = 32,
			UpgradePrice = 8250,
			
			Ability = "Ice Spikes",
			AttackType = "Cone",
			AttackSize = 17,
		},
		[8] = {
			Damage = 3750,
			AttackSpeed = 4,
			Range = 36,
			UpgradePrice = 9375,
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
	idle = "127524251906511",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit