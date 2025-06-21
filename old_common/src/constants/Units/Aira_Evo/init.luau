local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.Evolved = "Aira"

Unit.configuration = {
	CameraOffset = CFrame.new(.35,.15,.05),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.2, .3, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Airo [Awoken]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1455 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Power Roll II"},
	Damage = 500 :: number,
	AttackSpeed = 6 :: number,
	Range = 17 :: number,
	Ability = "Acrobatic Kicks" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 13 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable
		
	--	{
	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["Hogyoku"] = 1,
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};
		
	--	DisplayBuffs = {
	--		"+20% Damage";
	--		"+1 New Special Ability: Breakdown Sphere";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Aizen [Evo]" :: string; -- The unit to evolve into
		
	--	}
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 721,
			AttackSpeed = 6,
			Range = 19,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 925,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 3700,
		},
		[3] = {
			Damage = 1231,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 1750,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 6450,
			
			AttackType = "Circle",
			Ability = "Ballerina Swish",
			AttackSize = 10,
		},
		[5] = {
			Damage = 2025,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 7500,
		},
		[6] = {
			Damage = 2277,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 8670,
		},
		[7] = {
			Damage = 2625,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 9888,
			UnitType = "Hybrid",
		},
		[8] = {
			Damage = 3093,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 11100,
			
			AttackType = "Circle",
			Ability = "Acrobatic Twirls",
			AttackSize = 14,
		},
		[9] = {
			Damage = 3285,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 13870,
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
	idle = "92067478307647", --"115626504370471",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit