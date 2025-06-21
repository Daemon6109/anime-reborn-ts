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
	MaxUpgrades = 3 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Orihime" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 600 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 250 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Energy Barrier" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 1000,
		},
		[2] = {
			Damage = 750,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 1500,
		},
		[3] = {
			Damage = 1000,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 1850,
		},
		[4] = {
			Damage = 1350,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 2500,
			AttackType = "Circle",
			Ability = "Energy Burst",
			AttackSize = 19,
		},
		[5] = {
			Damage = 1650,
			AttackSpeed = 6.5,
			Range = 27,
			UpgradePrice = 3150,
		},
		[6] = {
			Damage = 2000,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 3780,
		},
		[7] = {
			Damage = 2500,
			AttackSpeed = 5,
			Range = 28,
			UpgradePrice = 4500,
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
	idle = "89766854637909",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit