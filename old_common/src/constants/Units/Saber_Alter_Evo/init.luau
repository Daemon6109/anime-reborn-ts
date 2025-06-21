local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Saber Alter"

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Sabur [EX-Phantasm]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1600 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Combo", "Christmas Magic"},
	Damage = 281 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Present Delivery" :: string, -- starting ability
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

	--	EvolvesInto = "Ragna [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 343,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 425,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 531,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 650,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 4200,
			
			Ability = "Present Crash",
			AttackType = "Full",
			AttackSize = 6
		},
		[5] = {
			Damage = 837,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5275,
		},
		[6] = {
			Damage = 956,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5900,
		},
		[7] = {
			Damage = 1125,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 7100,
		},
		[8] = {
			Damage = 1320,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 8500,
			
			SpecialAbility = "Holy Sword: Excalibur"
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
	idle = "94641008819552",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit