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
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Tashrio" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Hybrid" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1090 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Adaptive"},
	Damage = 180 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "Frozen Heavens" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["DragonSword"] = 1,
				["RainbowStar"] = 2,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			EliminationsRequired = 2500;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+25% Damage";
			"+1 New Passive: Ice Shatter";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Toshiro [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 225,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 1700,
		},
		[2] = {
			Damage = 280,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 2000,
		},
		[3] = {
			Damage = 335,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 2460,
			
			AttackType = "Line",
			Ability = "Hail Flower",
			AttackSize = 8,
		},
		[4] = {
			Damage = 400,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 3000,
		},
		[5] = {
			Damage = 475,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 3500,
		},
		[6] = {
			Damage = 540,
			AttackSpeed = 6.5,
			Range = 27,
			UpgradePrice = 4100,

			AttackType = "Line",
			Ability = "Hail Dragon",
			AttackSize = 10,
		},
		[7] = {
			Damage = 625,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 5600,
		},
		[8] = {
			Damage = 840,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 7600,
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
	idle = "77016121610005",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit