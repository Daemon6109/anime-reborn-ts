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
	MaxPlacementAmount = 1 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Metal" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1570 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 880 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Warhammer Smash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 16 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					["BlueStar"] = 7,
					["GreenStar"] = 7,
					["RedStar"] = 7,
					["OrangeStar"] = 7,
					["PurpleStar"] = 7,
					["RainbowStar"] = 1,
					["Iron Axe"] = 1,
					--["ManaCrystals"] = 250
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};
				
				EliminationsRequired = 1500;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+War Scream";
				"+Passive: Enhanced Durability!"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Iron [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 1280,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 2350,
		},
		[2] = {
			Damage = 1750,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 2000,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 4950,
		},
		[4] = {
			Damage = 2550,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 6100,
			AttackType = "Line",
			AttackSize = 15,
			Ability = "Rampage",
			
		},
		[5] = {
			Damage = 2900,
			AttackSpeed = 6,
			Range = 32,
			UpgradePrice = 7250,
		},
		[6] = {
			Damage = 3285,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 9000,
		},
		[7] = {
			Damage = 3620,
			AttackSpeed = 6,
			Range = 37,
			UpgradePrice = 10250,
		},
		[8] = {
			Damage = 3890,
			AttackSpeed = 7,
			Range = 38,
			UpgradePrice = 11500,		
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
	idle = "114908875863789",
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