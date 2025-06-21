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
	DisplayName = "Birko" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1300 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Critical Claw"},
	Damage = 700 :: number,
	AttackSpeed = 7 :: number,
	Range = 25 :: number,
	Ability = "Luna Spin" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Emu Book"] = 1,

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

			EvolvesInto = "Mirko [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 800,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 1810,
		},
		[2] = {
			Damage = 950,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 2260,
		},
		[3] = {
			Damage = 1230,
			AttackSpeed = 6.5,
			Range = 28,
			UpgradePrice = 3330,
		},
		[4] = {
			Damage = 1400,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 3950,
		},
		[5] = {
			Damage = 1650,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 4660,
			Ability = "Luna Kick",
			AttackType = "Circle",
			AttackSize = 18, 
		},
		[6] = {
			Damage = 1800,
			AttackSpeed = 6,
			Range = 32,
			UpgradePrice = 5750,
		},
		[7] = {
			Damage = 2000,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 8950,
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
	idle = "90387247750986",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit