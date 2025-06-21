local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Whitebeard"
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
	DisplayName = "Greybeard [Sea Emperor]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1850 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Strongest Man Alive", "Tremor"},
	Damage = 240 :: number,
	AttackSpeed = 8 :: number,
	Range = 20 :: number,
	Ability = "Quake Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 4,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
		--	Passives = {"Warlord"},
			Damage = 330,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 2350,
		},
		[2] = {
			Damage = 480,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 2700,
		},
		[3] = {
			Damage = 660,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 3500,
			AttackType = "Cone",
			Ability = "Bisento Slash",
			AttackSize = 25,
		},
		[4] = {
			Damage = 700,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 4150,
		},
		[5] = {
			Damage = 780,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 4700,
		},
		[6] = {
			Damage = 872,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 5200,
			AttackType = "Full",
			Ability = "Ground Shatter",
			AttackSize = 25,
		},
		[7] = {
			Damage = 960,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 6150,
		},
		[8] = {
			Damage = 1008,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 8000,
		},
		[9] = {
			Damage = 1200,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 11000,
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
	idle = "88553641715653",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit