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
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "String Mage [Awakened]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Revenge", "Off White"},
	Damage = 1000 :: number,
	AttackSpeed = 11.5 :: number,
	Range = 30 :: number,
	Ability = "String Threads" :: string, -- starting ability
	SpecialAbility = "Bird Cage" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1875,
			AttackSpeed = 11.5,
			Range = 32,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 2500,
			AttackSpeed = 11.5,
			Range = 34,
			UpgradePrice = 3850,
		},
		[3] = {
			Damage = 3025,
			AttackSpeed = 11.5,
			Range = 35,
			UpgradePrice = 4500,
		},
		[4] = {
			Damage = 3750,
			AttackSpeed = 11,
			Range = 36,
			UpgradePrice = 6500,
			
			AttackType = "Circle",
			AttackSize = 25,
			Ability = "Pillar Eruption",
			
			AttackEffect = "Slow",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 4375,
			AttackSpeed = 11,
			Range = 37,
			UpgradePrice = 6800,
		},
		[6] = {
			Damage = 5250,
			AttackSpeed = 11,
			Range = 38,
			UpgradePrice = 7250,
			
			AttackType = "Circle",
			AttackSize = 30,
			Ability = "String Threads",
		},
		[7] = {
			Damage = 6250,
			AttackSpeed = 10,
			Range = 40,
			UpgradePrice = 7500,
		},
		[8] = {
			Damage = 7250,
			AttackSpeed = 7.5,
			Range = 40,
			UpgradePrice = 12500,
			
			AttackType = "Circle",
			AttackSize = 35,
			Ability = "Birdcage",
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
	idle = "100745724831757",
	walk = "17264216432",
	cape = "115363681855827"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.cape, unit:WaitForChild("cape"):WaitForChild("AnimationController"), 1, "capeanim", {Weight = 2, Fade = .15})
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