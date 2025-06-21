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
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Biren" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Inner Tactics"},
	Damage = 400 :: number,
	AttackSpeed = 6 :: number,
	Range = 23 :: number,
	Ability = "Justice Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{

			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount

					["Concentrated Blast"] = 1,
					["Fierce Crystal"] = 35,

					["RainbowStar"] = 13,
					["RedStar"] = 13,
					["PurpleStar"] = 13,
					["GreenStar"] = 13,
					["BlueStar"] = 13,
					["OrangeStar"] = 13,

				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--EliminationsRequired = 7500;
				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+New Moves";
				"+New Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Jiren [Evo]" :: string; -- The unit to evolve into

		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 700,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 900,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2820,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 3400,
		},
		[4] = {
			Damage = 1000,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 4000,
		},
		[5] = {
			Damage = 1050,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 5230,
		},
		[6] = {
			Damage = 1300,
			AttackSpeed = 5,
			Range = 30,
			UpgradePrice = 6000,
			
			Ability = "Justice Barrage",
			AttackType = "Circle",
			AttackSize = 14,
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[7] = {
			Damage = 1750,
			AttackSpeed = 5,
			Range = 31,
			UpgradePrice = 6400,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "133039843609864",
	EvoIdle = "111457696065004",
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