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
	MaxUpgrades = 7 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Laugfy [Evo]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Gear 2nd"},
	Damage = 1000/2 :: number,
	AttackSpeed = 11/2 :: number,
	Range = 19/2 :: number,
	Ability = "Gum Pistol" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19/2 :: Enums.AttackSizeTypes,
	AttackEffect = "Slow", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["LaughfyEvoItem [2]"] = 1,	
					
					["RainbowStar"] = 5,
					["OrangeStar"] = 25,

					["BlueStar"] = 18,
					["GreenStar"] = 18,
					["PurpleStar"] = 18,
					["RedStar"] = 18,
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

			EvolvesInto = "Luffy [DR] [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 200,
			AttackSpeed = 7.5,
			Range = 32,
			UpgradePrice = 825,
		},
		[2] = {
			Damage = 275,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 900,
		},
		[3] = {
			Damage = 350,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 1400,
		},
		[4] = {
			Damage = 450,
			AttackSpeed = 6,
			Range = 36,
			UpgradePrice = 1750,
			
			Ability = "Giant Pistol" :: string,
			AttackType = "Line" :: Enums.AttackTypes,
			AttackSize = 36/2 :: Enums.AttackSizeTypes,
		},
		[5] = {
			Damage = 520,
			AttackSpeed = 5.5,
			Range = 37,
			UpgradePrice = 2000,
		},
		[6] = {
			Damage = 600,
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 2500,
		},
		[7] = {
			Damage = 725,
			AttackSpeed = 4.5,
			Range = 40,
			UpgradePrice = 3000,
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
	idle = "83378599502109",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit