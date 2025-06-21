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
	DisplayName = "Kuzar" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Devil of Light"},
	Damage = 75 :: number,
	AttackSpeed = 5 :: number,
	Range = 15 :: number,
	Ability = "Light Saber" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 90,
			AttackSpeed = 5,
			Range = 17,
			UpgradePrice = 1250,
		},
		[2] = {
			Damage = 100,
			AttackSpeed = 5,
			Range = 19,
			UpgradePrice = 1900,
		},
		[3] = {
			Damage = 115,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 2150,
		},
		[4] = {
			Damage = 175,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 2600,
		},
		[5] = {
			Damage = 200,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 3500,
			AttackType = "Cone",
			AttackSize = 20,
			Ability = "Light Pistol",
			UnitType = "Hybrid",
		},
		[6] = {
			Damage = 250,
			AttackSpeed = 6,
			Range = 23.5,
			UpgradePrice = 5500,
		},
		[7] = {
			Damage = 280,
			AttackSpeed = 5,
			Range = 26,
			UpgradePrice = 6500,
			Ability = "Light Jewels",
			AttackType = "Circle",
			AttackSize = 12,
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
	idle = "129713725373376",
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