local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Evolved = "Asta"
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
	DisplayName = "Osta [Anti-Form]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Anti-Magic Grimoire", "Brotherhood"},
	Damage = 300 :: number,
	AttackSpeed = 7 :: number,
	Range = 17 :: number,
	Ability = "Boar Thrust" :: string, -- starting ability
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
			Damage = 375,
			AttackSpeed = 7,
			Range = 17,
			UpgradePrice = 2600,
		},
		[2] = {
			Damage = 438,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 3400,
		},
		[3] = {
			Damage = 500,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 4300,
			AttackType = "Line",
			Ability = "Black Meteorite",
			AttackSize = 6,
		},
		[4] = {
			Damage = 575,
			AttackSpeed = 5.5,
			Range = 21,
			UpgradePrice = 5300,
		},
		[5] = {
			Damage = 688,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 5500,
			AttackType = "Line",
			Ability = "Black Hurricane",
			AttackSize = 8,
			UnitType = "Hybrid"
		},
		[6] = {
			Damage = 813,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 969,
			AttackSpeed = 7,
			Range = 28,
			UpgradePrice = 7500,
		},
		[8] = {
			Damage = 1125,
			AttackSpeed = 6,
			Range = 31,
			UpgradePrice = 9000,
		},
		[9] = {
			Damage = 1800,
			AttackSpeed = 8,
			Range = 32,
			UpgradePrice = 11000,
			AttackType = "Line",
			Ability = "Black Divider",
			AttackSize = 10,
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
	idle = "93686370326927",
	walk = "17264216432",
	hairAnim = "98944742673151"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)

	AnimModule.PlayCustomAnim(Unit.animations.hairAnim, unit:WaitForChild("asta2"):WaitForChild("hair"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit