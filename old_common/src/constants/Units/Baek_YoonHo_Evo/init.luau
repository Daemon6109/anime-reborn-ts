local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Book Yoonha [Silver Mane]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Tiger Transformation"},
	Damage = 1150 :: number,
	AttackSpeed = 8 :: number,
	Range = 25 :: number,
	Ability = "Fiece Slam" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 4 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	{
	--		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--			Items = { -- List of items to check. Index = name, Value = amount
	--				["Clawed Gauntlet"] = 1,
	--			};

	--			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--			};

	--			--EliminationsRequired = 7500;

	--			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--			--	return true
	--			--end,
	--		};

	--		DisplayBuffs = {
	--			"+25% Damage";
	--		};

	--		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--		EvolvesInto = "Baek YoonHo [Evo2]" :: string; -- The unit to evolve into
	--	}
	--};
	UpgradesInfo = {
		[1] = {
			Damage = 1350,
			AttackSpeed = 7.5,
			Range = 28,
			UpgradePrice = 3850,
		},
		[2] = {
			Damage = 1375,
			AttackSpeed = 7.5,
			Range = 29,
			UpgradePrice = 4900,
		},
		[3] = {
			Damage = 1625,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 6075,
		},
		[4] = {
			Damage = 1875,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 7500,
			AttackType = "Circle",
			AttackSize = 15,
			Ability = "Tiger Punches",
		},
		[5] = {
			Damage = 2062.5,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 9250,
		},
		[6] = {
			Damage = 2750,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 11000,
		},
		[7] = {
			Damage = 3750,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 13750,
		},
		[8] = {
			Damage = 5000,
			AttackSpeed = 7,
			Range = 37,
			UpgradePrice = 15000,
			AttackType = "Line",
			AttackSize = 15,
			Ability = "Tiger Slashes",
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
	idle = "128321187223716",
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