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
	DisplayName = "Sijin [Chef]" :: string,
	Rarity = "Legendary" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Diable Jambe"},
	Damage = 950 :: number,
	AttackSpeed = 11.5 :: number,
	Range = 30 :: number,
	Ability = "Party Table Kick" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Damaged Cape [2]"] = 1,	
					
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

			EvolvesInto = "Sanji [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 1700 / 2,
			AttackSpeed = 11.5 / 2,
			Range = 32 / 2,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 2100 / 2,
			AttackSpeed = 10.5 / 2,
			Range = 34 / 2,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 2850 / 2,
			AttackSpeed = 10.5 / 2,
			Range = 35 / 2,
			UpgradePrice = 5500,
		},
		[4] = {
			Damage = 3550 / 2,
			AttackSpeed = 10 / 2,
			Range = 36 / 2,
			UpgradePrice = 6500,
			
			AttackType = "Circle",
			AttackSize = (36 / 2) / 2,
			Ability = "Concasser Crush",
		},
		
		[5] = {
			Damage = 4100 / 2,
			AttackSpeed = 10 / 2,
			Range = 37 / 2,
			UpgradePrice = 7000,
		},
		
		[6] = {
			Damage = 4950 / 2,
			AttackSpeed = 9.5 / 2,
			Range = 38 / 2,
			UpgradePrice = 7250,
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
	idle = "86579607855805",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit