local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Itachi"
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Itaha [Bushi]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1950 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Burning Carnage II"},
	Damage = 188 :: number,
	AttackSpeed = 8 :: number,
	Range = 14 :: number,
	Ability = "Fireball Jutsu" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Dark Flames",
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 250,
			AttackSpeed = 7.5,
			Range = 15.5,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 313,
			AttackSpeed = 7.3,
			Range = 17,
			UpgradePrice = 3250,
			AttackType = "Circle",
			Ability = "Amaterasu",
			AttackSize = 10,
			UnitType = "Hybrid",
		},
		[3] = {
			Damage = 413,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 4350,
		},
		[4] = {
			Damage = 475,
			AttackSpeed = 7.5,
			Range = 19.5,
			UpgradePrice = 4500,
		},
		[5] = {
			Damage = 600,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 6200,
		},
		[6] = {
			Damage = 750,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 7200,
			AttackType = "Cone",
			Ability = "Incomplete Susanoo",
			AttackSize = 16,
		},
		[7] = {
			Damage = 913,
			AttackSpeed = 6.5,
			Range = 23.5,
			UpgradePrice = 10500,
		},
		[8] = {
			Damage = 1000,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 12500,
			AttackType = "Circle",
			Ability = "Susanoo",
			AttackSize = 15,
		},
		[9] = {
			Damage = 1350,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 15000,
			AttackType = "Line",
			Ability = "Fire Slash",
			AttackSize = 9,
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
	idle = "122728041508090",
	walk = "17264216432",
	hair = "126045946928418",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	
	AnimModule.PlayCustomAnim(Unit.animations.hair, unit:WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit