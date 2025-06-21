local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .65, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 80 :: number,
	MaxUpgrades = 7 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Strongest Shaman" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 2 :: number,
	AttackSpeed = 5 :: number,
	Range = 35 :: number,
	Ability = "Lapse Blue" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	SpecialAbilityCooldownGroup = "Domains" :: Enums.SpecialCooldownGroups,
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Bleed", --effects that applies on the enemy when attacked
	AttackEffectDuration = 4,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1,
			AttackSize = 15,
			UpgradePrice = 600,
			UnitType = "Hybrid",
		},
		[2] = {
			AttackType = "Cone",
			AttackEffect = "Burning",
			AttackEffectDuration = 10,
			Damage = 1,
			AttackSpeed = 5,
			Ability = "Reversal Red",
			AttackSize = 65,
			UpgradePrice = 900,
		},
		[3] = {
			AttackEffect = "Slow",
			Damage = 1,
			UpgradePrice = 1500,
			AttackSpeed = 4,
		},
		[4] = {
			Damage = 1,
			AttackType = "Line",
			AttackEffect = "Stun",
			AttackEffectDuration = 3,
			Ability = "Hollow Purple",
			AttackSize = 10,
			Range = 45,
			UpgradePrice = 2200,
		},
		[5] = {
			Damage = 1,
			Range = 50,
			UpgradePrice = 3000,
		},
		[6] = {
			AttackEffect = "Dark Flames",
			AttackEffectDuration = 8,
			Range = 65,
			SpecialAbility = "Domain Expansion: Unlimited Void",
			Damage = 1,
			UpgradePrice = 3000,
		},
		[7] = {
			Range = 150,
			Damage = 9999999,
			UpgradePrice = 100000000000,
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
	idle = "18451931529",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	--local AnimModule = require(game.ReplicatedStorage.AnimModule)
	--local Animations = script.Animations

	--AnimModule.PlayCustomAnim(Animations["Tail"], unit:WaitForChild("cloths"):WaitForChild("untitled"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
	--AnimModule.PlayCustomAnim(Animations["Hair"], unit:WaitForChild("cloths"):WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
	----print("animated")
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit