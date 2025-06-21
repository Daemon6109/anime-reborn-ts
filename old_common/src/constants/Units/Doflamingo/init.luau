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
	MaxPlacementAmount = 2 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 6 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "String Mage" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Revenge"},
	Damage = 1000 :: number,
	AttackSpeed = 11.5 :: number,
	Range = 30 :: number,
	Ability = "String Threads" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Line" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Burning", --effects that applies on the enemy when attacked
	AttackEffectDuration = 6,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Flamingo Shades"] = 1,
					
					["RainbowStar"] = 4,
					["OrangeStar"] = 20,

					["BlueStar"] = 14,
					["GreenStar"] = 14,
					["PurpleStar"] = 14,
					["RedStar"] = 14,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+New Attacks";
				"+Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Doflamingo [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		
		[1] = {
			Damage = 937.5,
			AttackSpeed = 5.75,
			Range = 16,
			UpgradePrice = 2250,
		},
		
		[2] = {
			Damage = 1250,
			AttackSpeed = 5.75,
			Range = 17,
			UpgradePrice = 2850,
		},
		
		[3] = {
			Damage = 1512.5,
			AttackSpeed = 5.75,
			Range = 17.5,
			UpgradePrice = 8500,
		},
		
		[4] = {
			Damage = 1875,
			AttackSpeed = 5.5,
			Range = 18,
			UpgradePrice = 6500,
		},
		
		[5] = {
			Damage = 2187.5,
			AttackSpeed = 5.5,
			Range = 18.5,
			UpgradePrice = 6800,
		},
		
		[6] = {
			Damage = 2625,
			AttackSpeed = 5.5,
			Range = 19,
			UpgradePrice = 7250,
			
			AttackType = "Circle",
			AttackSize = 12.5,
			Ability = "Pillar Eruption",
			AttackEffect = "Slow",
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
	idle = "100745724831757",
	walk = "17264216432",
	cape = "115363681855827"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.cape, unit:WaitForChild("cape"):WaitForChild("AnimationController"), 1, "capeanim", {Weight = 2, Fade = .15})
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