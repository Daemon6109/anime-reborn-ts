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
	DisplayName = "Gromjaw" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1200 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Bleeding Opportunist I"},
	Damage = 300 :: number,
	AttackSpeed = 7 :: number,
	Range = 15 :: number,
	Ability = "Panther Combo" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["GromjawMask"] = 1,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+20% Damage";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Grimmjow [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 400,
			AttackSpeed = 7,
			Range = 16,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 500,
			AttackSpeed = 6.5,
			Range = 17,
			UpgradePrice = 2800,
		},
		[3] = {
			Damage = 600,
			AttackSpeed = 6.5,
			Range = 19,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 750,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 4705,

			AttackType = "Line",
			Ability = "Grey",
			AttackSize = 7,
		},
		[5] = {
			Damage = 850,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 6000,
		},
		[6] = {
			Damage = 1000,
			AttackSpeed = 6.5,
			Range = 24,
			UpgradePrice = 7240,
		},
		[7] = {
			Damage = 1300,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 9000,
		},
		[8] = {
			Damage = 1800,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 10100,

			AttackType = "Circle",
			Ability = "Xero",
			AttackSize = 10,
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
	idle = "106049146298717",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit