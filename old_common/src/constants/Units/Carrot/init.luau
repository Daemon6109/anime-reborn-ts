local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 7 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Karrot" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 950 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Electro Charge"},
	Damage = 800 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 18 :: number,
	Ability = "Fierce Lightning Claw" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 9 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 7,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["Easter Bunny"] = 1,
					["Easter Moon"] = 1,
					
					["RainbowStar"] = 2,
					["RedStar"] = 10,
					["PurpleStar"] = 10,
					["GreenStar"] = 10,
					["BlueStar"] = 10,
					["OrangeStar"] = 10,
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 3000;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+25% Damage";
				"+Passive";
				"+New Moves"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Carrot [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 850,
			AttackSpeed = 7,
			Range = 19.5,
			UpgradePrice = 1200,
		},
		[2] = {
			Damage = 1120,
			AttackSpeed = 7,
			Range = 21.5,
			UpgradePrice = 1750,
		},
		[3] = {
			Damage = 1300,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2330,
		},
		[4] = {
			Damage = 1400,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 3680,
		},
		[5] = {
			Damage = 1750,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 4720,
			Ability = "Lightning Onslaught",
			AttackType = "Circle",
			AttackSize = 20,
		},
		[6] = {
			Damage = 1850,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 6640,
		},
		[7] = {
			Damage = 2100,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 9730,
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
	idle = "91029949645691",
	cloth = "100998144606835",
	head1 = "78793620191393",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.cloth, unit:WaitForChild("cloth"):WaitForChild("AnimationController"), 1, "IIYYYYanim", {Weight = 2, Fade = .15})
			end)
			task.spawn(function()
				pcall(function()
					AnimModule.PlayCustomAnim(Unit.animations.head1, unit:WaitForChild("head1"):WaitForChild("AnimationController"), 1, "hairanim", {Weight = 2, Fade = .15})
				end)
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