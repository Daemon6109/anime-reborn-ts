local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Evolved = "Yuno Clover"
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yano [Spirit]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Suffocating Gale", "Wind Spirit's Blessing"},
	Damage = 188 :: number,
	AttackSpeed = 8 :: number,
	Range = 18 :: number,
	Ability = "Towering Tornado" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Suffocation", --effects that applies on the enemy when attacked
	AttackEffectDuration = 15,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 263,
			AttackSpeed = 8,
			Range = 18,
			UpgradePrice = 2100,
		},
		[2] = {
			Damage = 338,
			AttackSpeed = 8,
			Range = 18,
			UpgradePrice = 2650,
		},
		[3] = {
			Damage = 419,
			AttackSpeed = 7.5,
			Range = 20,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 500,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 4750,
		},
		[5] = {
			Damage = 613,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 5350,
			
			AttackType = "Circle",
			Ability = "Gale White Blow",
			AttackSize = 6,
		},
		[6] = {
			Damage = 750,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 6600,
		},
		[7] = {
			Damage = 975,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 8700,
			
			AttackType = "Line",
			Ability = "Elf's Breath",
			AttackSize = 8,
		},
		[8] = {
			Damage = 1188,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 9900,
		},
		[9] = {
			Damage = 1650,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 11900,

			AttackType = "Circle",
			Ability = "Spirit Storm",
			AttackSize = 8,
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
	idle = "85951854414242",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit