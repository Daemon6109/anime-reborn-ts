local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, 0.25, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .95, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,

	CameraOffset = CFrame.new(0,-.55,1),
	
	MaxPlacementAmount = 1 :: number,
	MaxUpgrades = 9 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Coyote [Resurrection]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Wolf Pack", "Metralleta"},
	Damage = 1250 :: number,
	AttackSpeed = 11 :: number,
	Range = 18 :: number,
	Ability = "Cero" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 18 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1562.5,
			AttackSpeed = 10.5,
			Range = 21,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1687.5,
			AttackSpeed = 10,
			Range = 21,
			UpgradePrice = 2750,
		},
		[3] = {
			Damage = 1875,
			AttackSpeed = 10,
			Range = 23,
			UpgradePrice = 3200,
		},
		[4] = {
			Damage = 2250,
			AttackSpeed = 9,
			Range = 24,
			UpgradePrice = 5100,
			Ability = "Coyote Rampage",
			AttackType = "Circle",
			AttackSize = 24,

			
		},
		[5] = {
			Damage = 2312.5,
			AttackSpeed = 8.5,
			Range = 24,
			UpgradePrice = 6000,
			
		},
		[6] = {
			Damage = 2375,
			AttackSpeed = 8.5,
			Range = 24,
			UpgradePrice = 7250,
		},
		[7] = {
			Damage = 2750,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 8500,
		},
		[8] = {
			Damage = 3750,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 11000,
			Ability = "Materella",
			AttackType = "Line",
			AttackSize = 28,
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[9] = {
			Damage = 6350,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 12800,
		},
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "76261233703804",
	walk = "17264216432",
	cloack = "74305773003243"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.cloack, unit:WaitForChild("cloack"):WaitForChild("AnimationController"), 1, "wing1anim", {Weight = 2, Fade = .15})
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