local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

--Unit.height = .15
Unit.Radius = 3
Unit.Evolved = "Gamma Brothers"
Unit.Tradable = true
Unit.configuration = {
	CameraOffset = CFrame.new(-.5,0,.05),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.5, -0.02, -3) * CFrame.Angles(0,math.rad(-160),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Delta Brothers [Core]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1850 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Delta One", "Delta Two"},
	Damage = 660 :: number,
	AttackSpeed = 10 :: number,
	Range = 17 :: number,
	Ability = "Blaster Shots" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 756,
			AttackSpeed = 9,
			Range = 18,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 876,
			AttackSpeed = 9,
			Range = 20,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 1116,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 1260,
			AttackSpeed = 8,
			Range = 23,
			UpgradePrice = 5000,
		},
		[5] = {
			Damage = 1560,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 5750,
			Ability = "Delta Impact",
			AttackSize = 10,
			AttackType = "Circle",
			UnitType = "Hybrid",
		},
		[6] = {
			Damage = 1800,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 6600,
		},
		[7] = {
			Damage = 2088,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 8400,
		},
		[8] = {
			Damage = 2220,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 9900,
			Ability = "Super Delta Blast",
			AttackSize = 10,
			AttackType = "Line",
		},
		[9] = {
			Damage = 2500,
			AttackSpeed = 9,
			Range = 28,
			SpecialAbility = "Delta Force: Core Breaker",
			UpgradePrice = 12000,
		}
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "75256281553824",
	walk = "17264216432",
	IdleG1 = "100987371000238",
	IdleG2 = "76242587909173",
	cape = "131092558555940",
	leftwalk = "86422637935687",
	rightwalk = "106582949256031", 
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit:Instance)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local Animations = Unit.animations

	AnimModule.PlayCustomAnim(Animations["IdleG1"], unit:WaitForChild("Gamma1"):WaitForChild("Humanoid"):WaitForChild("Animator"), 1, "Idle1", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim(Animations["cape"], unit:WaitForChild("Gamma1"):WaitForChild("Gamma 1 [ Anime Reborn ]"):WaitForChild("AnimationController"), 1, "cape", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim(Animations["IdleG2"], unit:WaitForChild("Gamma2"):WaitForChild("Humanoid"):WaitForChild("Animator"), 1, "Idle2", {Weight = 2, Fade = .15})
	AnimModule.PlayAnim(Animations["cape"], unit:WaitForChild("Gamma2"), 1, "cape", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit