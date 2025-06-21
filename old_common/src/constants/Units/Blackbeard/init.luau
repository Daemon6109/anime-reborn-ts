local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Darkbeard" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Dark Void"},
	Damage = 95 :: number,
	AttackSpeed = 9 :: number,
	Range = 15 :: number,
	Ability = "Vortex" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Slow", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 120,
			AttackSpeed = 9,
			Range = 16,
			UpgradePrice = 1350,
		},
		[2] = {
			Damage = 135,
			AttackSpeed = 8.5,
			Range = 17,
			UpgradePrice = 1800,
		},
		[3] = {
			Damage = 150,
			AttackSpeed = 8.5,
			Range = 18,
			UpgradePrice = 2400,
		},
		[4] = {
			Damage = 190,
			AttackSpeed = 8.5,
			Range = 19,
			UpgradePrice = 3000,
		},
		[5] = {
			Damage = 220,
			AttackSpeed = 8,
			Range = 20,
			UpgradePrice = 4800,
		},
		[6] = {
			Damage = 270,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 6200,
			AttackEffectDuration = 8,
			Ability = "Black Hole",
			AttackType = "Full",
		},
		[7] = {
			Damage = 320,
			AttackSpeed = 7.5,
			Range = 23,
			UpgradePrice = 7300,
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
	idle = "124214532787267",
	walk = "17264216432",
	cape = "103195226449249",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	if unit:HasTag("RegularModel") then
		local AnimModule = require(game.ReplicatedStorage.AnimModule)

		AnimModule.PlayCustomAnim(Unit.animations.cape, unit:WaitForChild("cape"):WaitForChild("AnimationController"), 1, "CapeAnim", {Weight = 2, Fade = .15})
	end
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit