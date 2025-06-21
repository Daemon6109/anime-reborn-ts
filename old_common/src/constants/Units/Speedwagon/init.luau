local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 4
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
	DisplayName = "Speedcart" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Farm" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Philanthropist"},
	Damage = 0 :: number,
	AttackSpeed = 1 :: number,
	Range = 10 :: number,
	Ability = "Oil Rig" :: string, -- starting ability
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
			Money = 750,
			UpgradePrice = 1000,
		},
		[2] = {
			Money = 1500,
			UpgradePrice = 2500,
		},
		[3] = {
			Money = 3500,
			UpgradePrice = 4250,
		},
		[4] = {
			Money = 5000,
			Ability = "Factory",
			UpgradePrice = 6000,
			Range = 15,
		},
		[5] = {
			Money = 6500,
			UpgradePrice = 7500,
			Range = 15,
		},
		[6] = {
			Money = 8000,
			UpgradePrice = 8000,
			Range = 15,
		},
		[7] = {
			Money = 12500,
			Ability = "Conglomerate",
			UpgradePrice = 10000,
			Range = 15,
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
	idle = "106878732091811",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit