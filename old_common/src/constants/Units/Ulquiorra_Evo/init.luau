local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.ShinyTradable = true
Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Olkuiorra [Resurrection]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2250 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"True Despair", "Emptiness"},
	Damage = 1300 :: number,
	AttackSpeed = 13 :: number,
	Range = 19 :: number,
	Ability = "Bat Slash" :: string, -- starting ability
	SpecialAbility = "Ulq Destruction" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 18 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1375,
			AttackSpeed = 12.5,
			Range = 23,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1687.5,
			AttackSpeed = 12,
			Range = 23,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 2500,
			AttackSpeed = 12,
			Range = 25,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 3625,
			AttackSpeed = 11.5,
			Range = 28,
			UpgradePrice = 6500,
			AttackType = "Circle",
			Ability = "Thunder Spear",
			AttackSize = 18,
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 4650,
			AttackSpeed = 11.5,
			Range = 30,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 4875,
			AttackSpeed = 11,
			Range = 30,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 5250,
			AttackSpeed = 10.5,
			Range = 30,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 6000,
			AttackSpeed = 10.5,
			Range = 32,
			UpgradePrice = 12750,
		},
		[9] = {
			Damage = 7000,
			AttackSpeed = 7.3,
			Range = 32,
			UpgradePrice = 15555,
			AttackType = "Line",
			Ability = "Dark Zero",
			AttackSize = 32,
		},
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "133148731404245", --"115626504370471",
	walk = "17264216432",
	wing1 = "100030717921366",
	wing2 = "91269408874621"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.wing1, unit:WaitForChild("wing1"):WaitForChild("AnimationController"), 1, "wing1anim", {Weight = 2, Fade = .15})
			end)
		end)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.wing2, unit:WaitForChild("wing2"):WaitForChild("AnimationController"), 1, "wing2anim", {Weight = 2, Fade = .15})
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