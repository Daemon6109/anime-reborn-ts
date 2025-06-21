local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "Serpo"

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Spiral [Alien Tech]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Alien Technology II"},
	Damage = 725 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 25 :: number,
	Ability = "Six Sense Organs" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable
		
	--	{
	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["MarkOfPride"] = 1,
	--			["RainbowStar"] = 1,
	--			["OrangeStar"] = 20,
	--			["FireStone"] = 30,
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};
		
	--	DisplayBuffs = {
	--		"+20% Damage";
	--		"+1 New Passive: Shared Misery";
	--		"+1 New Move: Gigantification"
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Piccolo Orange [Full Power]" :: string; -- The unit to evolve into
	--	}
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 937,
			AttackSpeed = 7.5,
			Range = 27,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1175,
			AttackSpeed = 7,
			Range = 28,
			UpgradePrice = 3600,
		},
		[3] = {
			Damage = 1527,
			AttackSpeed = 7,
			Range = 28,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 1962,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 6250,
		},
		[5] = {
			Damage = 2275,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 8000,

			AttackType = "Circle",
			Ability = "Alien Grammetry",
			AttackSize = 14,
		},
		[6] = {
			Damage = 2735,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 9450,
		},
		[7] = {
			Damage = 3306,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 10250,
		},
		[8] = {
			Damage = 3562,
			AttackSpeed = 7,
			Range = 38,
			UpgradePrice = 12800,
		},
		
		[9] = {
			Damage = 3750,
			AttackSpeed = 8,
			Range = 39,
			UpgradePrice = 14000,
			
			AttackType = "Circle",
			Ability = "Perfect Zone",
			AttackSize = 18,
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
	idle = "98820593382978",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit