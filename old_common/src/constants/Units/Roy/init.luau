local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Ray" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"BlazingFury"},	
	Damage = 200 :: number,
	AttackSpeed = 7 :: number,
	Range = 17 :: number,
	Ability = "Snap" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["MustangLighter"] = 1,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			EliminationsRequired = 0;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Flame Pillar";
			"+1 New Passive: Frame Power";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Roy [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 260,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 1540,
		},
		[2] = {
			Damage = 325,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 2030,
		},
		[3] = {
			Damage = 405,
			AttackSpeed = 6,
			Range = 20,
			UpgradePrice = 2700,
		},
		[4] = {
			Damage = 635,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 4500,

			Ability = "Bombardment",
			AttackType = "Circle",
			AttackSize = 10,
		},
		[5] = {
			Damage = 750,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 4200,
		},
		[6] = {
			Damage = 825,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5150,
		},
		[7] = {
			Damage = 930,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 6200,
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
	idle = "84136356255028",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit