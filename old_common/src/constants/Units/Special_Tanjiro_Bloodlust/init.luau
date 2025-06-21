local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.08, .1, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Sun Prodigy [Blazing]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 875 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 85 :: number,
	AttackSpeed = 5 :: number,
	Range = 15 :: number,
	Ability = "Flaming Dance" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Sun Burn", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 125,
			AttackSpeed = 6,
			Range = 16,
			UpgradePrice = 1150,
		},
		[2] = {
			Damage = 165,
			Range = 17,
			AttackSpeed = 6,
			Ability = "Burning Bones",
			AttackSize = 8,
			UpgradePrice = 2250,
		},
		[3] = {
			Damage = 220,
			Range = 17,
			AttackSpeed = 5.5,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 300,
			Range = 20,
			AttackSpeed = 5,
			UpgradePrice = 4100,
		},
		[5] = {
			Damage = 425,
			Range = 22,
			AttackSpeed = 5,
			UpgradePrice = 5700,
		},
		[6] = {
			Damage = 500,
			Range = 22,
			AttackSpeed = 6,
			UpgradePrice = 6250,
		},
		[7] = {
			Damage = 550,
			Range = 26,
			AttackSpeed = 6,
			Ability = "Dance Of The Fire God",
			AttackSize = 10,
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
	idle = "17881512810",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit