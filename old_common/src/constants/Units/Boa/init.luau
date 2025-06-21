local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Bao" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Wind" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1150 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Charming Impact"},
	Damage = 650 :: number,
	AttackSpeed = 6 :: number,
	Range = 20 :: number,
	Ability = "Pistol Kiss" :: string, -- starting ability
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
		[1] = {
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["RoyalCharm"] = 1,
					["OrangeStar"] = 5,
					["PurpleStar"] = 5,
					["RedStar"] = 5,
					["RainbowStar"] = 2,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};
			
			DisplayBuffs = {
				"+25% Damage";
				"+1 New Move: Melo Melo Merrow";
				"+1 New Passive: Cold Hearted Empress";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Boa [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1000,
			AttackSpeed = 6,
			Range = 22,
			UpgradePrice = 2000,
		},
		[2] = {
			Damage = 1300,
			AttackSpeed = 6,
			Range = 23,
			UpgradePrice = 2900,
		},
		[3] = {
			Damage = 1650,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 3850,
		},
		[4] = {
			Damage = 2150,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 5000,
			
			AttackType = "Line",
			Ability = "Smiting Arrow",
			AttackSize = 6,
		},
		[5] = {
			Damage = 2500,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 6950,
		},
		[6] = {
			Damage = 2850,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 8500,
		},
		[7] = {
			Damage = 3200,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 10000,
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
	idle = "103892206281639", --"115626504370471",
	walk = "17264216432",
	skirt = "129040131141904",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	if unit:HasTag("ShinyModel") then
		
	else
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		AnimModule.PlayCustomAnim(AnimModule.GetAnim(game.ReplicatedStorage.Animations.Boa.Skirt), unit:WaitForChild("Model"):WaitForChild("Skirt"):WaitForChild("AnimationController"), 1, "Animation", {Weight = 2, Fade = .15})
	end
end


function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit