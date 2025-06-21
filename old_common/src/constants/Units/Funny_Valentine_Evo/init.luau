local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.height = .15
Unit.Radius = 2.5
Unit.Tradable = true
Unit.Evolved = "Funny Valentine"

Unit.configuration = {
	CameraOffset = CFrame.new(0,-.4,0),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 4 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Smiling Valentine [President]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fierce" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1600 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Mr. President", "Doppelganger"},
	Damage = 812 :: number,
	AttackSpeed = 7 :: number,
	Range = 18 :: number,
	Ability = "First Amendment" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 10 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable
		
	--	[1] = {
	--		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--			Items = { -- List of items to check. Index = name, Value = amount
	--				["BlueStar"] = 10,
	--				["GreenStar"] = 10,
	--				["OrangeStar"] = 10,
	--				["PurpleStar"] = 10,
	--				["RedStar"] = 10,
	--				["Cupcake"] = 15;
	--				["RainbowStar"] = 2,
	--			};
	
	--			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--			};

	--			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--			--	return true
	--			--end,
	--		};
		
	--		DisplayBuffs = {
	--			"+25% Damage";
	--			"+1 New Move: Death Ball";
	--			"+1 New Passive: Together we shine";
	--		};

	--		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--		EvolvesInto = "Android 21 [Demon]" :: string; -- The unit to evolve into
	--	}
	--};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1181,
			AttackSpeed = 7,
			Range = 19,
			UpgradePrice = 2300,
		},
		[2] = {
			Damage = 1375,
			AttackSpeed = 7,
			Range = 21,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 1725,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 2125,
			AttackSpeed = 6.5,
			Range = 25,
			UpgradePrice = 5555,
		},
		[5] = {
			Damage = 2456,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 7000,
			
			Ability = "Patriot Slam",
			AttackType = "Circle",
			AttackSize = 15
		},
		[6] = {
			Damage = 2812,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 8450,
		},
		[7] = {
			Damage = 3031,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 9865,
			
			Ability = "Dirty Deeds Done Dirt Cheap",
			AttackType = "Circle",
			AttackSize = 20
		},
		[8] = {
			Damage = 3593,
			AttackSpeed = 6,
			Range = 29,
			UpgradePrice = 11110,
		},
		[9] = {
			Damage = 3975,
			AttackSpeed = 5,
			Range = 31,
			UpgradePrice = 13320,
			
			SpecialAbility = "Love Train"
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
	idle = "127390178485043",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit