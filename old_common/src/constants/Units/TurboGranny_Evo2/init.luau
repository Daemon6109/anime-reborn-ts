local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "Seiko"
Unit.ShinyTradable = true

Unit.height = 1

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Turbo Grandmother" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1740 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"True Sight", "Shared Sight"},
	Damage = 480 :: number,
	AttackSpeed = 6 :: number,
	Range = 19 :: number,
	Ability = "Turbo Dash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 680,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 2350,
		},
		[2] = {
			Damage = 839,
			AttackSpeed = 5.5,
			Range = 23,
			UpgradePrice = 3666,
		},
		[3] = {
			Damage = 1020,
			AttackSpeed = 5.5,
			Range = 24,
			UpgradePrice = 5700,
		},
		[4] = {
			Damage = 1266,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 7999,
			
			Ability = "Cursed Hands",
			AttackType = "Circle",
			AttackSize = 15, 
		},
		[5] = {
			Damage = 1576,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 9600,
		},
		[6] = {
			Damage = 1848,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 11000,
		},
		[7] = {
			Damage = 2180,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 14680,
		},
		[8] = {
			Damage = 2174,
			AttackSpeed = 5.5,
			Range = 31,
			UpgradePrice = 17000,
		},
		[9] = {
			Damage = 2300,
			AttackSpeed = 5.5,
			Range = 31,
			UpgradePrice = 14680,
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
	idle = "82962527564512",
	walk = '108507658101181'
}

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local animController = unit.TurboGranny.AnimationController

	AnimModule.PlayCustomAnim(Unit.animations.idle, animController, 1, "Idle", {Weight = 2, Fade = .15})
end

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit