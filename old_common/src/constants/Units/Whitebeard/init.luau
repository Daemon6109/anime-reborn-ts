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
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Greybeard" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1850 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Strongest Man Alive"},
	Damage = 200 :: number,
	AttackSpeed = 8 :: number,
	Range = 20 :: number,
	Ability = "Quake Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["QuakeFruit"] = 1,
				["SkyShell"] = 40,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+20% Damage";
			"+1 New Passive: Tremor";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Whitebeard [Yonko]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 275,
			AttackSpeed = 8,
			Range = 25,
			UpgradePrice = 2350,
		},
		[2] = {
			Damage = 400,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 2700,
		},
		[3] = {
			Damage = 550,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 3500,
			AttackType = "Cone",
			Ability = "Bisento Slash",
			AttackSize = 25,
		},
		[4] = {
			Damage = 600,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 4150,
		},
		[5] = {
			Damage = 650,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 4700,
		},
		[6] = {
			Damage = 695,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 5200,
			AttackType = "Full",
			Ability = "Ground Shatter",
			AttackSize = 25,
			UnitType = "Hybrid",
		},
		[7] = {
			Damage = 760,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 6150,
		},
		[8] = {
			Damage = 790,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 8000,
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
	idle = "88553641715653",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit