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
	DisplayName = "Yaske" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 700 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 80 :: number,
	AttackSpeed = 6 :: number,
	Range = 14 :: number,
	Ability = "Spirit Gun" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 95,
			AttackSpeed = 6,
			Range = 14.5,
			UpgradePrice = 1600,
		},
		[2] = {
			Damage = 115,
			AttackSpeed = 6,
			Range = 15.5,
			UpgradePrice = 2150,
		},
		[3] = {
			Damage = 155,
			AttackSpeed = 6,
			Range = 16,
			UpgradePrice = 2700,
		},
		[4] = {
			Damage = 240,
			AttackSpeed = 5.5,
			Range = 17,
			UpgradePrice = 3500,
			AttackType = "Circle",
			Ability = "Big Spirit Gun",
			AttackSize = 15,
			UnitType = "Hybrid",
		},
		[5] = {
			Damage = 290,
			AttackSpeed = 5.5,
			Range = 18,
			UpgradePrice = 4000,
		},
		[6] = {
			Damage = 320,
			AttackSpeed = 5.5,
			Range = 19.5,
			UpgradePrice = 5700,
		},
		[7] = {
			Damage = 360,
			AttackSpeed = 5,
			Range = 21,
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
	idle = "17401967745",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit