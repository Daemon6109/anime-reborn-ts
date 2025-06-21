local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .15, -2)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 8 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Solo Woo" :: string,
	Rarity = "Rare" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 100 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 10 :: number,
	AttackSpeed = 8 :: number,
	Range = 30 :: number,
	Ability = "X Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = .05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					["BlueStar"] = 10,
					["GreenStar"] = 10,
					["RedStar"] = 10,
					["PurpleStar"] = 10,
					["OrangeStar"] = 10,
					["RainbowStar"] = 1,
					["Kasaka's Venom Fang"] = 1,
					--["ManaCrystals"] = 500
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};
			
			EliminationsRequired = 500;

			DisplayBuffs = {
				"+20% Damage";
				"+Arise: Korgolgon";
				"+Arise: Shadow Warrior";
				"Arise: Igros"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Sung Jin Woo" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 20,
			Range = 31,
			AttackSpeed = 7.5,
			UpgradePrice = 200,
		},
		[2] = {
			Damage = 30,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 300,
		},
		[3] = {
			Damage = 40,
			AttackSpeed = 6.5,
			Range = 33,
			UpgradePrice = 500,
		},
		[4] = {
			Damage = 50,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 700,
		},
		[5] = {
			Damage = 75,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 1000,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "134844065554246",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit