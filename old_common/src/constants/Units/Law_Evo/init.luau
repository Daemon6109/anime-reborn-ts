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
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Sentinel [Heart]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Surgeons precision", "Scalpel"},
	Damage = 900 :: number,
	AttackSpeed = 11 :: number,
	Range = 19 :: number,
	Ability = "Gamma Knife" :: string, -- starting ability
	SpecialAbility = "Room" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19/2 :: Enums.AttackSizeTypes,
	AttackEffect = "Paralysis", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1800,
			AttackSpeed = 11,
			Range = 23,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 2750,
			AttackSpeed = 11,
			Range = 23,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 3500,
			AttackSpeed = 11,
			Range = 25,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 4000,
			AttackSpeed = 11,
			Range = 28,
			UpgradePrice = 6500,
		},
		[5] = {
			Damage = 4500,
			AttackSpeed = 11,
			Range = 30,
			UpgradePrice = 8000,
			
			AttackType = "Circle",
			AttackSize = 30/2,
			Ability = "Takt",
		},
		[6] = {
			Damage = 5250,
			AttackSpeed = 10.5,
			Range = 30,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 5750,
			AttackSpeed = 10,
			Range = 30,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 6200,
			AttackSpeed = 10,
			Range = 32,
			UpgradePrice = 12750,
			
			AttackType = "Circle",
			AttackSize = 32/2,
			Ability = "Room",
		},
		[9] = {
			Damage = 6500,
			AttackSpeed = 7.3,
			Range = 32,
			UpgradePrice = 15555,
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
	idle = "120123188805305",
	walk = "17264216432",
	Browcoat = "110381758328697",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.Browcoat, unit:WaitForChild("Browcoat"):WaitForChild("AnimationController"), 1, "Browcoatanim", {Weight = 2, Fade = .15})
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