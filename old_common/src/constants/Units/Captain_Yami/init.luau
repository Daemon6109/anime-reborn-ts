local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yamo" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2050 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Darkness"},
	Damage = 215 :: number,
	AttackSpeed = 7 :: number,
	Range = 14 :: number,
	Ability = "Darkness Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["DarkGrimoire"] = 1,
				["RainbowStar"] = 2,
				["RedStar"] = 9,
				["PurpleStar"] = 12,
				["OrangeStar"] = 15,
				["DarkStone"] = 10,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};
			
			EliminationsRequired = 3000;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Dimension Slash";
			"+1 New Passive: Captain's Presence";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Captain Yami [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 300,
			AttackSpeed = 7,
			Range = 16,
			UpgradePrice = 2425,
		},
		[2] = {
			Damage = 362,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 435,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 3500,
			
			AttackType = "Line",
			Ability = "Darkness Barrage",
			AttackSize = 6,
		},
		[4] = {
			Damage = 500,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 4250,
			UnitType = "Hybrid"
		},
		[5] = {
			Damage = 550,
			AttackSpeed = 7.5,
			Range = 22,
			UpgradePrice = 4850,
			
			AttackType = "Line",
			Ability = "Dark Thrust",
			AttackSize = 8,
		},
		[6] = {
			Damage = 615,
			AttackSpeed = 7,
			Range = 24,
			UpgradePrice = 5300,
		},
		[7] = {
			Damage = 900,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 6825,
		},
		[8] = {
			Damage = 1050,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 9150,
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
	idle = "104833851018124",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit