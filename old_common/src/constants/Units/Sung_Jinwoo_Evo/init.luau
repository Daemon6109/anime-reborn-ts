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
	DisplayName = "Solo Woo [DARK]" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 765 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 100 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "Shadow Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					["BlueStar"] = 20,
					["GreenStar"] = 20,
					["RedStar"] = 20,
					["OrangeStar"] = 20,
					["PurpleStar"] = 20,
					["RainbowStar"] = 3,
					["Kamish's Wrath"] = 1,
					--["ManaCrystals"] = 1000
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically
					--["Choi jong in [Evo]"] = 1,
					["Igris [Evo]"] = 1,
				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			EliminationsRequired = 3000;

			DisplayBuffs = {
				"+20% Damage";
				"Arise: Shadow Warrior";
				"Arise: Igros";
				"+Passive: Arise"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Sung Jinwoo [Evo2]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 175,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 1000,
		},
		[2] = {
			Damage = 250,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 1500,
		},
		[3] = {
			Damage = 325,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 2100,
		},
		[4] = {
			Damage = 420,
			AttackSpeed = 6,
			Range = 36,
			Ability = "Arise: Korgolgon",
			UpgradePrice = 2700,
			AttackType = "Circle",
			AttackSize = 20,
		},
		[5] = {
			Damage = 500,
			AttackSpeed = 5.5,
			Range = 37,
			UpgradePrice = 3600,
		},
		[6] = {
			Damage = 589,
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 4750,
		},
		[7] = {
			Damage = 675,
			AttackSpeed = 4.5,
			Range = 40,
			UpgradePrice = 5850,
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