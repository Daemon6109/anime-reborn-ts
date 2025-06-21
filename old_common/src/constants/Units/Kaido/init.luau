local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.height = .15
Unit.Radius = 3
Unit.Tradable = false
Unit.ShinyTradable = true
Unit.configuration = {
	CameraOffset = CFrame.new(0,.5,.2),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -4) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Dragon Emperor" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2450 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Sea Emperor"},
	Damage = 300 :: number,
	AttackSpeed = 6 :: number,
	Range = 15 :: number,
	Ability = "Haki Repulse" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["FurCoat"] = 1,
				["SpikedClub"] = 12,
				["DragonFruit"] = 12,
				["SmileFruit"] = 20,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Flaming Wrath";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Kaido [Hybrid]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 350,
			AttackSpeed = 6,
			Range = 17,
			UpgradePrice = 5000,
		},
		[2] = {
			Damage = 420,
			AttackSpeed = 6,
			Range = 18,
			UpgradePrice = 7600,
		},
		[3] = {
			Damage = 600,
			AttackSpeed = 7,
			Range = 18,
			UpgradePrice = 10050,
		},
		[4] = {
			Damage = 900,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 13500,
			Ability = "God's Valley Crusher",
			AttackSize = 17,
			AttackType = "Circle",
		},
		[5] = {
			Damage = 1200,
			AttackSpeed = 7,
			Range = 20,
			UpgradePrice = 16000,
		},
		[6] = {
			Damage = 1650,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 18500,
		},
		[7] = {
			Damage = 1685,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 22000,
			Ability = "Skysplitting Impact",
			AttackSize = 40,
			AttackType = "Cone",
		},
		[8] = {
			Damage = 1900,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 26000,
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
	idle = "107830578194597",
	walk = "17264216432",
	hair_and_cape = "126367547379260",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local Animations = Unit.animations

	AnimModule.PlayCustomAnim(Animations["hair_and_cape"], unit:WaitForChild("Humanoid"):WaitForChild("Model"):WaitForChild("AnimationController"), 1, "TailAndHairAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit