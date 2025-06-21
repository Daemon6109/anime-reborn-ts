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
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Emily [Love]" :: string,
	Rarity = "Epic" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	--============================--
	PlacementPrice = 460 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 40 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "IceFall" :: string, -- starting ability
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
			Damage = 60,
			AttackSpeed = 6,
			Range = 17,
			UpgradePrice = 700,
		},
		[2] = {
			Damage = 75,
			AttackSpeed = 6,
			Range = 17,
			UpgradePrice = 1000,
		},
		[3] = {
			Damage = 100,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 1200,
		},
		[4] = {
			Damage = 125,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 1500,
		},
		[5] = {
			Damage = 150,
			AttackSpeed = 4,
			Range = 25,
			UpgradePrice = 1950,
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
	idle = "79739401193315",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit