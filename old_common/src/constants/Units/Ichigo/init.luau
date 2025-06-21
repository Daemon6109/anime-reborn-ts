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
	DisplayName = "Ihigo" :: string,
	Rarity = "Rare" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 150 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"NumberOne"},
	Damage = 10 :: number,
	AttackSpeed = 2 :: number,
	Range = 12 :: number,
	Ability = "Air Slash" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 5 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--EvolveData = { -- If this exists, the unit will be evolvable

	--	{
	--		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

	--			Items = { -- List of items to check. Index = name, Value = amount
	--				["SoulEssense"] = 10,
	--				["ReaperPart"] = 10,
	--				["HollowMask"] = 10,
					
	--				["GreenStar"] = 1,
	--				["OrangeStar"] = 1,
	--				["RedStar"] = 1,
	--				["PurpleStar"] = 1,
	--			};

	--			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

	--			};
				
	--			EliminationsRequired = 1250;
	--			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
	--			--	return true
	--			--end,
	--		};

	--		DisplayBuffs = {
	--			"+The Horse";
	--			"+The King";
	--		};

	--		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

	--		EvolvesInto = "Ichigo [Bankai]" :: string; -- The unit to evolve into

	--	}
	--};
	UpgradesInfo = {
		[1] = {
			Damage = 15,
			AttackSpeed = 2,
			Range = 15,
			UpgradePrice = 350,
		},
		[2] = {
			Damage = 20,
			AttackSpeed = 2,
			Range = 18,
			UpgradePrice = 550,
		},
		[3] = {
			Damage = 25,
			AttackSpeed = 1.8,
			Range = 20,
			UpgradePrice = 650,
		},
		[4] = {
			Damage = 30,
			AttackSpeed = 1.5,
			Range = 20,
			UpgradePrice = 800,
		},
		[5] = {
			AttackType = "Line",
			AttackSize = 5,
			Ability = "Getsuga Tenshou",
			Damage = 35,
			AttackSpeed = 3,
			Range = 22,
			UpgradePrice = 1000,
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
	idle = "98730294358705",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit