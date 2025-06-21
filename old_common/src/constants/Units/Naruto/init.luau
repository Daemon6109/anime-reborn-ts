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
	MaxPlacementAmount = 6 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Noroto" :: string,
	Rarity = "Rare" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 250 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 10 :: number,
	AttackSpeed = 5 :: number,
	Range = 12 :: number,
	Ability = "GroundSmash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	Passives = {"Shadow Clone"},
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 15,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 400,
		},
		[2] = {
			Damage = 25,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 650,
		},
		[3] = {
			Damage = 30,
			AttackSpeed = 5,
			Range = 18,
			UpgradePrice = 800,
		},
		[4] = {
			Damage = 35,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 900,
		},
		[5] = {
			AttackType = "Circle",
			AttackSize = 8,
			Ability = "Rasengan",
			Damage = 40,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 1150,
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
	idle = "108863438781215",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit