local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Magma" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Fire Magic"},
	Damage = 60 :: number,
	AttackSpeed = 6 :: number,
	Range = 20 :: number,
	Ability = "Fire Batter" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 80,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 950,
		},
		[2] = {
			Damage = 90,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 950,
		},
		[3] = {
			Damage = 105,
			AttackSpeed = 5.5,
			Range = 23,
			UpgradePrice = 1600,
		},
		[4] = {
			Damage = 195,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 2250,

			Ability = "Fireball Barrage",
			AttackType = "Circle",
			AttackSize = 8
		},
		[5] = {
			Damage = 215,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2500,
		},
		[6] = {
			Damage = 250,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2950,
		},
		[7] = {
			Damage = 300,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 3500,
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
	idle = "72679824980823",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit