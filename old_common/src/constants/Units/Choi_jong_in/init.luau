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
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Chui" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1300 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 500 :: number,
	AttackSpeed = 6 :: number,
	Range = 22 :: number,
	Ability = "Flame Spears" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 22 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = 0.3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["BlueStar"] = 5,
					["GreenStar"] = 5,
					["RedStar"] = 5,
					["OrangeStar"] = 5,
					["PurpleStar"] = 5,
					["RainbowStar"] = 1,
					["Orb of Avarice"] = 1,
					--["ManaCrystals"] = 100
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 7500;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+Flame Dragon";
				"+Passive: Infernal Fury"
				--"+1 New Move: Silverine Slashes";
				--"+1 New Passive: Ice Destroyer";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Choi jong in [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1100,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 2750,
		},
		[3] = {
			Damage = 1350,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 1500,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 5750,
			Ability = "Flame Arrow",
			AttackType = "Circle",
			AttackSize = 12
		},
		[5] = {
			Damage = 1850,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 7500,
		},
		[6] = {
			Damage = 2500,
			AttackSpeed = 5,
			Range = 34,
			UpgradePrice = 8790,
		},
		[7] = {
			Damage = 3000,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 10100,
		},
		[8] = {
			Damage = 3250,
			AttackSpeed = 6.5,
			Range = 36,
			UpgradePrice = 11500,
			Ability = "Flame Dragon",
			AttackType = "Circle",
			AttackSize = 20,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "91404478074728",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit