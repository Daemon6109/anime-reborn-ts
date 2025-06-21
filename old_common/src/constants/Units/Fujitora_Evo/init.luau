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
	DisplayName = "Gravity Master" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Blindness", "Gravitational impacts"},
	Damage = 1259 :: number,
	AttackSpeed = 12 :: number,
	Range = 23 :: number,
	Ability = "Debris Cover" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "Slow", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 2343.75,
			AttackSpeed = 12,
			Range = 24,
			UpgradePrice = 2650,
		},
		[2] = {
			Damage = 3125,
			AttackSpeed = 12,
			Range = 24,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 3781.25,
			AttackSpeed = 12,
			Range = 26,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 4687.5,
			AttackSpeed = 12,
			Range = 26,
			UpgradePrice = 5425,
			
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Meteor Strike",
			
			UnitType = "Hybrid" :: Enums.UnitType
		},
		[5] = {
			Damage = 5000,
			AttackSpeed = 12,
			Range = 27,
			UpgradePrice = 6450,
		},
		[6] = {
			Damage = 5250,
			AttackSpeed = 11,
			Range = 30,
			UpgradePrice = 7825,
		},
		[7] = {
			Damage = 5000,
			AttackSpeed = 10,
			Range = 31,
			UpgradePrice = 9480,
		},
		[8] = {
			Damage = 5900,
			AttackSpeed = 10,
			Range = 31,
			UpgradePrice = 10760,
			
			AttackType = "Full",
			AttackSize = 31,
			Ability = "Meteor Shower",
		},
		[9] = {
			Damage = 6500,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 11850,
		}
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "115196154965429",
	walk = "17264216432",
	InsaneCAPE = "131628941543930"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.InsaneCAPE, unit:WaitForChild("InsaneCAPE"):WaitForChild("AnimationController"), 1, "InsaneCAPEanim", {Weight = 2, Fade = .15})
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