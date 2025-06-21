local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "Seiko"

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Saiko [Exorcist]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Helping Hand"},
	Damage = 543.75 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 18 :: number,
	Ability = "Bat Smash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
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
			Damage = 650,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 2100,
		},
		[2] = {
			Damage = 815,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 3400,
		},
		[3] = {
			Damage = 1000,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 4200,
		},
		[4] = {
			Damage = 1255,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 6000,

			AttackType = "Circle",
			Ability = "Cursed Nail",
			AttackSize = 14,
		},
		[5] = {
			Damage = 1525,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 7400,
		},
		[6] = {
			Damage = 1850,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 9600,
		},
		[7] = {
			Damage = 2244,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 12000,
		},
		[8] = {
			Damage = 2522,
			AttackSpeed = 6,
			Range = 32,
			UpgradePrice = 17000,

			AttackType = "Circle",
			Ability = "Charm Nail",
			AttackSize = 16,

			UnitType = "Hybrid"
		},
		[9] = {
			Damage = 3500,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 22000,
			
			SpecialAbility = "Anti-Spirit Domain",
		}
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "85937869458086",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit