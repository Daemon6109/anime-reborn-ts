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
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Krollo" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1150 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Bandit’s Secret"},
	Damage = 95 :: number,
	AttackSpeed = 8 :: number,
	Range = 26 :: number,
	Ability = "Dagger Rampage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
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

					["Demon Book"] = 1,
					
					["BlueStar"] = 12,
					["GreenStar"] = 12,
					["RedStar"] = 12,
					["OrangeStar"] = 10,
					["PurpleStar"] = 12,
					["RainbowStar"] = 2,
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
			EvolvesInto = "Chrollo [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 400,
			AttackSpeed = 8,
			Range = 28,
			UpgradePrice = 1850,
		},
		[2] = {
			Damage = 790,
			AttackSpeed = 7.5,
			Range = 30,
			UpgradePrice = 2120,
		},
		[3] = {
			Damage = 900,
			AttackSpeed = 7.5,
			Range = 31,
			UpgradePrice = 2640,
		},
		[4] = {
			Damage = 950,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 3240,
			
			Ability = "Bone Fish",
			AttackType = "Line",
			AttackSize = 14,
		},
		[5] = {
			Damage = 1100,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 4000,
		},
		[6] = {
			Damage = 1250,
			AttackSpeed = 7,
			Range = 34,
			UpgradePrice = 5340,
		},
		[7] = {
			Damage = 1450,
			AttackSpeed = 6.5,
			Range = 34,
			UpgradePrice = 6120,
		},
		[8] = {
			Damage = 1950,
			AttackSpeed = 6.5,
			Range = 35,
			UpgradePrice = 6540,
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
	idle = "108919366993004",
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