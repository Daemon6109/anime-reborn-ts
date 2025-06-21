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
	MaxPlacementAmount = 4 :: number,
	MaxUpgrades = 7 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Roben" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Cien Fleur Bind"},
	Damage = 850 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Flower Fall" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 1.5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Easter Shades"] = 1,

					["RainbowStar"] = 2,
					["RedStar"] = 10,
					["PurpleStar"] = 10,
					["GreenStar"] = 10,
					["BlueStar"] = 10,
					["OrangeStar"] = 10,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 3000;

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

			EvolvesInto = "Robin [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 900,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 1140,
		},
		[2] = {
			Damage = 1000,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 1620,
		},
		[3] = {
			Damage = 1080,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2000,
		},
		[4] = {
			Damage = 1150,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 3260,
		},
		[5] = {
			Damage = 1500,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 4640,
			Ability = "Crushing Fall",
			AttackType = "Circle",
			AttackSize = 18,
		},
		[6] = {
			Damage = 1750,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 7690,
		},
		[7] = {
			Damage = 2000,
			AttackSpeed = 6,
			Range = 34,
			UpgradePrice = 9000,
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
	idle = "96744903996219",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit