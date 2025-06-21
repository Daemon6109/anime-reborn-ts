local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Zero [Purple]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"OniGiri", "Critical Striker"},
	Damage = 1300 :: number,
	AttackSpeed = 13 :: number,
	Range = 19 :: number,
	Ability = "Thousand Cuts" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19/2 :: Enums.AttackSizeTypes,
	AttackEffect = "Scar", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1562.5,
			AttackSpeed = 12.5,
			Range = 23,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 2187.5,
			AttackSpeed = 12,
			Range = 23.5,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 2500,
			AttackSpeed = 12,
			Range = 25,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 3125,
			AttackSpeed = 11.5,
			Range = 11.5,
			UpgradePrice = 6500,
		},
		[5] = {
			Damage = 4250,
			AttackSpeed = 11.5,
			Range = 28,
			UpgradePrice = 8000,

			AttackType = "Line",
			AttackSize = 28/2,
			Ability = "Billion Fold",
		},
		[6] = {
			Damage = 4700,
			AttackSpeed = 11,
			Range = 30,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 5220,
			AttackSpeed = 10.5,
			Range = 30,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 5750,
			AttackSpeed = 10.5,
			Range = 32,
			UpgradePrice = 12750,

			AttackType = "Line",
			AttackSize = 32/2,
			Ability = "Six Paths",
		},
		[9] = {
			Damage = 6250,
			AttackSpeed = 7.3,
			Range = 32,
			UpgradePrice = 13000,
		}
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "95989952033580",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit