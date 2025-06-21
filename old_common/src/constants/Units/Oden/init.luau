local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	CameraOffset = CFrame.new(-0.2,0.2,0),
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Oda" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2300 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Samurai's Spirit I"},
	Damage = 180 :: number,
	AttackSpeed = 7 :: number,
	Range = 15 :: number,
	Ability = "Dual Haki Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 9 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["LightStone"] = 30,
				["SmileFruit"] = 20,
				["OdaBlade"] = 12,
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+20% Damage";
			"+1 New Move: Samurai's Revenge";
			"+1 New Passive: Samurai's Spirit II";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Oden [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 230,
			AttackSpeed = 7,
			Range = 16,
			UpgradePrice = 2750,
		},
		[2] = {
			Damage = 300,
			AttackSpeed = 7,
			Range = 17.5,
			AttackType = "Cone" :: Enums.AttackTypes,
			Ability = "Haki Typhoon",
			AttackSize = 17,
			UpgradePrice = 3100,
		},
		[3] = {
			Damage = 370,
			AttackSpeed = 6.5,
			Range = 19,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 430,
			AttackSpeed = 6.5,
			Range = 20,
			UpgradePrice = 4900,
		},
		[5] = {
			Damage = 560,
			AttackSpeed = 6.5,
			Range = 21,
			UpgradePrice = 5500,
		},
		[6] = {
			Damage = 630,
			AttackSpeed = 6,
			Range = 21,
			UpgradePrice = 6900,
		},
		[7] = {
			Damage = 765,
			AttackSpeed = 6,
			Range = 23,
			Ability = "Haki Cross Lunge",
			AttackType = "Circle" :: Enums.AttackTypes,
			UpgradePrice = 10000,
		},
		[8] = {
			Damage = 835,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 12500,
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
	idle = "77185747375005",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	--local AnimModule = require(game.ReplicatedStorage.AnimModule)
	--local Animations = script.Animations

	--AnimModule.PlayCustomAnim(Animations["Tail"], unit:WaitForChild("cloths"):WaitForChild("untitled"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit