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
	DisplayName = "Zenit" :: string,
	Rarity = "Epic" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Thunder Disciple"},
	Damage = 30 :: number,
	AttackSpeed = 7 :: number,
	Range = 12 :: number,
	Ability = "Lightning Slashes" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Full" :: Enums.AttackTypes,
	AttackSize = 4 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 50,
			AttackSpeed = 7,
			Range = 13,
			UpgradePrice = 700,
		},
		[2] = {
			Damage = 75,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 1200,
			AttackType = "Line",
			Ability = "Thunderclap",
			AttackSize = 8,
		},
		[3] = {
			Damage = 90,
			AttackSpeed = 5,
			Range = 16,
			UpgradePrice = 1600,
		},
		[4] = {
			Damage = 115,
			AttackSpeed = 4.5,
			Range = 18,
			UpgradePrice = 1800,
		},
		[5] = {
			Damage = 135,
			AttackSpeed = 4.5,
			Range = 20,
			UpgradePrice = 2100,
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
	idle = "99267733782446",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit