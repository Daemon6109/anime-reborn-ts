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
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Solo Woo [KING]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Arise", "Monarch's Domain"},
	Damage = 850 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Shadow Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					--["Dark Heart"] = 1,
					["Black Heart"] = 1,
					["RainbowStar"] = 5,
					["RedStar"] = 20,
					["PurpleStar"] = 20,
					["GreenStar"] = 20,
					["BlueStar"] = 20,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically
				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			EliminationsRequired = 3000;

			DisplayBuffs = {
				"+20% Damage";
				"+Passive: Black Heart"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Sung Jinwoo [Evo3]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1250,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1450,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 1800,
			AttackSpeed = 6.5,
			Range = 35,
			--UnitType = "Hybrid",
			UpgradePrice = 4850,
		},
		[4] = {
			Damage = 2800,
			AttackSpeed = 6,
			Range = 36,
			Ability = "Arise: Korgolgon",
			AttackType = "Circle",
			AttackSize = 20,
			UpgradePrice = 12500,
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 3100,
			AttackSpeed = 5.5,
			Range = 37,
			UpgradePrice = 7000,
		},
		[6] = {
			Damage = 3250,
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 8900,
		},
		[7] = {
			Damage = 3450,
			AttackSpeed = 4.5,
			Range = 40,
			UpgradePrice = 11000,
			Ability = "Arise: Shadow Warrior",
			AttackType = "Circle",
			AttackSize = 25,
		},
		[8] = {
			Damage = 3800,
			AttackSpeed = 4,
			Range = 40,
			UpgradePrice = 12700,
		},
		[9] = {
			Damage = 4000,
			AttackSpeed = 4,
			Range = 45,
			UpgradePrice = 25000,
			Ability = "Arise: Igros",
			AttackType = "Cone",
			AttackSize = 45,
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
	idle = "91498798762585",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit