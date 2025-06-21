local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Evolved = "Captain Yami"
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yamo [Serious]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2050 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Darkness", "Captain's Presence"},
	Damage = 258 :: number,
	AttackSpeed = 7 :: number,
	Range = 14 :: number,
	Ability = "Darkness Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 322,
			AttackSpeed = 7,
			Range = 16,
			UpgradePrice = 2425,
		},
		[2] = {
			Damage = 411,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 480,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 600,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 4250,
			UnitType = "Hybrid",
			
			AttackType = "Cone",
			Ability = "Darkness Barrage",
			AttackSize = 30,
		},
		[5] = {
			Damage = 660,
			AttackSpeed = 7.5,
			Range = 22,
			UpgradePrice = 4850,
		},
		[6] = {
			Damage = 738,
			AttackSpeed = 7,
			Range = 24,
			UpgradePrice = 5300,
		},
		[7] = {
			Damage = 1080,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 6825,

			AttackType = "Line",
			Ability = "Dark Thrust",
			AttackSize = 8,
		},
		[8] = {
			Damage = 1260,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 9150,
		},
		[9] = {
			Damage = 2000,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 11500,

			AttackType = "Line",
			Ability = "Dimension Slash",
			AttackSize = 6,
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
	idle = "133924858571797",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit