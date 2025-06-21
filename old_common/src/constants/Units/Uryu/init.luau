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
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Uriu" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Spiritual Power"},
	Damage = 80 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 21 :: number,
	Ability = "Letz Stil" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 95,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 900,
		},
		[2] = {
			Damage = 105	,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 1450,
		},
		[3] = {
			Damage = 135,
			AttackSpeed = 6.5,
			Range = 26,
			UpgradePrice = 1800,
		},
		[4] = {
			Damage = 185,
			AttackSpeed = 6.5,
			Range = 27,
			UpgradePrice = 2700,
		},
		[5] = {
			Damage = 220,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 3200,
			Ability = "Licht Regen",
			AttackType = "Circle",
			AttackSize = 11,
		},
		[6] = {
			Damage = 250,
			AttackSpeed = 6,
			Range = 29,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 300,
			AttackSpeed = 5.5,
			Range = 30.5,
			UpgradePrice = 7500,
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
	idle = "118037191652670",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	--local AnimModule = require(game.ReplicatedStorage.AnimModule)
	--local Animations = script.Animations

	--AnimModule.PlayCustomAnim(Animations["Hair"], unit:WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit