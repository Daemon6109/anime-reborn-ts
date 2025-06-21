local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Rimuru"
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 9 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Lord Rimura" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Soul Absorption", "Demon Lord"},
	Damage = 240 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Dark Lightning" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 300,
			AttackSpeed = 5.5,
			Range = 16,
			UpgradePrice = 2600,
		},
		[2] = {
			Damage = 336,
			AttackSpeed = 5,
			Range = 17,
			UpgradePrice = 3650,
		},
		[3] = {
			Damage = 360,
			AttackSpeed = 4.5,
			Range = 18,
			UpgradePrice = 4400,
		},
		[4] = {
			Damage = 600,
			AttackSpeed = 6,
			Range = 19,
			Ability = "Hell Blaze",
			UpgradePrice = 5550,
		},
		[5] = {
			Damage = 720,
			AttackSpeed = 5.5,
			Range = 20,
			UpgradePrice = 6850,
		},
		[6] = {
			Damage = 960,
			AttackSpeed = 9,
			Range = 25,
			Ability = "Gluttony",
			AttackType = "Cone",
			AttackSize = 26,
			UpgradePrice = 10750,
			UnitType = "Hybrid",
		},
		[7] = {
			Damage = 1200,
			AttackSpeed = 9,
			Range = 26,
			UpgradePrice = 13650,
		},
		[8] = {
			Damage = 1620,
			AttackSpeed = 9,
			Range = 27,
			SpecialAbility = "God's Wrath: Meggido",
			UpgradePrice = 21000,
		},
		[9] = {
			Damage = 2250,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 28650,
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
	idle = "140157254130495",
	walk = "17264216432",
	shinycape = "82843659526159",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	if unit:HasTag("ShinyModel") then
		print("customized rimuru")
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		
		AnimModule.PlayCustomAnim(Unit.animations.shinycape, unit:WaitForChild("Cape"):WaitForChild("AnimationController"), 1, "CapeAnim", {Weight = 2, Fade = .15})
		print("rimuru2")
	end
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit