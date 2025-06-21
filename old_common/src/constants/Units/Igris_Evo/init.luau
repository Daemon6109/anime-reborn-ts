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
	MaxUpgrades = 9 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Igros [Elite Knight]" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Dark" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 3400 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Hemorrhagic Severance"},
	Damage = 1250 :: number,
	AttackSpeed = 10 :: number,
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
	AttackEffectDuration = 3,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["Shadow Protector"] = 1,
					["RainbowStar"] = 2,
					["RedStar"] = 4,
					["PurpleStar"] = 4,
					["GreenStar"] = 4,
					["BlueStar"] = 4,
					["OrangeStar"] = 15,
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
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving
			EvolvesInto = "Igris [Evo2]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 1375,
			AttackSpeed = 9.5,
			Range = 25,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 1687.5,
			AttackSpeed = 9,
			Range = 28,
			UpgradePrice = 3750,
		},
		[3] = {
			Damage = 2500,
			AttackSpeed = 8.75,
			Range = 30,
			UpgradePrice = 5000,
		},
		[4] = {
			Damage = 3625,
			AttackSpeed = 8.25,
			Range = 32,
			UpgradePrice = 6500,
			AttackType = "Circle",
			AttackSize = 20,
			Ability = "Knights Vengeance",
		},
		[5] = {
			Damage = 3875,
			AttackSpeed = 8,
			Range = 35,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 4062.5,
			AttackSpeed = 7.5,
			Range = 36,
			UpgradePrice = 9500,
		},
		[7] = {
			Damage = 4375,
			AttackSpeed = 7,
			Range = 38,
			UpgradePrice = 11000,
		},
		[8] = {
			Damage = 5000,
			AttackSpeed = 7,
			Range = 40,
			UpgradePrice = 12750,
		},
		[9] = {
			Damage = 5680,
			AttackSpeed = 11,
			Range = 43,
			UpgradePrice = 15555,
			AttackType = "Full",
			AttackSize = 20,
			Ability = "Crimson Rampage",

			UnitType = "Hybrid" :: Enums.UnitType,

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
	IIYYYY = "86416088113927",
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