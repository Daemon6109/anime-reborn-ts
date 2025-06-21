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
	MaxPlacementAmount = 5 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 7 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Lumi" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 3400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Mind Control Mastery"},
	Damage = 300 :: number,
	AttackSpeed = 9.5 :: number,
	Range = 18 :: number,
	Ability = "Needle Throw" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 18 :: Enums.AttackSizeTypes,
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
					["Divine Nail"] = 1,
					
					["BlueStar"] = 8,
					["GreenStar"] = 8,
					["RedStar"] = 8,
					["OrangeStar"] = 10,
					["PurpleStar"] = 8,
					["RainbowStar"] = 1,
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
			EvolvesInto = "Illumi [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 400,
			AttackSpeed = 9,
			Range = 20,
			AttackSize = 20,
			UpgradePrice = 1200,
		},
		[2] = {
			Damage = 800,
			AttackSpeed = 8.5,
			Range = 22,
			AttackSize = 22,
			UpgradePrice = 1750,
		},
		[3] = {
			Damage = 1300,
			AttackSpeed = 7.5,
			Range = 23,
			AttackSize = 23,
			UpgradePrice = 2330,
		},
		[4] = {
			Damage = 1700,
			AttackSpeed = 7,
			Range = 25,
			AttackSize = 25,
			UpgradePrice = 2970,
		},
		[5] = {
			Damage = 2000,
			AttackSpeed = 7,
			Range = 30,
			AttackSize = 30,
			UpgradePrice = 3670,
		},
		[6] = {
			Damage = 2200,
			AttackSpeed = 6.5,
			Range = 32,
			AttackSize = 32,
			UpgradePrice = 5230,
		},
		[7] = {
			Damage = 2250,
			AttackSpeed = 6.5,
			Range = 34,
			AttackSize = 34,
			UpgradePrice = 6750,
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
	idle = "113133337470237",
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