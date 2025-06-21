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
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Aizon Hogyoku" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType, --
	--============================---
	PlacementPrice = 1250 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Kanzen Saimin"},
	Damage = 2500 :: number,
	AttackSpeed = 15 :: number,
	Range = 18 :: number,
	Ability = "Hypnosis Aura" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
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
					["HogoyokuFragment"] = 1,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};
				
				EliminationsRequired = 1500;
				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+Overwhelming Spiritual Pressure";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "AizenHogyoku [Evo]" :: string; -- The unit to evolve into

		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 2750,
			AttackSpeed = 14.5,
			Range = 19,
			UpgradePrice = 1750,
		},
		[2] = {
			Damage = 3000,
			AttackSpeed = 14,
			Range = 19,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 3250,
			AttackSpeed = 13.5,
			Range = 21,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 3450,
			AttackSpeed = 13,
			Range = 21,
			UpgradePrice = 5000,
			AttackType = "Line",
			AttackSize = 18,
			Ability = "Imaginary Flames",
		},
		[5] = {
			Damage = 3550,
			AttackSpeed = 12.5,
			Range = 23,
			UpgradePrice = 3600,
		},
		[6] = {
			Damage = 3650,
			AttackSpeed = 12,
			Range = 23,
			UpgradePrice = 4750,
		},
		[7] = {
			Damage = 4500,
			AttackSpeed = 10.5,
			Range = 23,
			UpgradePrice = 5850,
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
	idle = "86459613094803", --"115626504370471",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit