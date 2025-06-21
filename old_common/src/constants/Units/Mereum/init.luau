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
	DisplayName = "Bereum" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1200 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Genetic Perfection"},
	Damage = 100 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 30 :: number,
	Ability = "Formicidae Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
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
					["YinYang"] = 1,
					
					["BlueStar"] = 14,
					["GreenStar"] = 14,
					["RedStar"] = 14,
					["OrangeStar"] = 16,
					["PurpleStar"] = 14,
					["RainbowStar"] = 3,
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
			EvolvesInto = "Mereum [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 7.5,
			Range = 33,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 790,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 2450,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 3600,
		},
		[4] = {
			Damage = 950,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 4300,
			Ability = "King Cannon",
			AttackType = "Line",
			AttackSize = 14,
		},
		[5] = {
			Damage = 1000,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 5000,
		},
		[6] = {
			Damage = 1300,
			AttackSpeed = 6,
			Range = 36,
			UpgradePrice = 5450,
		},
		[7] = {
			Damage = 1500,
			AttackSpeed = 6,
			Range = 38,
			UpgradePrice = 6000,
			AttackSize = 16,
		},
		[8] = {
			Damage = 2150,
			AttackSpeed = 6,
			Range = 42,
			UpgradePrice = 6300,
			AttackSize = 18,
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
	idle = "74906617495182",
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