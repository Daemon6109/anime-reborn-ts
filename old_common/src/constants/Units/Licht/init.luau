local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Light" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Pure Light"},
	Damage = 170 :: number,
	AttackSpeed = 5 :: number,
	Range = 19 :: number,
	Ability = "Light Sword" :: string, -- starting ability
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
	EvolveData = { -- If this exists, the unit will be evolvable
		
		[1] = {
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["LightGrimoire"] = 1,
				["LightSpear"] = 25,
				["Clover"] = 2,
				LightStone = 30,
				["MageStone"] = 40,
				["RainbowStar"] = 3,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};
			
			EliminationsRequired = 5000;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+25% Damage";
			"+1 New Passive: Light Summon";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Licht [Evo]" :: string; -- The unit to evolve into
		
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 240,
			AttackSpeed = 4.5,
			Range = 20,
			UpgradePrice = 2050,
		},
		[2] = {
			Damage = 310,
			AttackSpeed = 4.5,
			Range = 23,
			UpgradePrice = 2450,
		},
		[3] = {
			Damage = 400,
			AttackSpeed = 4,
			Range = 23,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 540,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 4250,
			
			Ability = "Light Sword Barrage",
			AttackType = "Line",
			AttackSize = 10,
		},
		[5] = {
			Damage = 650,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 4750,
		},
		[6] = {
			Damage = 700,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 1000,
			AttackSpeed = 8.5,
			Range = 24,
			UpgradePrice = 7500,
			
			Ability = "Arrows Of Judgement",
			AttackType = "Full",
			UnitType = "Hybrid",
			AttackSize = 1,
		},
		[8] = {
			Damage = 1450,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 8750,
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
	idle = "103922394288913",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit