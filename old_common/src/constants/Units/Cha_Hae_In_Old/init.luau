local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(.65, .15, -1.55)*CFrame.Angles(0,math.rad(-211),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.1, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 8 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "S Rank Knight" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 1500 :: number,
	AttackSpeed = 8 :: number,
	Range = 50 :: number,
	Ability = "Dancing Steps" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			--Damage = 2000,
			--Range = 5,
			--AttackSpeed = 4.5,
			--Ability = "Shadow Clone Rasengan",
			--UnitType = "Hybrid",
			AttackSize = 5,
			AttackType = "Line",
			UpgradePrice = 600,
		},
		[2] = {
			Damage = 5000,
			Range = 100,
			Ability = "Warrior's Resolve",
			--AttackType = "Circle",
			AttackSize = 50,
			AttackType = "Cone",
			UpgradePrice = 900,
		},
		[3] = {
			Damage = 7500,
			UpgradePrice = 1500,
			AttackSpeed = 5,
		},
		[4] = {
			Damage = 11000,
			--Ability = "Fireball Jutsu",
			UpgradePrice = 2200,
		},
		[5] = {
			Damage = 16000,
			UpgradePrice = 3000,
		},
		[6] = {
			Damage = 16000,
			UpgradePrice = 3000,
		},
		[7] = {
			Damage = 16000,
			Ability = "Glorious Sword Dance",
			Range = 75,
			AttackSize = 20,
			UpgradePrice = 3000,
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
	idle = "18145462577",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit