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
	MaxPlacementAmount = 5 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Lumi [Divine]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 3400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Needle Master", "Mind Control Mastery"},
	Damage = 300 :: number,
	AttackSpeed = 9.5 :: number,
	Range = 22 :: number,
	Ability = "Needle Throw" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 22 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 9,
			Range = 22,
			UpgradePrice = 1450,
		},
		[2] = {
			Damage = 1300,
			AttackSpeed = 8.5,
			Range = 23,
			AttackSize = 23,
			UpgradePrice = 1920,
		},
		[3] = {
			Damage = 1800,
			AttackSpeed = 7.5,
			Range = 24,
			AttackSize = 24,
			UpgradePrice = 2540,
		},
		[4] = {
			Damage = 2200,
			AttackSpeed = 7,
			Range = 25,
			AttackSize = 25,
			UpgradePrice = 3350,
		},
		[5] = {
			Damage = 2350,
			AttackSpeed = 7,
			Range = 30,
			AttackSize = 30,
			UpgradePrice = 4420,
		},
		[6] = {
			Damage = 2700,
			AttackSpeed = 7,
			Range = 32,
			AttackSize = 32,
			UpgradePrice = 5840,
		},
		[7] = {
			Damage = 3450,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 7720,
			AttackType = "Full",
			AttackSize = 34,
			Ability = "Needle Barrage",
		},
		[8] = {
			Damage = 4300,
			AttackSpeed = 6.5,
			Range = 35,
			AttackSize = 35,
			UpgradePrice = 10190,
		},
		[9] = {
			Damage = 6080,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 13470,
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