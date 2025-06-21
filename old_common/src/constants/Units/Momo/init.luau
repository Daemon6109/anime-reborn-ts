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
	DisplayName = "Mimi" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	
	MapAffnity = "Ghost Tunnel",
	GameTypeAffinity = {"Portal"},
	MapAffnityBoosts = {
		PermanentDamageMulti = .1,
	},
	--============================--
	PlacementPrice = 1266 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Psychic Surge"},
	Damage = 385 :: number,
	AttackSpeed = 7 :: number,
	Range = 17 :: number,
	Ability = "Psychic wave" :: string, -- starting ability
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
		[1] = {
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["SpiritHands"] = 1,
					["BlueStar"] = 3,
					["GreenStar"] = 3,
					["RedStar"] = 3,
					["RainbowStar"] = 1
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+1 New Move: Esper Slam";
				"+1 Passive: Psychic Connection";
				"+1 Passive on 5th upgrade: True Sight";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Momo [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 498,
			AttackSpeed = 6.5,
			Range = 18,
			UpgradePrice = 2200,
		},
		[2] = {
			Damage = 675,
			AttackSpeed = 6.5,
			Range = 19,
			UpgradePrice = 4100,
		},
		[3] = {
			Damage = 880,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 5700,
		},
		[4] = {
			Damage = 1075,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 6900,
			
			AttackType = "Circle",
			Ability = "Esper Clap",
			AttackSize = 8,
		},
		[5] = {
			Damage = 1333,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 7900,
		},
		[6] = {
			Damage = 1750,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 9000,
		},
		[7] = {
			Damage = 1950,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 10800,
		},
		[8] = {
			Damage = 2210,
			AttackSpeed = 5.5,
			Range = 29,
			UpgradePrice = 12111,
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
	idle = "126261527857423",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit