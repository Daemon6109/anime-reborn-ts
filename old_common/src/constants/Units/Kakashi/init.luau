local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(.12, .65, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.2, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Sensei" :: string,
	Rarity = "Epic" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Hitman"},
	Damage = 45 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Kunai Jab" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 60,
			Range = 17,
			--AttackSpeed = 4.5,
			--Ability = "Shadow Clone Rasengan",
			--UnitType = "Hybrid",
			AttackSize = 6,
			UpgradePrice = 850,
			AttackSpeed = 6,
		},
		[2] = {
			Damage = 85,
			AttackType = "Line",
			Ability = "Lightning Blade",
			UpgradePrice = 1000,
			Range = 17,
			AttackSpeed = 6,
		},
		[3] = {
			Damage = 100,
			Range = 20,
			UpgradePrice = 1250,
			AttackSpeed = 6,
		},
		[4] = {
			Damage = 100,
			Range = 25,
			AttackType = "Circle",
			Ability = "Fireball Jutsu",
			UpgradePrice = 1300,
			AttackSpeed = 6,
		},
		[5] = {
			Damage = 125,
			Range = 25,
			UpgradePrice = 1850,
			AttackSpeed = 4,
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
	idle = "17893593497",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit