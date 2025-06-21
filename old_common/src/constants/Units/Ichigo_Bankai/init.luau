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
	MaxPlacementAmount = 6 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Ihigo [Bankai]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Duality"},
	Damage = 1250 :: number,
	AttackSpeed = 18 :: number,
	Range = 25 :: number,
	Ability = "The Horse" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 13 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["HornsofSalvation"] = 1,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 2000;
				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+Devastation Swing";
				"+Hollowfied Beam";
				"+Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Ichigo [Vasto]" :: string; -- The unit to evolve into

		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 2000,
			AttackSpeed = 16.5,
			Range = 25,
			UpgradePrice = 2200,
		},
		[2] = {
			Damage = 2350,
			AttackSpeed = 16.5,
			Range = 28,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 2500,
			AttackSpeed = 16,
			Range = 28,
			UpgradePrice = 2750,
		},
		[4] = {
			Damage = 2650,
			AttackSpeed = 15.5,
			Range = 32,
			UpgradePrice = 3000,
		},
		[5] = {
			Damage = 2750,
			AttackSpeed = 15.5,
			Range = 32,
			UpgradePrice = 3250,
			
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[6] = {
			Damage = 3500,
			AttackSpeed = 14,
			Range = 36,
			UpgradePrice = 5000,
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Devastation Swing",
		},
		[7] = {
			Damage = 3750,
			AttackSpeed = 13.5,
			Range = 38,
			UpgradePrice = 5500,
		},
		[8] = {
			Damage = 5000,
			AttackSpeed = 13,
			Range = 38,
			UpgradePrice = 6500,
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
	idle = "98730294358705",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit