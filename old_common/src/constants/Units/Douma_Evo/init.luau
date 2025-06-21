local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Douma"

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Domau [Pure Evil]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1841 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"FrostDemon"},	
	Damage = 437 :: number,
	AttackSpeed = 10 :: number,
	Range = 18 :: number,
	Ability = "Frozen Lotus" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Frost Bite", --effects that applies on the enemy when attacked
	AttackEffectDuration = 4,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["WaterGrimoire"] = 1,
	--			["WaterWand"] = 25,
	--			["Clover"] = 1,
	--			["WaterStone"] = 30,
	--			["MageStone"] = 30,
	--			["RainbowStar"] = 2,
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		EliminationsRequired = 3000;

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};

	--	DisplayBuffs = {
	--		"+25% Damage";
	--		"+1 New Move: Water Dragon";
	--		"+1 New Passive: Tsunami Summon";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Douma [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 593,
			AttackSpeed = 9.5,
			Range = 20,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 737,
			AttackSpeed = 9.5,
			Range = 20,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 875,
			AttackSpeed = 9,
			Range = 22,
			UpgradePrice = 3800,
		},
		[4] = {
			Damage = 1093,
			AttackSpeed = 9,
			Range = 25,
			UpgradePrice = 4500,

			Ability = "Lotus Vines",
			AttackType = "Cone",
			AttackSize = 30,
		},
		[5] = {
			Damage = 1162,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 5500,
		},
		[6] = {
			Damage = 1250,
			AttackSpeed = 8.5,
			Range = 28,
			UpgradePrice = 6800,
		},
		[7] = {
			Damage = 1687,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 8000,
			
			UnitType = "Hybrid",
			
			Ability = "Wintry Icicles",
			AttackType = "Line",
			AttackSize = 10,
		},
		[8] = {
			Damage = 2125,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 9300,
		},
		[9] = {
			Damage = 2400,
			AttackSpeed = 8.5,
			Range = 28,
			UpgradePrice = 10800,
			
			SpecialAbility = "Eternal Frost: Buddha"
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
	idle = "81700767594396",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit