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
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Ruki" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Below Zero"},
	Damage = 85 :: number,
	AttackSpeed = 7 :: number,
	Range = 15 :: number,
	Ability = "Sleeved White Snow" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "Frozen", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 100,
			AttackSpeed = 7,
			Range = 16,
			UpgradePrice = 850,
		},
		[2] = {
			Damage = 120,
			AttackSpeed = 7,
			Range = 17,
			UpgradePrice = 1000,
		},
		[3] = {
			Damage = 135,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 1200,
		},
		[4] = {
			Damage = 185,
			AttackSpeed = 7,
			Range = 19,
			UpgradePrice = 2300,
			AttackType = "Circle",
			AttackSize = 7,
			Ability = "White Ripple",
		},
		[5] = {
			Damage = 220,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 3000,
		},
		[6] = {
			Damage = 280,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 5200,
		},
		[7] = {
			Damage = 340,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 6000,
			Ability = "White Moon",
			AttackType = "Line",
			AttackSize = 5,
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
	idle = "115660336622724",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	--local AnimModule = require(game.ReplicatedStorage.AnimModule)
	--local Animations = script.Animations

	--AnimModule.PlayCustomAnim(Animations["Hair"], unit:WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit