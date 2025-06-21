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
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 7 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "VzazcheEnul" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Celestial Beacon"},
	Damage = 900 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Magic Edge" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Vyasche Item"] = 1,

					["RainbowStar"] = 4,
					["RedStar"] = 14,
					["PurpleStar"] = 14,
					["GreenStar"] = 14,
					["BlueStar"] = 14,
					["OrangeStar"] = 20,
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
				"+Passive";
				"+New Moves"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "VyascheEmul [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 950,
			AttackSpeed = 7.5,
			Range = 33,
			UpgradePrice = 1750,
		},
		[2] = {
			Damage = 1030,
			AttackSpeed = 7.5,
			Range = 33,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 1120,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 1200,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 3350,
		},
		[5] = {
			Damage = 1560,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 4000,
			Ability = "Bunny Refinement",
			AttackType = "Circle",
			AttackSize = 24,
		},
		[6] = {
			Damage = 1780,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 4650,
		},
		[7] = {
			Damage = 2100,
			AttackSpeed = 6.5,
			Range = 37,
			UpgradePrice = 6200,
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
	idle = "121870689982011",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit