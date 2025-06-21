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
	DisplayName = "Payne" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Gravity Force I"},
	Damage = 160 :: number,
	AttackSpeed = 9 :: number,
	Range = 18 :: number,
	Ability = "Rockets" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "",
	AttackEffectDuration = 6,
	AttackEffectDurationFromPassive = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["Naruto"] = 40,
				["DarkStone"] = 30,
				["ChakraRod"] = 12;
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+25% Damage";
			"+1 New Move: Chibaku Tensei";
			"+1 New Passive: Gravity Force II";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Pain [Chibaku]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 200,
			AttackSpeed = 9,
			Range = 20,
			UpgradePrice = 2300,
		},
		[2] = {
			Damage = 245,
			AttackSpeed = 8.5,
			Range = 22,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 300,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 340,
			AttackSpeed = 8,
			Range = 23,
			UpgradePrice = 4700,
		},
		[5] = {
			Damage = 400,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 5750,
		},
		[6] = {
			Damage = 500,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 7500,
			AttackType = "Full",
			Ability = "Shinra Tensei",
			UnitType = "Hybrid",
		},
		[7] = {
			Damage = 570,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 9200,
		},
		[8] = {
			Damage = 625,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 9700,
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
	idle = "105237950545381",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit