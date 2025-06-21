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
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Ant King" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1780 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 750 :: number,
	AttackSpeed = 13 :: number,
	Range = 25 :: number,
	Ability = "Revengeful Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 11 :: Enums.AttackSizeTypes,
	AttackEffect = "Poison", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["AntFace"] = 1,
					["RainbowStar"] = 1,
					["RedStar"] = 2,
					["PurpleStar"] = 2,
					["GreenStar"] = 2,
					["BlueStar"] = 2,
					["OrangeStar"] = 5,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--EliminationsRequired = 7500;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+Passive: Predator's Hunch"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Beru [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1100,
			AttackSpeed = 12,
			Range = 25,
			UpgradePrice = 2450,
		},
		[2] = {
			Damage = 1425,
			AttackSpeed = 11.5,
			Range = 28,
			UpgradePrice = 3800,
		},
		[3] = {
			Damage = 1850,
			AttackSpeed = 10,
			Range = 28,
			UpgradePrice = 4200,
		},
		[4] = {
			Damage = 2280,
			AttackSpeed = 9,
			Range = 32,
			UpgradePrice = 5425,
		},
		[5] = {
			Damage = 2670,
			AttackSpeed = 9,
			Range = 36,
			UpgradePrice = 6450,
			
			Ability = "Toxin Spit",
			AttackType = "Cone",
			AttackSize = 19,
		},
		[6] = {
			Damage = 3000,
			AttackSpeed = 9,
			Range = 36,
			UpgradePrice = 7825,
		},
		[7] = {
			Damage = 3200,
			AttackSpeed = 8.6,
			Range = 38,
			UpgradePrice = 9480,
		},
		[8] = {
			Damage = 4100,
			AttackSpeed = 7.5,
			Range = 38,
			UpgradePrice = 10760,
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
	idle = "109103009156297",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit