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
	DisplayName = "Yoshina" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1200 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Ice Blessing"},
	Damage = 640 :: number,
	AttackSpeed = 5 :: number,
	Range = 20 :: number,
	Ability = "Ice Tornado" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 12 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Easter Bunny"] = 1,

					["RainbowStar"] = 4,
					["RedStar"] = 14,
					["PurpleStar"] = 14,
					["GreenStar"] = 14,
					["BlueStar"] = 14,
					["OrangeStar"] = 20,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 5000;

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

			EvolvesInto = "Yoshina [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 960,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1070,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 1150,
			AttackSpeed = 4.5,
			Range = 23,
			UpgradePrice = 4500,
		},
		[4] = {
			Damage = 1240,
			AttackSpeed = 4.5,
			Range = 25,
			UpgradePrice = 5650,
		},
		[5] = {
			Damage = 1280,
			AttackSpeed = 4.5,
			Range = 25,
			UpgradePrice = 6000,
			Ability = "Ice Barrage",
			AttackType = "Cone",
			AttackSize = 15.5, 
		},
		[6] = {
			Damage = 1350,
			AttackSpeed = 4,
			Range = 30,
			UpgradePrice = 6250,
		},
		[7] = {
			Damage = 1500,
			AttackSpeed = 4,
			Range = 34,
			UpgradePrice = 6500,
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
	idle = "127524251906511",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit