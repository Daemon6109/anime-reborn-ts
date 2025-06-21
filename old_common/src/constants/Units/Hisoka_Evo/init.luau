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
	DisplayName = "Misoka [Bungee]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Sadistic Amusement", "Bungee Counter"},
	Damage = 700 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 24 :: number,
	Ability = "Card Throw" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1100,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 1140,
		},
		[2] = {
			Damage = 1350,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 1620,
		},
		[3] = {
			Damage = 1600,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 2300,
		},
		[4] = {
			Damage = 1800,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 3260,
			AttackType = "Circle",
			AttackSize = 16,
			Ability = "Card Slice",
		},
		[5] = {
			Damage = 2000,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 4640,
		},
		[6] = {
			Damage = 2350,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 6590,
		},
		[7] = {
			Damage = 2700,
			AttackSpeed = 4.5,
			Range = 32,
			UpgradePrice = 9360,
			AttackType = "Full",
			AttackSize = 14,
			Ability = "Bungee Whip",
		},
		[8] = {
			Damage = 3000,
			AttackSpeed = 4.5,
			Range = 34,
			UpgradePrice = 13300,
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
	idle = "113133337470237",
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