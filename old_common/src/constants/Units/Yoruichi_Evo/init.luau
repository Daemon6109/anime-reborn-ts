local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.2, .4, -1.3)*CFrame.Angles(0,math.rad(-180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 3 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yosichi [Heavy]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Shunko", "Utsushemi"},
	Damage = 187.5 :: number,
	AttackSpeed = 6 :: number,
	Range = 19 :: number,
	Ability = "Post Image Attack" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	UpgradesInfo = {
		[1] = {
			Damage = 625,
			AttackSpeed = 5.5,
			Range = 20,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1062.5,
			AttackSpeed = 5,
			Range = 21,
			UpgradePrice = 4100,
		},
		[3] = {
			Damage = 1437.5,
			AttackSpeed = 5,
			Range = 21,
			UpgradePrice = 5500,
		},
		[4] = {
			Damage = 1687.5,
			AttackSpeed = 5.5,
			Range = 24,
			UpgradePrice = 7000,
			AttackType = "Circle",
			Ability = "Wind Burst",
			AttackSize = 24,
		},
		[5] = {
			Damage = 1812.5,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 2062.5,
			AttackSpeed = 4.5,
			Range = 25,
			UpgradePrice = 9200,
		},
		[7] = {
			Damage = 3000,
			AttackSpeed = 4.5,
			Range = 25,
			UpgradePrice = 10680,
		},
		[8] = {
			Damage = 4000,
			AttackSpeed = 4.5,
			Range = 27,
			UpgradePrice = 12000,
			AttackType = "Circle",
			Ability = "Heavy Impact",
			AttackSize = 27,
		},
		[9] = {
			Damage = 6500,
			AttackSpeed = 7.5,
			Range = 28,
			UpgradePrice = 13750,
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
	idle = "83496529191125",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit