local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Akume" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Poison Sword"},
	Damage = 500 :: number,
	AttackSpeed = 6 :: number,
	Range = 18 :: number,
	Ability = "Eliminate" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Poison", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["Katana"] = 1,	
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};

	--	DisplayBuffs = {
	--		"+20% Damage";
	--		"+1 New Passive: Pinpoint Strikes";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Yuno Gassai [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 775,
			AttackSpeed = 5.5,
			Range = 19,
			UpgradePrice = 2200,
		},
		[2] = {
			Damage = 1031,
			AttackSpeed = 5.5,
			Range = 22,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 1235,
			AttackSpeed = 5.5,
			Range = 23,
			UpgradePrice = 4500,
		},
		[4] = {
			Damage = 1437,
			AttackSpeed = 5.5,
			Range = 24,
			UpgradePrice = 5300,
			
			AttackType = "Line",
			AttackSize = 9,
			Ability = "Murasame",
		},
		[5] = {
			Damage = 1707,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 6500,
		},
		[6] = {
			Damage = 1943,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 7800,
		},
		[7] = {
			Damage = 2375,
			AttackSpeed = 5,
			Range = 29,
			UpgradePrice = 9100,
		},
		
		[8] = {
			Damage = 2600,
			AttackSpeed = 5,
			Range = 29,
			UpgradePrice = 10700,
			
			SpecialAbility = "Ennoodzuno"
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
	idle = "134388099837123",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit