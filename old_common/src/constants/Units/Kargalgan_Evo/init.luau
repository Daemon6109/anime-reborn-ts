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
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Tusk [Commander]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1650 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Hymn of Fate"},
	Damage = 625 :: number,
	AttackSpeed = 11 :: number,
	Range = 20 :: number,
	Ability = "Chant of Blazing Fire" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Ocre Skull"] = 1,
					--["TuskMask"] = 1,
					["RainbowStar"] = 1,
					["RedStar"] = 2,
					["PurpleStar"] = 2,
					["GreenStar"] = 2,
					["OrangeStar"] = 10,
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
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Kargalgan [Evo2]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 625,
			AttackSpeed = 11,
			Range = 20,
			UpgradePrice = 1650,
		},
		[2] = {
			Damage = 1250,
			AttackSpeed = 11,
			Range = 20,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 1562.5,
			AttackSpeed = 11,
			Range = 22,
			UpgradePrice = 3650,
		},
		[4] = {
			Damage = 1875,
			AttackSpeed = 11,
			Range = 23,
			UpgradePrice = 4500,
			AttackType = "Full",
			AttackSize = 15,
			Ability = "Chant of Giants",
		},
		[5] = {
			Damage = 2500,
			AttackSpeed = 10.5,
			Range = 25,
			UpgradePrice = 6000,
		},
		[6] = {
			Damage = 2875,
			AttackSpeed = 10.5,
			Range = 30,
			UpgradePrice = 7500,
		},
		[7] = {
			Damage = 3125,
			AttackSpeed = 10.5,
			Range = 32,
			UpgradePrice = 9000,
		},
		[8] = {
			Damage = 3312.5,
			AttackSpeed = 10,
			Range = 34,
			UpgradePrice = 10500,
		},
		[9] = {
			Damage = 3750,
			AttackSpeed = 9,
			Range = 35,
			UpgradePrice = 12200,
		
		},
		[10] = {
			Damage = 4000,
			AttackSpeed = 7,
			Range = 41,
			UpgradePrice = 13500,
			AttackType = "Line",
			AttackSize = 25,
			Ability = "Chant of the Fire Dragon",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
	}

	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "98147474589165",
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