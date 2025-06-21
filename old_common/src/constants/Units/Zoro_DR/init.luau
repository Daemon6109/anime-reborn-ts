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
	MaxUpgrades = 6 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Zero [Evo]" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"OniGiri"},
	Damage = 1300/2 :: number,
	AttackSpeed = 13/2 :: number,
	Range = 19/2 :: number,
	Ability = "Thousand Cuts" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19/4 :: Enums.AttackSizeTypes,
	AttackEffect = "Scar", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["ZoroEvoItem [2]"] = 1,
					
					["RainbowStar"] = 2,
					["OrangeStar"] = 10,

					["BlueStar"] = 12,
					["GreenStar"] = 12,
					["PurpleStar"] = 12,
					["RedStar"] = 12,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+New Attacks";
				"+Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Zoro [DR] {Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 1562.5 / 2,
			AttackSpeed = 12.5 / 2,
			Range = 23 / 2,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 2187.5 / 2,
			AttackSpeed = 12 / 2,
			Range = 23.5 / 2,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 2500 / 2,
			AttackSpeed = 12 / 2,
			Range = 25 / 2,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 3125 / 2,
			AttackSpeed = 11.5 / 2,
			Range = 11.5 / 2,
			UpgradePrice = 6500,
		},
		[5] = {
			Damage = 4250 / 2,
			AttackSpeed = 11.5 / 2,
			Range = 28 / 2,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 4700 / 2,
			AttackSpeed = 11 / 2,
			Range = 30 / 2,
			UpgradePrice = 9500,
			
			AttackType = "Line",
			AttackSize = (28/2) / 2,
			Ability = "Billion Fold",
		},
	}
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "95989952033580",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit