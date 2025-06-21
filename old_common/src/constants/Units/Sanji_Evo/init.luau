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
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Sijin [Cook]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Diable Jambe"},
	Damage = 950 :: number,
	AttackSpeed = 11.5 :: number,
	Range = 30 :: number,
	Ability = "Party Table Kick" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 30/2 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	UpgradesInfo = {
		[1] = {
			Damage = 1700,
			AttackSpeed = 11.5,
			Range = 32,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 2100,
			AttackSpeed = 10.5,
			Range = 34,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 2850,
			AttackSpeed = 10.5,
			Range = 35,
			UpgradePrice = 5500,
		},
		[4] = {
			Damage = 3550,
			AttackSpeed = 10,
			Range = 36,
			UpgradePrice = 6500,
			
			AttackType = "Circle",
			AttackSize = 18,
			Ability = "Concasser Crush",
		},
		[5] = {
			Damage = 4100,
			AttackSpeed = 10,
			Range = 37,
			UpgradePrice = 7000,
		},
		[6] = {
			Damage = 4950,
			AttackSpeed = 9.5,
			Range = 38,
			UpgradePrice = 7250,
		},
		[7] = {
			Damage = 6000,
			AttackSpeed = 9.5,
			Range = 40,
			UpgradePrice = 7500,
			
			AttackType = "Circle",
			AttackSize = 18.5,
			Ability = "Kick Barrage",
		},
		[8] = {
			Damage = 6650,
			AttackSpeed = 7.5,
			Range = 40,
			UpgradePrice = 10000,
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
	idle = "86579607855805",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit