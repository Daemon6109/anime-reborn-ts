local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.height = .25
Unit.Radius = 3
Unit.Evolved = "Kaido"
Unit.Tradable = false
Unit.ShinyTradable = true

Unit.configuration = {
	CameraOffset = CFrame.new(0,.5,.2),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Dragon Emperor [Hybrid]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2450 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Sea Emperor", "Dragon's Will"},
	Damage = 360 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Fierce Repulse" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 420,
			AttackSpeed = 6,
			Range = 17,
			UpgradePrice = 5000,
		},
		[2] = {
			Damage = 504,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 7600,
		},
		[3] = {
			Damage = 720,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 10050,
		},
		[4] = {
			Damage = 1080,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 13500,
			Ability = "God's Valley Crusher",
			AttackSize = 17,
			AttackType = "Circle",
		},
		[5] = {
			Damage = 1440,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 16000,
		},
		[6] = {
			Damage = 1980,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 18500,
		},
		[7] = {
			Damage = 2100,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 22000,
			Ability = "Skysplitting Impact",
			AttackSize = 40,
			AttackType = "Cone",
		},
		[8] = {
			Damage = 2280,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 26000,
		},
		[9] = {
			Damage = 3000,
			AttackSpeed = 8,
			Range = 29,
			SpecialAbility = "Dragon Emperor: Flaming Wrath",
			UpgradePrice = 31000,
			Ability = "Emperor's Roar",
			AttackType = "Full",
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
	idle = "107830578194597",
	walk = "17264216432",
	tail = "78711655263794",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	
	AnimModule.PlayCustomAnim(Unit.animations.tail, unit:WaitForChild("Humanoid"):WaitForChild("Model"):WaitForChild("torso1"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit