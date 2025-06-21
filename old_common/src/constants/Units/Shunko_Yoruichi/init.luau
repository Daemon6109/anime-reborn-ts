local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(-180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 8 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yarichii [Thunder]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
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
	Range = 20 :: number,
	Ability = "Shunko Assault" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			AttackSize = 10,
			Damage = 2000,
			Range = 21,
			UpgradePrice = 600,
		},
		[2] = {
			Damage = 5000,
			Range = 22,
			UpgradePrice = 900,
		},
		[3] = {
			Damage = 7500,
			UpgradePrice = 1500,
			AttackSpeed = 12,
			AttackSize = 12,
			AttackType = "Line",
			Ability = "Thunder Palm",
		},
		[4] = {
			Damage = 11000,
			--Ability = "Fireball Jutsu",
			Range = 30,
			UpgradePrice = 2200,
		},
		[5] = {
			Damage = 16000,
			Range = 32,
			UpgradePrice = 3000,
		},
		[6] = {
			Damage = 16000,
			UpgradePrice = 3000,
		},
		[7] = {
			Damage = 16000,
			Ability = "Thunder Bolt",
			Range = 35,
			AttackType = "Circle",
			AttackSize = 15,
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
	idle = "17209457225",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit