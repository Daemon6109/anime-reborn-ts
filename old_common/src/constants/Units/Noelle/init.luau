local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Noille" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1100 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Royal Family"},
	Damage = 160 :: number,
	AttackSpeed = 7 :: number,
	Range = 20 :: number,
	Ability = "Water Current" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
			
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["WaterGrimoire"] = 1,
				["WaterWand"] = 25,
				["Clover"] = 1,
				["WaterStone"] = 30,
				["MageStone"] = 30,
				["RainbowStar"] = 2,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			EliminationsRequired = 3000;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+25% Damage";
			"+1 New Move: Water Dragon";
			"+1 New Passive: Tsunami Summon";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Noelle [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 200,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 1800,
		},
		[2] = {
			Damage = 220,
			AttackSpeed = 6.5,
			Range = 24,
			UpgradePrice = 2300,
		},
		[3] = {
			Damage = 350,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2800,
		},
		[4] = {
			Damage = 410,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 3500,

			Ability = "Water Smash",
			AttackType = "Circle",
			AttackSize = 10,
		},
		[5] = {
			Damage = 475,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 4450,
		},
		[6] = {
			Damage = 525,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 5000,
		},
		[7] = {
			Damage = 635,
			AttackSpeed = 8,
			Range = 32,
			UpgradePrice = 5700,
			
			Ability = "Water Barrage",
			AttackType = "Circle",
			AttackSize = 12,
		},
		[8] = {
			Damage = 680,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 7000,
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
	idle = "119476935664752",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit