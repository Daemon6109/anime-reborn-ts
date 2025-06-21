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
	DisplayName = "Spiral" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1690 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Alien Technology I"},
	Damage = 580 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 25 :: number,
	Ability = "Six Sense Organs" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable	
		[1] = {
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["AlienMask"] = 1,
					["GreenStar"] = 3,
					["OrangeStar"] = 20,
					["RedStar"] = 3
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+1 New Move: Perfect Zone";
				"+1 Passive Upgrade: Alien Technology II";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Serpo [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 7.5,
			Range = 27,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 940,
			AttackSpeed = 7,
			Range = 28,
			UpgradePrice = 3600,
		},
		[3] = {
			Damage = 1222,
			AttackSpeed = 7,
			Range = 28,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 1570,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 6250,
		},
		[5] = {
			Damage = 1820,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 8000,
			
			AttackType = "Circle",
			Ability = "Alien Grammetry",
			AttackSize = 14,
		},
		[6] = {
			Damage = 2188,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 9450,
		},
		[7] = {
			Damage = 2645,
			AttackSpeed = 7,
			Range = 35,
			UpgradePrice = 10250,
		},
		[8] = {
			Damage = 2850,
			AttackSpeed = 7,
			Range = 38,
			UpgradePrice = 12800,
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
	idle = "98820593382978",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit