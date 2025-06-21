local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Toboramo" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1475 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 335 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 17 :: number,
	Ability = "Flying Raijin" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["WaterArmor"] = 1,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+20% Damage";
			"+1 New Active: Water Dragon";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Tobirama [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 425,
			AttackSpeed = 6.5,
			Range = 19,
			UpgradePrice = 2700,
		},
		[2] = {
			Damage = 500,
			AttackSpeed = 6.5,
			Range = 21,
			UpgradePrice = 3600,
		},
		[3] = {
			Damage = 635,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 4800,
		},
		[4] = {
			Damage = 750,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 6000,
		},
		[5] = {
			Damage = 828,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 6847,
			
			AttackType = "Circle",
			Ability = "Shadow Clones",
			AttackSize = 11,
		},
		[6] = {
			Damage = 1000,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 7500,
		},
		[7] = {
			Damage = 1350,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 8466,
		},
		[8] = {
			Damage = 1750,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 10100,
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
	idle = "110027366394128",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit