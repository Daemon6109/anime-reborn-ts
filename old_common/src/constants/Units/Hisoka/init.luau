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
	MaxUpgrades = 6 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Misoka" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Sadistic Amusement"},
	Damage = 400 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 24 :: number,
	Ability = "Card Throw" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					["Joker Card"] = 1,
					
					["BlueStar"] = 8,
					["GreenStar"] = 8,
					["RedStar"] = 8,
					["OrangeStar"] = 10,
					["PurpleStar"] = 8,
					["RainbowStar"] = 1,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};
				
				EliminationsRequired = 3000;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+Damage Increased";
				"+New Moves",
				"+New Passives"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Hisoka [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 600,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 1140,
		},
		[2] = {
			Damage = 700,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 1620,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 2300,
		},
		[4] = {
			Damage = 1150,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 3260,
			AttackType = "Circle",
			AttackSize = 14,
			Ability = "Card Slice",
		},
		[5] = {
			Damage = 1640,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 4640,
		},
		[6] = {
			Damage = 1700,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 6590,
		}
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "113133337470237",
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