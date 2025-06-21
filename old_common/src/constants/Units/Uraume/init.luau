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
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Urane" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1600 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Freezing Touch"},
	Damage = 193 :: number,
	AttackSpeed = 7 :: number,
	Range = 23 :: number,
	Ability = "Icicle" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Frozen", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["Snowflake"] = 1,
				["RainbowStar"] = 2,
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
			"+1 New Passive: Ice Rain";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Uraume [Evo]" :: string; -- The unit to evolve into
		
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 264,
			AttackSpeed = 7,
			Range = 23,
			UpgradePrice = 2200,
		},
		[2] = {
			Damage = 330,
			AttackSpeed = 7,
			Range = 24,
			UpgradePrice = 2800,
		},
		[3] = {
			Damage = 407,
			AttackSpeed = 6.5,
			Range = 24.5,
			UpgradePrice = 3600,
		},
		[4] = {
			Damage = 490,
			AttackSpeed = 6.5,
			Range = 26,
			UpgradePrice = 4400,
		},
		[5] = {
			Damage = 580,
			AttackSpeed = 7,
			Range = 28.5,
			UpgradePrice = 5150,
			
			AttackType = "Line",
			Ability = "Frost Calm",
			AttackSize = 10,
		},
		[6] = {
			Damage = 770,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 6350,
		},
		[7] = {
			Damage = 870,
			AttackSpeed = 6.5,
			Range = 31,
			UpgradePrice = 7777,
		},
		[8] = {
			Damage = 1080,
			AttackSpeed = 6.5,
			Range = 31,
			UpgradePrice = 8950,
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
	idle = "79739401193315",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit