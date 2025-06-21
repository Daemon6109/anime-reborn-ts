local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "Toshiro"

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Tashrio [Captain]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Hybrid" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1090 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Adaptive", "Ice Shatter"},
	Damage = 225 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "Frozen Heavens" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 281,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 1700,
		},
		[2] = {
			Damage = 350,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 2000,
		},
		[3] = {
			Damage = 418,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 2460,
			
			AttackType = "Line",
			Ability = "Hail Flower",
			AttackSize = 8,
		},
		[4] = {
			Damage = 500,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 3000,
		},
		[5] = {
			Damage = 593,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 3500,
		},
		[6] = {
			Damage = 675,
			AttackSpeed = 6.5,
			Range = 27,
			UpgradePrice = 4100,

			AttackType = "Line",
			Ability = "Hail Dragon",
			AttackSize = 10,
		},
		[7] = {
			Damage = 781,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 5600,
		},
		[8] = {
			Damage = 1050,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 7600,
		},
		[9] = {
			Damage = 1400,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 9800,
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
	idle = "77016121610005",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit