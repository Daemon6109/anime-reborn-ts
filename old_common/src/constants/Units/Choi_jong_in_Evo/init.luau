local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 9 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Chui [SS]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1300 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Infernal Fury"},
	Damage = 625 :: number,
	AttackSpeed = 6 :: number,
	Range = 22 :: number,
	Ability = "Flame Spears" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 22 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = 0.3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 937.5,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1375,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 2750,
		},
		[3] = {
			Damage = 1687.5,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 4000,

		},
		[4] = {
			Damage = 1875,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 5750,

			Ability = "Flame Arrow",
			AttackType = "Circle",
			AttackSize = 12
		},
		[5] = {
			Damage = 2312.5,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 7500,
		},
		[6] = {
			Damage = 3125,
			AttackSpeed = 5,
			Range = 34,
			UpgradePrice = 8790,
		},
		[7] = {
			Damage = 3750.5,
			AttackSpeed = 5,
			Range = 36,
			UpgradePrice = 10100,
		},
		[8] = {
			Damage = 4062.75,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 11500,

			Ability = "Flame Dragon",
			AttackType = "Circle",
			AttackSize = 20,
		},
		[9] = {
			Damage = 5000,
			AttackSpeed = 6.5,
			Range = 40,
			UpgradePrice = 12800,
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
	idle = "124881101592369",
	coat = "86789114189421"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		if unit.Name == "ShinyModel" then return end
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		pcall(function()
			AnimModule.PlayCustomAnim(Unit.animations.coat, unit:WaitForChild("coat"):WaitForChild("AnimationController"), 1, "coatanim", {Weight = 2, Fade = .15})
		end)
	end)
	--print("animated")
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit