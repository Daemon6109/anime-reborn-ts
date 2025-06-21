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
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 7 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Breiza" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2500 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Emperors Ego"},
	Damage = 500 :: number,
	AttackSpeed = 7 :: number,
	Range = 30 :: number,
	Ability = "Death Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{

			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount

					["Freiza Halo"] = 1,
					["Dark Crystal"] = 25,

					["RainbowStar"] = 15,
					["RedStar"] = 15,
					["PurpleStar"] = 15,
					["GreenStar"] = 15,
					["BlueStar"] = 15,
					["OrangeStar"] = 15,

				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--EliminationsRequired = 7500;
				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+New Moves";
				"+New Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Freiza [Evo]" :: string; -- The unit to evolve into

		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1200,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 1500,
		},
		[2] = {
			Damage = 1250,
			AttackSpeed = 6.5,
			Range = 32,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 1450,
			AttackSpeed = 6.5,
			Range = 33,
			UpgradePrice = 3500,
		},
		[4] = {
			Damage = 1650,
			AttackSpeed = 6,
			Range = 34,
			UpgradePrice = 4500,
		},
		[5] = {
			Damage = 1900,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 5050,
		},
		[6] = {
			Damage = 2020,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 5550,
			
			Ability = "Death Ball",
			AttackType = "Circle",
			AttackSize = 17,
		},
		[7] = {
			Damage = 1950,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 6000,
			
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
	idle = "131142285881068",
	walk = "17264216432",
	FreizatailIdle = "129875860603930",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.FreizatailIdle, unit:WaitForChild("FreizatailIdle"):WaitForChild("AnimationController"), 1, "FreizatailIdleanim", {Weight = 2, Fade = .15})
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