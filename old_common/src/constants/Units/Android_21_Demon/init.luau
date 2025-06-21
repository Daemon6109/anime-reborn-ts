local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Android 21"
Unit.Tradable = false
Unit.ShinyTradable = true
Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Twenty One [Demon]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1950 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Natural Vision", "Together we shine"},
	Damage = 238 :: number,
	AttackSpeed = 5 :: number,
	Range = 18 :: number,
	Ability = "Demonic Ki Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 338,
			AttackSpeed = 4.5,
			Range = 20.5,
			UpgradePrice = 2100,
		},
		[2] = {
			Damage = 413,
			AttackSpeed = 4,
			Range = 21,
			UpgradePrice = 2600,
		},
		[3] = {
			Damage = 500,
			AttackSpeed = 3.5,
			Range = 23,
			UpgradePrice = 3300,
		},
		[4] = {
			Damage = 594,
			AttackSpeed = 3.5,
			Range = 24.5,
			UpgradePrice = 3800,
		},
		[5] = {
			Damage = 688,
			AttackSpeed = 9, 
			Range = 26,
			UpgradePrice = 7500,
			Ability = "Raging Ki Explosion",
			AttackType = "Full",
		},
		[6] = {
			Damage = 775,
			AttackSpeed = 9,
			Range = 26,
			UpgradePrice = 9600,
		},
		[7] = {
			Damage = 988,
			AttackSpeed = 9,
			Range = 27,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 1169,
			AttackSpeed = 8.5,
			Range = 27,
			UpgradePrice = 13000,
		},
		[9] = {
			Damage = 1950,
			AttackSpeed = 8,
			Range = 37,
			UpgradePrice = 13500,
			Ability = "Death Ball",
			AttackSize = 20,
			AttackType = "Circle",
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
	idle = "18172212518",
	walk = "17264216432",
	tail = "18172214963",
	hair = "18172209224",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	
	AnimModule.PlayCustomAnim(Unit.animations.tail, unit:WaitForChild("cloths"):WaitForChild("untitled"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim(Unit.animations.hair, unit:WaitForChild("cloths"):WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
	--print("animated")
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit