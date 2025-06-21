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
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Getero" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"The Human Heart"},
	Damage = 100 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 25 :: number,
	Ability = "Still Punch" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 13 :: Enums.AttackSizeTypes,
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
					["Buddha Statue"] = 1,
					
					["BlueStar"] = 12,
					["GreenStar"] = 12,
					["RedStar"] = 12,
					["OrangeStar"] = 13,
					["PurpleStar"] = 12,
					["RainbowStar"] = 3,
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
			EvolvesInto = "Netero [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 7.5,
			Range = 27,
			UpgradePrice = 1140,
		},
		[2] = {
			Damage = 790,
			AttackSpeed = 7.5,
			Range = 28,
			UpgradePrice = 1850,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 2650,
		},
		[4] = {
			Damage = 950,
			AttackSpeed = 7,
			Range = 30,
			UpgradePrice = 3500,
			AttackType = "Line",
			AttackSize = 15,
			Ability = "Divine Punishment",
		},
		[5] = {
			Damage = 1100,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 4600,
		},
		[6] = {
			Damage = 1300,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 5700,
		},
		[7] = {
			Damage = 1500,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 6400,
		},
		[8] = {
			Damage = 2150,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 7500,
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
	idle = "81459795574554",
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