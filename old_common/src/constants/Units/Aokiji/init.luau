local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Aokojo" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1870 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Ice Breaker"},
	Damage = 175 :: number,
	AttackSpeed = 4 :: number,
	Range = 16 :: number,
	Ability = "Suffocation" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["IceFruit"] = 1,
				["RainbowStar"] = 1,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			EliminationsRequired = 0;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+25% Damage";
			"+1 New Passive: Ice Spears";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Aokiji [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 255,
			AttackSpeed = 4,
			Range = 18,
			UpgradePrice = 2450,
		},
		[2] = {
			Damage = 270,
			AttackSpeed = 4,
			Range = 20,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 340,
			AttackSpeed = 4,
			Range = 22,
			UpgradePrice = 4760,
		},
		[4] = {
			Damage = 400,
			AttackSpeed = 4,
			Range = 22,
			UpgradePrice = 4500,
			
			AttackType = "Circle",
			Ability = "Ice Ball",
			AttackSize = 10,
		},
		[5] = {
			Damage = 470,
			AttackSpeed = 4,
			Range = 24,
			UpgradePrice = 5250,
		},
		[6] = {
			Damage = 520,
			AttackSpeed = 4,
			Range = 25,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 655,
			AttackSpeed = 4.5,
			Range = 25,
			UpgradePrice = 7400,
			
			UnitType = "Hybrid",
		},
		[8] = {
			Damage = 840,
			AttackSpeed = 4.5,
			Range = 26,
			UpgradePrice = 8500,
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
	idle = "129945398427940",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit