local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -2)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -4.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1.5)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Laugfy [Gear 4]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Gear 2nd", "Perfect Haki"},
	Damage = 1000 :: number,
	AttackSpeed = 11 :: number,
	Range = 19 :: number,
	Ability = "Bounce Javelin" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 19/2 :: Enums.AttackSizeTypes,
	AttackEffect = "Slow", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1500,
			AttackSpeed = 11,
			Range = 23,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 2000,
			AttackSpeed = 10.5,
			Range = 34.5,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 2420,
			AttackSpeed = 10.5,
			Range = 35,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 3000,
			AttackSpeed = 10.5,
			Range = 36,
			UpgradePrice = 6500,
			
			AttackType = "Circle",
			AttackSize = 28/2,
			Ability = "King Kong Impact",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 3500,
			AttackSpeed = 10.5,
			Range = 37,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 4200,
			AttackSpeed = 10,
			Range = 38,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 5000,
			AttackSpeed = 10,
			Range = 39,
			UpgradePrice = 11000,
			
			AttackType = "Circle",
			AttackSize = 25,
			Ability = "King Kong Gun",
		},
		[8] = {
			Damage = 6500,
			AttackSpeed = 7.5,
			Range = 40,
			UpgradePrice = 12000,
		},
		[9] = {
			Damage = 7500,
			AttackSpeed = 7.5,
			Range = 40,
			UpgradePrice = 15000,
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
	idle = "83378599502109",
	walk = "17264216432",
	CustomRig = "98839893777041",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.CustomRig, unit:WaitForChild("CustomRig"):WaitForChild("AnimationController"), 1, "CustomIdleanim", {Weight = 2, Fade = .15})
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