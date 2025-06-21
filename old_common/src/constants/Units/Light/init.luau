local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(.12, .65, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 8 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Lite (Yogame)" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Angelic" :: Enums.Elements,
	UnitType = "Support" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 500 :: number,
	CanSell = false :: boolean,
	--============================--
	Damage = 3000 :: number,
	AttackSpeed = 10 :: number,
	Range = 25 :: number,
	Ability = "" :: string, -- starting ability
	SpecialAbility = "" :: string, -- 
	SpecialAbilityCooldown = 100 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
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
			Damage = 5000,
			UpgradePrice = 700,
		},
		[2] = {
			Damage = 13000,
			UpgradePrice = 990,
		},
		[3] = {
			Damage = 25000,
			SpecialAbility = "Death Note",
			UpgradePrice = 2000,
		},
		[4] = {
			Damage = 33000,
			UpgradePrice = 3000,
		},
		[5] = {
			Damage = 55000,
			UpgradePrice = 7000,
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
	idle = "17893593497",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
	--_G.Unit:getUnitIdle(unit, "Generic:Idle1"):Play(0)
end

function Unit:onDelete(plr, unit)
end

return Unit
