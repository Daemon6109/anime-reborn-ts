local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Kiritsugu"

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Kirit [Accel]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1740 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},	
	Damage = 212 :: number,
	AttackSpeed = 6 :: number,
	Range = 18 :: number,
	Ability = "Orgin Bullet" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
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

	--	EvolvesInto = "Kiritsugu [Evo]" :: string; -- The unit to evolve into
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 281,
			AttackSpeed = 6,
			Range = 19,
			UpgradePrice = 2330,
		},
		[2] = {
			Damage = 343,
			AttackSpeed = 5.5,
			Range = 21,
			UpgradePrice = 2950,
		},
		[3] = {
			Damage = 431,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 3590,
		},
		[4] = {
			Damage = 612,
			AttackSpeed = 7.5,
			Range = 23,
			UpgradePrice = 4400,

			Ability = "Calico",
			AttackType = "Cone",
			AttackSize = 30,
		},
		[5] = {
			Damage = 693,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 5050,
		},
		[6] = {
			Damage = 800,
			AttackSpeed = 6.5,
			Range = 24,
			UpgradePrice = 5930,
		},
		[7] = {
			Damage = 950,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 7100,
		},
		[8] = {
			Damage = 1135,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 8630,

			SpecialAbility = "Time Accel"
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
	idle = "78581815686128",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit