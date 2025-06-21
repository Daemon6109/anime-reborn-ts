local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-0.1, .4, -1.4)*CFrame.Angles(0,math.rad(-180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Killa" :: string,
	Rarity = "Epic" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Shock"},
	Damage = 15 :: number,
	AttackSpeed = 3 :: number,
	Range = 12 :: number,
	Ability = "Lightning Palm" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Single" :: Enums.AttackTypes,
	AttackSize = 1 :: Enums.AttackSizeTypes,
	AttackEffect = "Stun", --effects that applies on the enemy when attacked
	AttackEffectDuration = 1.5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 30,
			Range = 13,
			UpgradePrice = 800,
			AttackSpeed = 3,
		},
		[2] = {
			Damage = 45,
			Range = 15,
			UpgradePrice = 1000,
			AttackSpeed = 3,
		},
		[3] = {
			Damage = 60,
			Range = 17,
			AttackSpeed = 3,
			UpgradePrice = 1500,
		},
		[4] = {
			Damage = 85,
			Range = 18,
			AttackSpeed = 4,
			AttackType = "Circle" :: Enums.AttackTypes,
			AttackSize = 7,
			Ability = "Thunderbolt",
			UpgradePrice = 1800,
			UnitType = "Hybrid",
		},
		[5] = {
			Damage = 110,
			Range = 20,
			UpgradePrice = 2150,
			AttackSpeed = 4,
		}
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "17381247700",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit