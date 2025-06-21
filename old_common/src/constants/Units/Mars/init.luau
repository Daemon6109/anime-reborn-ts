local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.height = .15
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Mercury" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Ice" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1800 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Crystallized Mana"},
	Damage = 300 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "Splitter Barrage" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 7 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["DiamondGrimoire"] = 1,
				["RainbowStar"] = 2,
				["BlueStar"] = 12,
				["GreenStar"] = 15,
				["RedStar"] = 15,
				["WaterStone"] = 32,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};
			
			EliminationsRequired = 5000;

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};

		DisplayBuffs = {
			"+25% Damage";
			"+1 New Move: Crystal Sword";
			"+1 New Passive: Crystal Servants";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Mars [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 360,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 2600,
		},
		[2] = {
			Damage = 460,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 550,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 840,
			AttackSpeed = 8.5,
			Range = 25,
			UpgradePrice = 4400,
			AttackType = "Line",
			Ability = "Crystal Shots",
			AttackSize = 7,
			UnitType = "Hybrid",
		},
		[5] = {
			Damage = 1110,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 5250,
		},
		[6] = {
			Damage = 1250,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 5900,
		},
		[7] = {
			Damage = 1500,
			AttackSpeed = 8,
			Range = 30,
			UpgradePrice = 7550,
		},
		[8] = {
			Damage = 1650,
			AttackSpeed = 7,
			Range = 32,
			UpgradePrice = 10000,
			AttackType = "Line",
			Ability = "Crystal Strike",
			AttackSize = 9,
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
	idle = "101661711806199",
	walk = "17264216432",
	hairAnim = "98944742673151"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	--local AnimModule = require(game.ReplicatedStorage.AnimModule)

	--AnimModule.PlayCustomAnim(Unit.animations.hairAnim, unit:WaitForChild("asta2"):WaitForChild("hair"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit