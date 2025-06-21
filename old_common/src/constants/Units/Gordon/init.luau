local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Gurdon" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 675 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Poison Magic"},
	Damage = 75 :: number,
	AttackSpeed = 8 :: number,
	Range = 19 :: number,
	Ability = "Poison Bullets" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "Poison", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 85,
			AttackSpeed = 8,
			Range = 19,
			UpgradePrice = 1015,
		},
		[2] = {
			Damage = 100,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 1465,
		},
		[3] = {
			Damage = 125,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 2225,
		},
		[4] = {
			Damage = 165,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2565,
			
			AttackSize = 30,
			Ability = "Poison Gas",
			AttackType = "Cone",
		},
		[5] = {
			Damage = 205,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2975,
		},
		[6] = {
			Damage = 235,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 3350,
		},
		[7] = {
			Damage = 275,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 4775,
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
	idle = "105470550713778",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit