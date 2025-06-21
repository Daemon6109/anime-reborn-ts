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
	MaxPlacementAmount = 4 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Lucky One" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Electrified Mana"},
	Damage = 170 :: number,
	AttackSpeed = 5 :: number,
	Range = 15 :: number,
	Ability = "Lightning Kick" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "Stun", --effects that applies on the enemy when attacked
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
			
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["LightningGrimoire"] = 1,
				["RainbowStar"] = 1,
				["BlueStar"] = 12,
				["GreenStar"] = 10,
				["PurpleStar"] = 8,
				["RedStar"] = 7,
				["FierceStone"] = 10,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+25% Damage";
			"+1 New Move: Kernos";
			"+1 New Passive: Chain Lightning";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Luck [Evo]" :: string; -- The unit to evolve into
		
	    }
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 215,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 290,
			AttackSpeed = 5,
			Range = 15,
			UpgradePrice = 3400,
		},
		[3] = {
			Damage = 365,
			AttackSpeed = 5,
			Range = 17,
			UpgradePrice = 3850,
		},
		[4] = {
			Damage = 435,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 4200,
			AttackType = "Circle",
			Ability = "Thunderbolt",
			AttackSize = 8,
		},
		[5] = {
			Damage = 510,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 5000,
		},
		[6] = {
			Damage = 590,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 6250,
		},
		[7] = {
			Damage = 840,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 8000,
		},
		[8] = {
			Damage = 960,
			AttackSpeed = 7.5,
			Range = 25,
			UpgradePrice = 9500,
			AttackType = "Line",
			Ability = "Lightning Barrage",
			AttackSize = 8,
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
	idle = "82855101080920",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit