local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.08, .1, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 7 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Blood Demon" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 666 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 666 :: number,
	AttackSpeed = 6 :: number,
	Range = 18 :: number,
	Ability = "Devastating Bats" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 9 :: Enums.AttackSizeTypes,
	AttackEffect = "Weak Point", --effects that applies on the enemy when attacked
	AttackEffectDuration = 1,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable
		
	--	{
	--	Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--		Items = { -- List of items to check. Index = name, Value = amount
	--			["CursedKnife"] = 1,
	--		};

	--		Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--		};

	--		--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--		--	return true
	--		--end,
	--	};

	--	DisplayBuffs = {
	--		"+20% Damage";
	--		"+1 New Move: Dark Flash";
	--		"+1 New Passive: Employee of the Month";
	--	};

	--	TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--	EvolvesInto = "Nanami [Evo]" :: string; -- The unit to evolve into
	-- 	}
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 699,
		},
		[2] = {
			Damage = 750,
			AttackSpeed = 6,
			Range = 19,
			UpgradePrice = 1099,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 2500,
		},
		[4] = {
			Damage = 1200.5,
			AttackSpeed = 5.5,
			Range = 22,
			UpgradePrice = 4400,
		},
		[5] = {
			Damage = 1425.5,
			AttackSpeed = 5.5,
			Range = 25,
			UpgradePrice = 5000,

			Ability = "Blood Thirsty Dive",
			AttackSize = 12,
			AttackType = "Circle",
		},
		[6] = {
			Damage = 1500,
			AttackSpeed = 5,
			Range = 30,
			UpgradePrice = 7500,
		},
		[7] = {
			Damage = 2200,
			AttackSpeed = 5,
			Range = 33,
			UpgradePrice = 9000,
			
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
	idle = "130995008781191",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit