local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Retired Hitman" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Quick Strike"},
	Damage = 610 :: number,
	AttackSpeed = 5 :: number,
	Range = 17 :: number,
	Ability = "Retirement-Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 9 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
			{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					['RetiredGlasses'] = 1, -- New Evo Item
					["RainbowStar"] = 1,
					["BlueStar"] = 2,
					["GreenStar"] = 2,
					["PurpleStar"] = 2,
					["RedStar"] = 2,
					["OrangeStar"] = 5,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};
		
			DisplayBuffs = {
				"+20% Damage";
				"+1 New Passive: Hitman Tricks";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Sakomoto [Evo]" :: string; -- The unit to evolve into
		
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 860,
			AttackSpeed = 5,
			Range = 19,
			UpgradePrice = 2880,
		},
		[2] = {
			Damage = 1250,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 4050,
		},
		[3] = {
			Damage = 1645,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 5500,
		},
		[4] = {
			Damage = 2222,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 7400,
			
			Ability = "Pan Smackdown",
			AttackType = "Circle",
			AttackSize = 12,
		},
		[5] = {
			Damage = 2500,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 8290,
		},
		[6] = {
			Damage = 2850,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 9845,
		},
		[7] = {
			Damage = 3000,
			AttackSpeed = 5,
			Range = 30,
			UpgradePrice = 11460,
		},
		[8] = {
			Damage = 3250,
			AttackSpeed = 5,
			Range = 31,
			UpgradePrice = 14000,
			
			Ability = "Assassin Awakening",
			AttackType = "Circle",
			AttackSize = 18,

			UnitType = "Hybrid",
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
	idle = "91403717246121",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit