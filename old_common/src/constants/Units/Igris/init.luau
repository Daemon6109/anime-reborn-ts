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
	MaxUpgrades = 8 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Igros" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Fire" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 3400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Commander's Scar"},
	Damage = 800 :: number,
	AttackSpeed = 6 :: number,
	Range = 23 :: number,
	Ability = "Kings Longsword" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 18 :: Enums.AttackSizeTypes,
	AttackEffect = "Scar", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					--["MagicMask"] = 1,
					["BlueStar"] = 10,
					["GreenStar"] = 10,
					["RedStar"] = 10,
					["OrangeStar"] = 10,
					["PurpleStar"] = 10,
					["RainbowStar"] = 3,
					["Demon King's Longsword"] = 1,
					--["ManaCrystals"] = 1000
				};

				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

				};

				EliminationsRequired = 3000;

				--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
				--	return true
				--end,
			};

			DisplayBuffs = {
				"+20% Damage";
				"+Crimson Rampage",
				"+Passive: Hemorrhagic Severance"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Igris [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 1100,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1350,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 2000,
			AttackSpeed = 6,
			Range = 30,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 2900,
			AttackSpeed = 6.5,
			Range = 30,
			UpgradePrice = 6500,
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Knights Vengeance",
		},
		[5] = {
			Damage = 3100,
			AttackSpeed = 6,
			Range = 35,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 3250,
			AttackSpeed = 6,
			Range = 36,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 3500,
			AttackSpeed = 6,
			Range = 38,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 4000,
			AttackSpeed = 6,
			Range = 40,
			UpgradePrice = 12750,
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
	idle = "113133337470237",
	walk = "17264216432",
	IIYYYY = "77643382572010",
	hair = "122326346049060",
	hair1 = "122326346049060",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.IIYYYY, unit:WaitForChild("IIYYYY"):WaitForChild("AnimationController"), 1, "IIYYYYanim", {Weight = 2, Fade = .15})
			end)
		end)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.hair1, unit:WaitForChild("hair"):WaitForChild("AnimationController"), 1, "hairanim", {Weight = 2, Fade = .15})
			end)
		end)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.hair1, unit:WaitForChild("hair1"):WaitForChild("AnimationController"), 1, "hair1anim", {Weight = 2, Fade = .15})
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