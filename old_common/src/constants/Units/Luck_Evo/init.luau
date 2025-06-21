local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Evolved = "Luck"
Unit.Tradable = false
Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Lucky One [Surge]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Electrified Mana", "Will of Thunder"},
	Damage = 213 :: number,
	AttackSpeed = 5 :: number,
	Range = 15 :: number,
	Ability = "Lightning Kick" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Stun", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 269,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 363,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 3400,
		},
		[3] = {
			Damage = 457,
			AttackSpeed = 5,
			Range = 17,
			UpgradePrice = 3850,
		},
		[4] = {
			Damage = 494,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 4200,
			AttackType = "Circle",
			Ability = "Thunderbolt",
			AttackSize = 8,
		},
		[5] = {
			Damage = 638,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 5000,
		},
		[6] = {
			Damage = 738,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 6250,
		},
		[7] = {
			Damage = 1050,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 8000,
			AttackType = "Line",
			Ability = "Lightning Barrage",
			AttackSize = 8,
		},
		[8] = {
			Damage = 1200,
			AttackSpeed = 7.5,
			Range = 25,
			UpgradePrice = 9500,
		},
		[9] = {
			Damage = 1640,
			AttackSpeed = 7,
			Range = 28,
			UpgradePrice = 11850, 
			AttackType = "Line",
			Ability = "Kernos",
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
	idle = "82855101080920",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit