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
	DisplayName = "Sabur" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1600 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Combo"},
	Damage = 225 :: number,
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
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["Saber"] = 1;
				["RainbowStar"] = 3,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			EliminationsRequired = 7500;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+25% Damage";
			"+1 New Special Move: `Holy Sword: Excalibur`";
			"+1 New Passive: Christmas Magic";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Saber Alter [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 275,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 340,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 425,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 520,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 4200,
			
			Ability = "Present Crash",
			AttackType = "Full",
			AttackSize = 6
		},
		[5] = {
			Damage = 670,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5275,
		},
		[6] = {
			Damage = 765,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5900,
		},
		[7] = {
			Damage = 900,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 7100,
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