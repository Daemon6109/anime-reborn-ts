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
	DisplayName = "Muichori" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Mist Cover I"},
	Damage = 270 :: number,
	AttackSpeed = 7 :: number,
	Range = 17 :: number,
	Ability = "Layered Mist" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 8 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["MistKatana"] = 1;
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
			"+25% Damage";
			"+1 New Move: Haze Cloud Sea";
			"+1 Passive Upgrade: Mist Cover I -> Mist Cover II";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Muichiro [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 335,
			AttackSpeed = 7,
			Range = 17.5,
			UpgradePrice = 2360,
		},
		[2] = {
			Damage = 387,
			AttackSpeed = 6.8,
			Range = 17.5,
			UpgradePrice = 2980,
		},
		[3] = {
			Damage = 470,
			AttackSpeed = 6.5,
			Range = 18.5,
			UpgradePrice = 3600,
		},
		[4] = {
			Damage = 630,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 4470,
			
			AttackType = "Circle",
			Ability = "Flow Slash",
			AttackSize = 10,
		},
		[5] = {
			Damage = 700,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 5300,
		},
		[6] = {
			Damage = 872,
			AttackSpeed = 6.2,
			Range = 24,
			UpgradePrice = 6525,
			
			AttackType = "Circle",
			Ability = "Dispersing Mist",
			AttackSize = 10,
		},
		[7] = {
			Damage = 1050,
			AttackSpeed = 5.7,
			Range = 26,
			UpgradePrice = 7200,
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
	idle = "122802058141347",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit