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
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Goora" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Scarlet Retribution"},
	Damage = 800 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "Chain Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 2,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					["KuraWeaponChains"] = 1,
					
					["BlueStar"] = 8,
					["GreenStar"] = 8,
					["RedStar"] = 8,
					["OrangeStar"] = 10,
					["PurpleStar"] = 8,
					["RainbowStar"] = 2,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};
				
				EliminationsRequired = 3000;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+Damage Increased";
				"+New Moves",
				"+New Passives"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Kurapika [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 900,
			AttackSpeed = 7,
			Range = 19,
			UpgradePrice = 1810,
		},
		[2] = {
			Damage = 1060,
			AttackSpeed = 6.5,
			Range = 21,
			UpgradePrice = 2260,
		},
		[3] = {
			Damage = 1140,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2830,
		},
		[4] = {
			Damage = 1270,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 3530,
			AttackType = "Cone",
			AttackSize = 25,
			Ability = "Chain Slam",
		},
		[5] = {
			Damage = 1430,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 3840,
		},
		[6] = {
			Damage = 1600,
			AttackSpeed = 6,
			Range = 27,
			AttackSize = 27,
			UpgradePrice = 4460,
		},
		[7] = {
			Damage = 1850,
			AttackSpeed = 5.5,
			Range = 28,
			AttackSize = 28,
			UpgradePrice = 5370,
		},
		[8] = {
			Damage = 2000,
			AttackSpeed = 5.5,
			Range = 29,
			AttackSize = 29,
			UpgradePrice = 6850,
		}
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "94919223014922",
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