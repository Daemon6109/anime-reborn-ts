local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	CameraOffset = CFrame.new(0,-0.4,0.2),
	Viewport = CFrame.new(-0.1, 0, -1.7)*CFrame.Angles(0,math.rad(-170),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Boulder Lee" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 850 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Fighting Spirit"},
	Damage = 70 :: number,
	AttackSpeed = 4 :: number,
	Range = 13 :: number,
	Ability = "Whirlwind Leap" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 85,
			AttackSpeed = 4,
			Range = 15,
			UpgradePrice = 1000,
		},
		[2] = {
			Damage = 100,
			AttackSpeed = 3.5,
			Range = 16,
			UpgradePrice = 1800,
		},
		[3] = {
			Damage = 115,
			AttackSpeed = 3.5,
			Range = 18,
			UpgradePrice = 2200,
		},
		[4] = {
			Damage = 140,
			AttackSpeed = 4,
			Range = 20,
			UpgradePrice = 2800,
			AttackType = "Line",
			AttackSize = 7,
			Ability = "Leaf Hurricane",
		},
		[5] = {
			Damage = 170,
			AttackSpeed = 4,
			Range = 21,
			UpgradePrice = 3600,
		},
		[6] = {
			Damage = 200,
			AttackSpeed = 4,
			Range = 22,
			UpgradePrice = 5400,
		},
		[7] = {
			Damage = 235,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 7300,
			AttackType = "Full",
			Ability = "Leaf Typhoon",
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
	idle = "127379267343406",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit