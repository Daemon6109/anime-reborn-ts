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
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 7 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Fire Mage [Flame]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Family Influence", "Flame Fruit"},
	Damage = 700 :: number,
	AttackSpeed = 11 :: number,
	Range = 30 :: number,
	Ability = "Fire Fist" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1250,
			AttackSpeed = 10,
			Range = 32,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 1750,
			AttackSpeed = 10,
			Range = 34,
			UpgradePrice = 3850,
		},
		[3] = {
			Damage = 2000,
			AttackSpeed = 10,
			Range = 35,
			UpgradePrice = 5500,
		},
		[4] = {
			Damage = 2500,
			AttackSpeed = 10,
			Range = 36,
			UpgradePrice = 6500,
		},
		[5] = {
			Damage = 3500,
			AttackSpeed = 9.5,
			Range = 37,
			UpgradePrice = 8000,
			
			AttackType = "Circle",
			AttackSize = 23,
			Ability = "Creeping Fire"
		},
		[6] = {
			Damage = 3750,
			AttackSpeed = 9,
			Range = 38,
			UpgradePrice = 9250,
		},
		[7] = {
			Damage = 4500,
			AttackSpeed = 8,
			Range = 40,
			UpgradePrice = 11500,
			
			AttackType = "Circle",
			AttackSize = 28,
			Ability = "Fire Dragon King"
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
	idle = "81132963348411",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit