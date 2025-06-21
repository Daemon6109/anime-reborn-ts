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
	DisplayName = "Krollo [Bone]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Bandit’s Secret", "My Gallery", "Double Face"},
	Damage = 700 :: number,
	AttackSpeed = 8 :: number,
	Range = 26 :: number,
	Ability = "Dagger Rampage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1450,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 2060,
		},
		[2] = {
			Damage = 2000,
			AttackSpeed = 7.5,
			Range = 30,
			UpgradePrice = 2580,
		},
		[3] = {
			Damage = 2550,
			AttackSpeed = 7.5,
			Range = 31,
			UpgradePrice = 3230,
		},
		[4] = {
			Damage = 2750,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 4030,
			
			AttackType = "Line",
			AttackSize = 16,
			Ability = "Bone Fish",
		},
		[5] = {
			Damage = 3000,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 5050,
		},
		[6] = {
			Damage = 3500,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 6310,
		},
		[7] = {
			Damage = 3940,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 7890,
			
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Indoor Fish",
		},
		[8] = {
			Damage = 4750,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 9870,
		},
		[9] = {
			Damage = 5890,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 12340,
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
	idle = "108919366993004",
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