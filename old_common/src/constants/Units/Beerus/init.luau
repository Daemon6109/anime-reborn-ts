local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Beruus" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"God Of Destruction"},
	Damage = 555 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 18 :: number,
	Ability = "Continous Ki Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["Pudding"] = 1,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Sphere of Destruction";
			"+1 New Passive: God's Presence";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Beerus [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 690,
			AttackSpeed = 7.5,
			Range = 20,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 800,
			AttackSpeed = 7.5,
			Range = 23,
			UpgradePrice = 3500,
		},
		[3] = {
			Damage = 970,
			AttackSpeed = 7,
			Range = 25,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 1175,
			AttackSpeed = 7,
			Range = 27,
			UpgradePrice = 6700,
		},
		[5] = {
			Damage = 1400,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 8000,

			AttackType = "Line",
			Ability = "Cataclysmic Orbs",
			AttackSize = 10,
		},
		[6] = {
			Damage = 1690,
			AttackSpeed = 6.5,
			Range = 30,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 2000,
			AttackSpeed = 6.5,
			Range = 31,
			UpgradePrice = 10420,
		},
		[8] = {
			Damage = 2400,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 11500,
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
	idle = "83304444773538",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit