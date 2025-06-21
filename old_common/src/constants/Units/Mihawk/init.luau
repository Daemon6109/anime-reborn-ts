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
	DisplayName = "Hawk Eyes" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1450 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Warlord I"},
	Damage = 110 :: number,
	AttackSpeed = 5 :: number,
	Range = 17 :: number,
	Ability = "Dark slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
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
				["CrossNecklace"] = 1,
				["SkyShell"] = 40,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+25% Damage";
			"+1 New Move: Triple Energy Blade";
			"+1 New Passive: Warlord II";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Mihawk [Warlord]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 150,
			AttackSpeed = 5,
			Range = 19,
			UpgradePrice = 2300,
		},
		[2] = {
			Damage = 200,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 3100,
		},
		[3] = {
			Damage = 265,
			AttackSpeed = 5.5,
			Range = 20,
			UpgradePrice = 3950,
			AttackType = "Line",
			Ability = "Energy blade",
			AttackSize = 6,
		},
		[4] = {
			Damage = 300,
			AttackSpeed = 5.5,
			Range = 20,
			UpgradePrice = 4500,
		},
		[5] = {
			Damage = 440,
			AttackSpeed = 5.5,
			Range = 20,
			UpgradePrice = 5000,
		},
		[6] = {
			Damage = 540,
			AttackSpeed = 5.5,
			Range = 21,
			UpgradePrice = 6500,
		},
		[7] = {
			Damage = 600,
			AttackSpeed = 5,
			Range = 23,
			UpgradePrice = 9500,
		},
		[8] = {
			Damage = 650,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 10000,
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
	idle = "128369429429167",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit