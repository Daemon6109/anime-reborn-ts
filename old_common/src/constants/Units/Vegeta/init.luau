local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-0.1, .4, -1.4)*CFrame.Angles(0,math.rad(-180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Vegoto" :: string,
	Rarity = "Epic" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 450 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"No Limits"},
	Damage = 30 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Galick Gun" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 1.5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{

			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount

					["Prince Armor"] = 1,
					["Water Crystal"] = 20,

					["RainbowStar"] = 8,
					["RedStar"] = 8,
					["PurpleStar"] = 8,
					["GreenStar"] = 8,
					["BlueStar"] = 8,
					["OrangeStar"] = 8,

				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--EliminationsRequired = 7500;
				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+New Moves";
				"+New Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Vegeta [Evo]" :: string; -- The unit to evolve into

		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 65,
			Range = 15.5,
			AttackSpeed = 6;
			UpgradePrice = 800,
		},
		[2] = {
			Damage = 100,
			Range = 16,
			AttackSpeed = 6;
			UpgradePrice = 1100,
		},
		[3] = {
			Damage = 115,
			Range = 16.5,
			AttackSpeed = 6,
			UpgradePrice = 1800,
		},
		[4] = {
			Damage = 130,
			Range = 17,
			AttackSpeed = 6,
			UpgradePrice = 2300,
		},
		[5] = {
			Ability = "Lucora Gun",
			AttackSize = 7,
			Damage = 160,
			AttackType = "Circle",
			Range = 17.5,
			AttackSpeed = 5,
			UpgradePrice = 3000,
		}
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "112043809456767",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit