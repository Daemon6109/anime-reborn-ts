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
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Getero [Divine]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"The Human Heart", "Divine Enlightenment"},
	Damage = 825 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 25 :: number,
	Ability = "Still Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1250,
			AttackSpeed = 7.5,
			Range = 27,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1570,
			AttackSpeed = 7.5,
			Range = 28,
			UpgradePrice = 3120,
		},
		[3] = {
			Damage = 1980,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 3830,
		},
		[4] = {
			Damage = 2450,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 4700,
		},
		[5] = {
			Damage = 2670,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 6320,
			
			AttackType = "Line",
			AttackSize = 18,
			Ability = "Divine Punishment",
		},
		[6] = {
			Damage = 3190,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 7430,
		},
		[7] = {
			Damage = 4260,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 9410,
			
			AttackType = "Circle",
			AttackSize = 25,
			Ability = "Divine Reckoning",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[8] = {
			Damage = 5120,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 11920,
		},
		[9] = {
			Damage = 6580,
			AttackSpeed = 6,
			Range = 36,
			UpgradePrice = 15100,
			AttackSize = 24,
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
	idle = "81459795574554",
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