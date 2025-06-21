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
	DisplayName = "Cho Heo In [SS]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1740 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Critical Overdrive"},
	Damage = 875 :: number,
	AttackSpeed = 6 :: number,
	Range = 19 :: number,
	Ability = "Slashing Combo" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.5,
	AttackCriticalDamage = 0.3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 925,
			AttackSpeed = 6,
			Range = 19,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1062.5,
			AttackSpeed = 5.5,
			Range = 20,
			UpgradePrice = 4100,
		},
		[3] = {
			Damage = 1562.5,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 5500,
		},
		[4] = {
			Damage = 1875,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 7000,
			AttackType = "Cone",
			AttackSize = 27,
			Ability = "Quake of Provocation",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 2062.5,
			AttackSpeed = 9,
			Range = 28,
			AttackSize = 28,
			UpgradePrice = 15000,
		},
		[6] = {
			Damage = 2687.5,
			AttackSpeed = 4.5,
			Range = 29,
			AttackSize = 29,
			UpgradePrice = 9200,
		},
		[7] = {
			Damage = 2812.5,
			AttackSpeed = 4.5,
			Range = 29,
			UpgradePrice = 10680,
		},
		[8] = {
			Damage = 3125,
			AttackSpeed = 4.5,
			Range = 32,
			UpgradePrice = 12000,
			AttackType = "Cone",
			AttackSize = 32,
			Ability = "Sword of Light",
		},
		[9] = {
			Damage = 3500,
			AttackSpeed = 4,
			AttackSize = 36,
			Range = 36,
			UpgradePrice = 13750,
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
	idle = "124109483162475",
	walk = "17264216432",
	Lsomething = "84088711751133",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		pcall(function()
			if unit.Name ~= "ShinyModel" then return end
			local Lsomething = unit:WaitForChild("Lsomething", 15)
			if Lsomething then
				AnimModule.PlayCustomAnim(Unit.animations.Lsomething, Lsomething:WaitForChild("AnimationController"), 1, "Lsomething", {Weight = 2, Fade = .15})
			end
		end)
	end)
	--print("animated")
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit