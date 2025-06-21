local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 1
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	MaxUpgrades = 1 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Businessman" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Farm" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 10000 :: number,
	CanSell = false :: boolean,
	--============================--
	Passives = {},
	Damage = 0 :: number,
	AttackSpeed = 1 :: number,
	Range = 10 :: number,
	Ability = "Upgrade1" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 500 :: number, -- for farms
	--============================--
	AttackType = "Passive" :: Enums.AttackTypes,
	AttackSize = 0 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Money = 1875,
			UpgradePrice = 7500,
		},
		[2] = {
			Money = 2968.75,
			UpgradePrice = 10000,
		},
		[3] = {
			Money = 6289.0625,
			UpgradePrice = 15000,
			Range = 15,
		},
		[4] = {
			Money = 8326,
			UpgradePrice = 17500,
			Range = 15,
		},
		[5] = {
			Money = 9039,
			UpgradePrice = 17500,
			Range = 15,
		},
		[6] = {
			Money = 10163,
			UpgradePrice = 20000,
			Range = 15,
		},
		[7] = {
			Money = 11257,
			UpgradePrice = 22000,
			Range = 15,
		},
		[8] = {
			Money = 37401,
			UpgradePrice = 75000,
			Range = 15,
		},
		[9] = {
			Money = 70071,
			UpgradePrice = 90000,
			Range = 15,
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
	idle = "78956284811385",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit