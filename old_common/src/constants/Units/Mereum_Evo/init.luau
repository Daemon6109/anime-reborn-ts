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
	MaxPlacementAmount = 1 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Bereum [King]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	PlacementPrice = 2400 :: number,
	--============================--
	CanSell = true :: boolean,
	--============================--
	Passives = {"Genetic Perfection", "Royale Execution"},
	Damage = 830 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 30 :: number,
	Ability = "Formicidae Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 16 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1280,
			AttackSpeed = 7.5,
			Range = 33,
			UpgradePrice = 2920,
		},
		[2] = {
			Damage = 1600,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 3560,
		},
		[3] = {
			Damage = 2000,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 4330,
		},
		[4] = {
			Damage = 2500,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 5280,
			Ability = "King Cannon",
			AttackType = "Line",
			AttackSize = 15,
		},
		[5] = {
			Damage = 2700,
			AttackSpeed = 6,
			Range = 36,
			UpgradePrice = 6430,
			AttackSize = 16,
		},
		[6] = {
			Damage = 3250,
			AttackSpeed = 6,
			Range = 36,
			UpgradePrice = 7500,
			AttackSize = 17.5,
		},
		[7] = {
			Damage = 4300,
			AttackSpeed = 6,
			Range = 38,
			UpgradePrice = 8250,
			
			Ability = "Tail Slam",
			AttackType = "Circle",
			AttackSize = 22,
		},
		[8] = {
			Damage = 5200,
			AttackSpeed = 6,
			Range = 42,
			UpgradePrice = 9375,
		},
		[9] = {
			Damage = 6620,
			AttackSpeed = 6,
			Range = 44,
			UpgradePrice = 9375,
			
			Ability = "Ant Liberation",
			AttackType = "Circle",
			AttackSize = 24, 
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
	idle = "74906617495182",
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