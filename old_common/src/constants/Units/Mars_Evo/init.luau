local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Evolved = "Mars"
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
	DisplayName = "Mercury [Brilliant]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Crystallized Mana"},
	Damage = 375 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "Splitter Barrage" :: string, -- starting ability
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
			Damage = 450,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 2600,
		},
		[2] = {
			Damage = 575,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 688,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 1050,
			AttackSpeed = 8.5,
			Range = 25,
			UpgradePrice = 4400,
			AttackType = "Line",
			Ability = "Crystal Shots",
			AttackSize = 7,
			UnitType = "Hybrid",
		},
		[5] = {
			Damage = 1388,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 5250,
		},
		[6] = {
			Damage = 1563,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 5900,
			AttackType = "Line",
			Ability = "Crystal Strike",
			AttackSize = 9,
		},
		[7] = {
			Damage = 1875,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 7550,
		},
		[8] = {
			Damage = 2063,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 10000,
			AttackType = "Line",
			Ability = "Crystal Sword",
			AttackSize = 12,
		},
		[9] = {
			Damage = 2300,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 11300,
			NewPassive = "Crystal Lord",
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
	idle = "101661711806199",
	walk = "17264216432",
	hairAnim = "98944742673151"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	--local AnimModule = require(game.ReplicatedStorage.AnimModule)

	--AnimModule.PlayCustomAnim(Unit.animations.hairAnim, unit:WaitForChild("asta2"):WaitForChild("hair"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit