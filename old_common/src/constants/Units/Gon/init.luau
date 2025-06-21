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
	DisplayName = "Bon" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Reckless Courage"},
	Damage = 100 :: number,
	AttackSpeed = 8 :: number,
	Range = 20 :: number,
	Ability = "Jajaken Rock" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
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
					["Fish Stick"] = 1,

					["BlueStar"] = 18,
					["GreenStar"] = 18,
					["RedStar"] = 18,
					["OrangeStar"] = 20,
					["PurpleStar"] = 18,
					["RainbowStar"] = 4,
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
			EvolvesInto = "Gon [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 7.5,
			Range = 22,
			UpgradePrice = 1750,
		},
		[2] = {
			Damage = 790,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 2350,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 950,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 3350,
			
			Ability = "Jajaken Paper",
			AttackType = "Circle",
			AttackSize = 14, 
			
			UnitType = "Hybrid"
		},
		[5] = {
			Damage = 1000,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 4000,
		},
		[6] = {
			Damage = 1300,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 4650,
		},
		[7] = {
			Damage = 1500,
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 6200,
		},
		[8] = {
			Damage = 1750,
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 7500,
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
	idle = "124432889455195",
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