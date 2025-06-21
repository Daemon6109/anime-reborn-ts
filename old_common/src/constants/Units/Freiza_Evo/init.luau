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
	DisplayName = "Breiza [Golden]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Emperors Ego", "Death Beam"},
	Damage = 600 :: number,
	AttackSpeed = 7 :: number,
	Range = 30 :: number,
	Ability = "Death Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "Dark Flames", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1200,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 3000,
		},
		[2] = {
			Damage = 1650,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 4200,
		},
		[3] = {
			Damage = 1750,
			AttackSpeed = 6.5,
			Range = 33,
			UpgradePrice = 5530,
		},
		[4] = {
			Damage = 2200,
			AttackSpeed = 6,
			Range = 34,
			UpgradePrice = 6270,
		},
		[5] = {
			Damage = 3000,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 7000,
		},
		[6] = {
			Damage = 3350,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 7500,
			
			Ability = "Death Ball",
			AttackType = "Circle",
			AttackSize = 17,
		},
		[7] = {
			Damage = 3350,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 8100,
		},
		[8] = {
			Damage = 3750,
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 9300,
			
			Ability = "Supernova",
			AttackType = "Circle",
			AttackSize = 20,
		},
		[9] = {
			Damage = 4150,
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 10500,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "131142285881068",
	walk = "17264216432",
	FreizatailIdle = "104511574371062"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.FreizatailIdle, unit:WaitForChild("FreizatailIdle"):WaitForChild("AnimationController"), 1, "FreizatailIdleanim", {Weight = 2, Fade = .15})
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