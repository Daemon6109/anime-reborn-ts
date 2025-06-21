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
	DisplayName = "Yune Gossi" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Precise Blows"},
	Damage = 190 :: number,
	AttackSpeed = 3 :: number,
	Range = 13 :: number,
	Ability = "Axe Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 4 :: Enums.AttackSizeTypes,
	AttackEffect = "Scar", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["Katana"] = 1,	
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+20% Damage";
			"+1 New Passive: Pinpoint Strikes";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Yuno Gassai [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 240,
			AttackSpeed = 3,
			Range = 13,
			UpgradePrice = 1750,
		},
		[2] = {
			Damage = 290,
			AttackSpeed = 3,
			Range = 15,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 350,
			AttackSpeed = 3,
			Range = 17,
			UpgradePrice = 3200,
		},
		[4] = {
			Damage = 420,
			AttackSpeed = 3,
			Range = 17,
			UpgradePrice = 4000,
			AttackType = "Circle",
			AttackSize = 6,
			Ability = "Machete Rush",
		},
		[5] = {
			Damage = 500,
			AttackSpeed = 3,
			Range = 19,
			UpgradePrice = 4800,
		},
		[6] = {
			Damage = 600,
			AttackSpeed = 3,
			Range = 19,
			UpgradePrice = 5800,
		},
		[7] = {
			Damage = 710,
			AttackSpeed = 3,
			Range = 19,
			UpgradePrice = 7000,
		},
		[8] = {
			Damage = 830,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 9250,
			AttackType = "Line",
			AttackSize = 8,
			Ability = "MP5",
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
	idle = "93940973846567",
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