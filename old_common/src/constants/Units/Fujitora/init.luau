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
	MaxUpgrades = 7 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Gravity Mage" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Blindness"},
	Damage = 1259/2 :: number,
	AttackSpeed = 12/2 :: number,
	Range = 23/2 :: number,
	Ability = "Debris Cover" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Gravity Cane"] = 1,	
					
					["RainbowStar"] = 2,
					["OrangeStar"] = 10,

					["BlueStar"] = 12,
					["GreenStar"] = 12,
					["PurpleStar"] = 12,
					["RedStar"] = 12,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+New Attacks";
				"+Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Fujitora [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 2343.75 / 2,
			AttackSpeed = 12 / 2,
			Range = 24 / 2,
			UpgradePrice = 2650,
		},
		[2] = {
			Damage = 3125 / 2,
			AttackSpeed = 12 / 2,
			Range = 24 / 2,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 3781.25 / 2,
			AttackSpeed = 12 / 2,
			Range = 26 / 2,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 4687.5 / 2,
			AttackSpeed = 12 / 2,
			Range = 26 / 2,
			UpgradePrice = 5425,
		},
		[5] = {
			Damage = 5000 / 2,
			AttackSpeed = 12 / 2,
			Range = 27 / 2,
			UpgradePrice = 6450,
		},
		[6] = {
			Damage = 5250 / 2,
			AttackSpeed = 11 / 2,
			Range = 30,
			UpgradePrice = 7825,
			
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Meteor Strike",
		},
		[7] = {
			Damage = 5000 / 2,
			AttackSpeed = 10 / 2,
			Range = 31,
			UpgradePrice = 9480,
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
	idle = "115196154965429",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit