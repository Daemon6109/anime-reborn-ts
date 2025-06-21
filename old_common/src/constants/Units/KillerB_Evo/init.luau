local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "KillerB"

Unit.configuration = {
	Viewport = CFrame.new(-.08, .1, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "CoolB [Awakened]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1230 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 212 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Cutting Wheel" :: string, -- starting ability
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
			Damage = 287,
			AttackSpeed = 6,
			Range = 17,
			UpgradePrice = 1740,
		},
		[2] = {
			Damage = 350,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 2460,
		},
		[3] = {
			Damage = 432,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 3200,
		},
		[4] = {
			Damage = 531,
			AttackSpeed = 4,
			Range = 23,
			UpgradePrice = 4350,
			
			Ability = "Sword Pierce",
			AttackSize = 10,
			AttackType = "Line",
		},
		[5] = {
			Damage = 637,
			AttackSpeed = 4,
			Range = 25,
			UpgradePrice = 5000,
		},
		[6] = {
			Damage = 756,
			AttackSpeed = 4,
			Range = 25,
			UpgradePrice = 5920,
		},
		[7] = {
			Damage = 850,
			AttackSpeed = 4,
			Range = 26,
			UpgradePrice = 6750,
		},
		[8] = {
			Damage = 1045,
			AttackSpeed = 4,
			Range = 26,
			UpgradePrice = 8444,
			
			Ability = "Finishing Sting",
			AttackSize = 10,
			AttackType = "Circle",
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
	idle = "114162951181562",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit