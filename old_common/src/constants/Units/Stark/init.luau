local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .95, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,

	CameraOffset = CFrame.new(0,-.55,1),

	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Coyote" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 850 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Wolf Pack"},
	Damage = 1000 :: number,
	AttackSpeed = 12 :: number,
	Range = 18 :: number,
	Ability = "Cero" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 18 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["RiatsuBlaster"] = 1,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically
				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			EliminationsRequired = 3000;

			DisplayBuffs = {
				"+Coyote Rampage";
				"+Materella";
				"+New Passive"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Stark [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 1250,
			AttackSpeed = 8,
			Range = 21,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1350,
			AttackSpeed = 8,
			Range = 21,
			UpgradePrice = 2750,
		},
		[3] = {
			Damage = 1500,
			AttackSpeed = 7.5,
			Range = 23,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 1800,
			AttackSpeed = 6.5,
			Range = 24,
			UpgradePrice = 5750,
			Ability = "Coyote Rampage",
			AttackType = "Circle",
			AttackSize = 18,
		},
		[5] = {
			Damage = 1850,
			AttackSpeed = 5.5,
			Range = 24,
			UpgradePrice = 6250,
			
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[6] = {
			Damage = 1900,
			AttackSpeed = 5,
			Range = 26,
			UpgradePrice = 6850,
		},
		[7] = {
			Damage = 2000,
			AttackSpeed = 5,
			Range = 26,
			UpgradePrice = 7200,
		},
		[8] = {
			Damage = 2500,
			AttackSpeed = 7,
			Range = 28,
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
	idle = "76261233703804",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit