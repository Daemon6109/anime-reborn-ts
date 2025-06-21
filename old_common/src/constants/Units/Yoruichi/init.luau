local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.2, .4, -1.3)*CFrame.Angles(0,math.rad(-180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 3 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Yosichi" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 750 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Shunko"},
	Damage = 150 :: number,
	AttackSpeed = 7 :: number,
	Range = 19 :: number,
	Ability = "Post Image Attack" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 19 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["LightningShunko"] = 1,
					
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically
				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			EliminationsRequired = 1000;

			DisplayBuffs = {
				"+Heavy Impact";
				"+Passive"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Yoruichi [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 500,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 1000,
		},
		[2] = {
			Damage = 850,
			AttackSpeed = 6.5,
			Range = 22,
			UpgradePrice = 1250,
		},
		[3] = {
			Damage = 1150,
			AttackSpeed = 6,
			Range = 24,
			UpgradePrice = 1350,
		},
		[4] = {
			Damage = 1350,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 2500,
			AttackType = "Circle",
			Ability = "Wind Burst",
			AttackSize = 27,
		},
		[5] = {
			Damage = 1450,
			AttackSpeed = 5.5,
			Range = 28,
			UpgradePrice = 3000,
		},
		[6] = {
			Damage = 1650,
			AttackSpeed = 5.5,
			Range = 29,
			UpgradePrice = 3500,
		},
		[7] = {
			Damage = 1800,
			AttackSpeed = 5,
			Range = 29,
			UpgradePrice = 4000,
		},
		[8] = {
			Damage = 1900,
			AttackSpeed = 5,
			Range = 32,
			UpgradePrice = 5000,
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
	idle = "83496529191125",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit