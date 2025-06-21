local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Gohun" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1250 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Limitless Fury I"},
	Damage = 215 :: number,
	AttackSpeed = 4 :: number,
	Range = 18 :: number,
	Ability = "Energy Blast Volley" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["SpecialBeam"] = 1,
				["RainbowStar"] = 2,
				["FierceStone"] = 15,				
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically
				["Pan"] = 15,
			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Spiral Beast Cannon";
			"New Passive: Limitless Fury II";
			"New Passive: Pure Endurance";

		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Gohan [Beast]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 280,
			AttackSpeed = 4,
			Range = 18,
			UpgradePrice = 1275,
		},
		[2] = {
			Damage = 360,
			AttackSpeed = 4,
			Range = 20,
			UpgradePrice = 2000,
		},
		[3] = {
			AttackType = "Circle",
			AttackSize = 8,
			Ability = "Beam Cannon",
			Damage = 460,
			AttackSpeed = 5,
			Range = 22,
			UpgradePrice = 2600,
		},
		[4] = {
			Damage = 600,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 3550,
		},
		[5] = {
			Damage = 760,
			AttackSpeed = 5,
			Range = 25,
			UpgradePrice = 4450,
		},
		[6] = {
			AttackType = "Line",
			AttackSize = 8,
			Ability = "Energy Beam",
			Damage = 900,
			AttackSpeed = 5,
			Range = 28,
			UpgradePrice = 5700,
		},
		[7] = {
			Damage = 1075,
			AttackSpeed = 5,
			Range = 28,
			UpgradePrice = 7000,
		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("ShinyModel"),
}

Unit.animations = {
	idle = "139583734439575",
	walk = "17264216432",
	hair = "109787707780134"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)

	AnimModule.PlayCustomAnim(Unit.animations.hair, unit:WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
	--print("animated")
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit