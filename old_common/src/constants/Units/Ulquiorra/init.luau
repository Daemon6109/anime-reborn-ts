local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false
Unit.ShinyTradable = true
Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Olkuiorra" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 850 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Materialism"},
	Damage = 800 :: number,
	AttackSpeed = 14 :: number,
	Range = 15 :: number,
	Ability = "Bat Slash" :: string, -- starting ability
	SpecialAbility = "Ulq Destruction" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 18 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["OrihimeHeart"] = 1,
					["HollowMask"] = 15,
					["ReaperPart"] = 15,
					["SoulEssense"] = 15,
					["GreenStar"] = 5,
					["OrangeStar"] = 3,
					["RedStar"] = 5,
					["PurpleStar"] = 5,
					["RainbowStar"] = 3,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};
				
				EliminationsRequired = 2000;
				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+Dark Zero";
				"+2 New Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Ulquiorra [Evo]" :: string; -- The unit to evolve into

		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1100,
			AttackSpeed = 14,
			Range = 18,
			UpgradePrice = 1000,
		},
		[2] = {
			Damage = 1350,
			AttackSpeed = 13.5,
			Range = 18,
			UpgradePrice = 1250,
		},
		[3] = {
			Damage = 2000,
			AttackSpeed = 13.5,
			Range = 22,
			UpgradePrice = 1350,
		},
		[4] = {
			Damage = 2900,
			AttackSpeed = 12,
			Range = 24,
			UpgradePrice = 3500,
			AttackType = "Circle",
			AttackSize = 25,
			Ability = "Thunder Spear",
			UnitType = "Hybrid" :: Enums.UnitType,
		},
		[5] = {
			Damage = 3100,
			AttackSpeed = 11.5,
			Range = 25,
			UpgradePrice = 3500,
		},
		[6] = {
			Damage = 3250,
			AttackSpeed = 11.5,
			Range = 25,
			UpgradePrice = 3750,
		},
		[7] = {
			Damage = 3500,
			AttackSpeed = 11,
			Range = 28,
			UpgradePrice = 4000,
		},
		[8] = {
			Damage = 4200,
			AttackSpeed = 10.5,
			Range = 32,
			UpgradePrice = 4500,
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
	idle = "73782328212630", --"115626504370471",
	walk = "17264216432",
	wing1 = "82672390134143"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.wing1, unit:WaitForChild("wing1"):WaitForChild("AnimationController"), 1, "wing1anim", {Weight = 2, Fade = .15})
			end)
		end)
	end)
	--print("animated")
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit