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
	DisplayName = "Mr. Shrimpy" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Shrimp Boxing I"},
	Damage = 495 :: number,
	AttackSpeed = 6 :: number,
	Range = 18 :: number,
	Ability = "Flashy Fist" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "Paralysis", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		[1] = {
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["MilkCarton"] = 1,
					["GreenStar"] = 4,
					["OrangeStar"] = 20,
					["BlueStar"] = 2
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+1 New Move: Salary Uppercut";
				"+1 Passive Upgrade: Shrimp Boxing II";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "MrMantisShrimp [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 600,
			AttackSpeed = 6,
			Range = 19.5,
			UpgradePrice = 2600,
		},
		[2] = {
			Damage = 820,
			AttackSpeed = 6,
			Range = 21.5,
			UpgradePrice = 4000,
		},
		[3] = {
			Damage = 1070,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 5850,
		},
		[4] = {
			Damage = 1435,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 6700,
			
			Ability = "Jet Punch",
			AttackType = "Circle",
			AttackSize = 15, 
		},
		[5] = {
			Damage = 1750,
			AttackSpeed = 5.5,
			Range = 26,
			UpgradePrice = 8145,
		},
		[6] = {
			Damage = 2000,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 9888,
		},
		[7] = {
			Damage = 2300,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 11140,
		},
		[8] = {
			Damage = 2516,
			AttackSpeed = 4.5,
			Range = 29,
			UpgradePrice = 13450,
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
	idle = "75275715420023",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit