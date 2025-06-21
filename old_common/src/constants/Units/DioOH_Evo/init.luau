local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "DioOH"

Unit.configuration = {
	CameraOffset = CFrame.new(0,-.15,.05),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, -1, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -1, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, -1, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Io from Heaven [Perfection]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 8150 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Heaven's Scar", "Perfect Scar"},
	Damage = 625 :: number,
	AttackSpeed = 8 :: number,
	Range = 21 :: number,
	Ability = "Dark Matter" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 9 :: Enums.AttackSizeTypes,
	AttackEffect = "DioScar", --effects that applies on the enemy when attacked
	AttackEffectDuration = 4,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["BlueStar"] = 10,
	--			["GreenStar"] = 10,
	--			["OrangeStar"] = 10,
	--			["PurpleStar"] = 10,
	--			["RedStar"] = 10,
	--			["Cupcake"] = 15;
	--			["RainbowStar"] = 2,
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};
		
	--	DisplayBuffs = {
	--		"+25% Damage";
	--		"+1 New Move: Death Ball";
	--		"+1 New Passive: Together we shine";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "DioOH [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 7.5,
			Range = 21,
			UpgradePrice = 6500,
		},
		[2] = {
			Damage = 862,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 8000,
			
			Ability = "Barrage",
			AttackSize = 10,
			AttackType = "Circle",
		},
		[3] = {
			Damage = 1125,
			AttackSpeed = 7,
			Range = 24,
			UpgradePrice = 8700,
		},
		[4] = {
			Damage = 1312,
			AttackSpeed = 6.5,
			Range = 24,
			UpgradePrice = 9450,
			
			Ability = "Pummel",
			AttackSize = 15,
			AttackType = "Circle",
		},
		[5] = {
			Damage = 1550,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 10500,
		},
		[6] = {
			Damage = 2187,
			AttackSpeed = 7.5,
			Range = 26,
			UpgradePrice = 11750,
			
			UnitType = "Hybrid",
			
			Ability = "Lightning Arc",
			AttackSize = 10,
			AttackType = "Line",
		},
		[7] = {
			Damage = 2375,
			AttackSpeed = 7.5,
			Range = 27,
			UpgradePrice = 15000,
		},
		[8] = {
			Damage =  2875,
			AttackSpeed = 6.5,
			Range = 30,
			UpgradePrice = 17500,
		},
		[9] = {
			Damage =  4750,
			AttackSpeed = 9,
			Range = 34,
			UpgradePrice = 25000,
			
			SpecialAbility = "Heavens: Time Stop",

			Ability = "Heavenly Punishment",
			AttackSize = 22,
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
	idle = "139461745012713",
	walk = "100632493399938",
	diowalk = "100632493399938",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local animController = unit.DIO.AnimationController
	local animController2 = unit.DIO["Dio stand"].AnimationController

	AnimModule.PlayCustomAnim(Unit.animations.idle, animController, 1, "Idle", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim(Unit.animations.idle, animController2, .4, "Idle", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit