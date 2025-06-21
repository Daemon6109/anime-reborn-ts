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
	DisplayName = "Adult Bell" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1250 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Ihigoooo!", "Cero Doble"},
	Damage = 1562.5 :: number,
	AttackSpeed = 13 :: number,
	Range = 20 :: number,
	Ability = "Cero Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 19 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1812.5,
			AttackSpeed = 12.5,
			Range = 22,
			UpgradePrice = 2350,
		},
		[2] = {
			Damage = 2062.5,
			AttackSpeed = 12,
			Range = 23,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 2125,
			AttackSpeed = 12,
			Range = 25,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 2500,
			AttackSpeed = 11.5,
			Range = 28,
			UpgradePrice = 6100,
			AttackType = "Circle",
			AttackSize = 25,
			Ability = "Lance Throw",
		},
		[5] = {
			Damage = 3075,
			AttackSpeed = 11.5,
			Range = 32,
			UpgradePrice = 7250,
		},
		[6] = {
			Damage = 3300,
			AttackSpeed = 11.5,
			Range = 35,
			UpgradePrice = 7250,
		},
		[7] = {
			Damage = 3525,
			AttackSpeed = 11,
			Range = 37,
			UpgradePrice = 7500,
		},
		[8] = {
			Damage = 4500,
			AttackSpeed = 9,
			Range = 38,
			AttackType = "Line",
			AttackSize = 38,
			Ability = "Cero Blast",
			UpgradePrice = 9500,
		},
		[9] = {
			Damage = 5000,
			AttackSpeed = 8.5,
			Range = 42,
			UpgradePrice = 10000,
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
	idle = "81835154824610",
	walk = "17264216432",
	jawwww = "86328237844260"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.jawwww, unit:WaitForChild("jawwww"):WaitForChild("AnimationController"), 1, "wing1anim", {Weight = 2, Fade = .15})
			end)
		end)
	end)
	--print("animated")
end

function Unit:onPlace(plr, unit)
	unit:PivotTo(unit.PirmaryPart.CFrame * CFrame.new(0, 5, 0))
end

function Unit:onDelete(plr, unit)
end

return Unit