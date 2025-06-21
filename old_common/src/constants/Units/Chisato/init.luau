local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.08, .1, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Chisota" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 999 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Swift Revenge I"},
	Damage = 500 :: number,
	AttackSpeed = 7 :: number,
	Range = 16 :: number,
	Ability = "Gunshots" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 10,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
					['BowTie'] = 1, -- New Evo Item
					["RainbowStar"] = 1,
					["BlueStar"] = 2,
					["OrangeStar"] = 5,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Grenade";
			"+1 Upgraded Passive: Swift Revenge II"
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Chisato [Evo]" :: string; -- The unit to evolve into
	 	}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 1890,
		},
		[2] = {
			Damage = 1075,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 2750,
		},
		[3] = {
			Damage = 1200,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 3660,
		},
		[4] = {
			Damage = 1470,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 5000,
			
			Ability = "Air Bullets",
			AttackSize = 8,
			AttackType = "Circle",
		},
		[5] = {
			Damage = 1600,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 6800,
		},
		[6] = {
			Damage = 1866,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 8000,
		},
		[7] = {
			Damage = 2240,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 9500,
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
	idle = "128513756013703",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit