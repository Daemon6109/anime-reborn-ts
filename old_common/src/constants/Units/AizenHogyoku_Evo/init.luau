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
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Aizon Hogyoku [Evo]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Kanzen Saimin", "Overwhelming Spiritual Pressure"},
	Damage = 3125 :: number,
	AttackSpeed = 13 :: number,
	Range = 30 :: number,
	Ability = "Hypnosis Aura" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 3437.5,
			AttackSpeed = 12.5,
			Range = 32,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 3750,
			AttackSpeed = 12.5,
			Range = 34,
			UpgradePrice = 2850,
			AttackType = "Circle",
			AttackSize = 18,
			Ability = "Imaginary Flames",
		},
		[3] = {
			Damage = 4062.5,
			AttackSpeed = 12,
			Range = 35,
			UpgradePrice = 8500,
		},
		[4] = {
			Damage = 4312.5,
			AttackSpeed = 11.5,
			Range = 36,
			UpgradePrice = 6500,
		},
		[5] = {
			Damage = 4437.5,
			AttackSpeed = 11.5,
			Range = 37,
			UpgradePrice = 10000,
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Vortex Of Despair",
		},
		[6] = {
			Damage = 4562.5,
			AttackSpeed = 11.5,
			Range = 38,
			UpgradePrice = 7250,
		},
		[7] = {
			Damage = 5625,
			AttackSpeed = 10,
			Range = 40,
			UpgradePrice = 7500,
		},
		[8] = {
			Damage = 6825,
			AttackSpeed = 8,
			Range = 40,
			UpgradePrice = 12500,
			AttackType = "Circle",
			AttackSize = 25,
			Ability = "Flame Release",
		},
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "116453275247492", --"115626504370471",
	walk = "17264216432",
	wings = "124190768688390"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.wings, unit:WaitForChild("yuryryryryr"):WaitForChild("AnimationController"), 1, "yuryryryryranim", {Weight = 2, Fade = .15})
			end)
		end)
	end)
	--print("animated")
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit