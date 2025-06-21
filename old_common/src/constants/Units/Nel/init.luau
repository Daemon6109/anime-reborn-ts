local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .4, -1.4)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Bell" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Ihigoooo!"},
	Damage = 1250 :: number,
	AttackSpeed = 14 :: number,
	Range = 20 :: number,
	Ability = "Cero Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	MoneyMult = 2,
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 16 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 25,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["RiatsuGyzer"] = 1,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 1000;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+1 New Move: Lance Throw";
				"+Passive"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Nel [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1450,
			AttackSpeed = 14,
			Range = 22,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1650,
			AttackSpeed = 13.5,
			Range = 23,
			UpgradePrice = 3150,
		},
		[3] = {
			Damage = 1700,
			AttackSpeed = 13.5,
			Range = 25,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 2000,
			AttackSpeed = 12.5,
			Range = 28,
			UpgradePrice = 5000,
		},
		[5] = {
			Damage = 2050,
			AttackSpeed = 12.5,
			Range = 32,
			UpgradePrice = 5500,
			AttackType = "Circle",
			AttackSize = 22,
			Ability = "Lance Throw",
		},
		[6] = {
			Damage = 2200,
			AttackSpeed = 12,
			Range = 35,
			UpgradePrice = 6000,
		},
		[7] = {
			Damage = 2350,
			AttackSpeed = 12,
			Range = 37,
			UpgradePrice = 6500,
		},
		[8] = {
			Damage = 3000,
			AttackSpeed = 10,
			Range = 38,
			UpgradePrice = 7500,
		},
	}
	
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "119476935664752",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit