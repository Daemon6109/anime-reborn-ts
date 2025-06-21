local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Domau" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},	
	Damage = 250 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Ground Smash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 650,
			AttackSpeed = 6,
			Range = 17,
			UpgradePrice = 980,
		},
		[2] = {
			Damage = 800,
			AttackSpeed = 5,
			Range = 18,
			UpgradePrice = 1200,
		},
		[3] = {
			Damage = 800,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 1700,
		},
		[4] = {
			Damage = 1000,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 2500,
			AttackType = "Cone",
			Ability = "Tornado Blitz",
			AttackSize = 22,
		},
		[5] = {
			Damage = 1100,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 3000,
		},
		[6] = {
			Damage = 1250,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 3500,
		},
		[7] = {
			Damage = 1500,
			AttackSpeed = 5,
			Range = 28,
			UpgradePrice = 3850,
		},
	}
	
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "81700767594396",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit