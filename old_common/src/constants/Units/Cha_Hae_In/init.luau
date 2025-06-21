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
	DisplayName = "Cho Heo In" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1740 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {},
	Damage = 700 :: number,
	AttackSpeed = 6 :: number,
	Range = 19 :: number,
	Ability = "Slashing Combo" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable

		{
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					["BlueStar"] = 5,
					["GreenStar"] = 5,
					["OrangeStar"] = 5,
					["RedStar"] = 5,
					["PurpleStar"] = 5,
					["Sword of Light"] = 1,
					--["ManaCrystals"] = 200
					--["RainbowStar"] = 5,
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
				"+Passive: Critical Overdrive"
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Cha Hae In [Evo]" :: string; -- The unit to evolve into
		}
	};
	UpgradesInfo = {
		[1] = {
			Damage = 750,
			AttackSpeed = 5.5,
			Range = 19,
			UpgradePrice = 1740,
		},
		[2] = {
			Damage = 850,
			AttackSpeed = 5,
			Range = 20,
			UpgradePrice = 2500,
		},
		[3] = {
			Damage = 1250,
			AttackSpeed = 5,
			Range = 24,
			UpgradePrice = 4100,
		
		},
		[4] = {
			Damage = 2000,
			AttackSpeed = 5,
			Range = 27,
			UpgradePrice = 7000,
			
			AttackType = "Cone" :: Enums.AttackTypes,
			AttackSize = 27,
			Ability = "Quake of Provocation",
			UnitType = "Hybrid" :: Enums.UnitType,

		},
		[5] = {
			Damage = 2000,
			AttackSpeed = 5,
			Range = 28,
			UpgradePrice = 8000,
		},
		[6] = {
			Damage = 2150,
			AttackSpeed = 4.5,
			Range = 29,
			UpgradePrice = 9200,
		},
		[7] = {
			Damage = 2250,
			AttackSpeed = 4.5,
			Range = 29,
			UpgradePrice = 10680,
		},
		[8] = {
			Damage = 2500,
			AttackSpeed = 4.5,
			Range = 32,
			UpgradePrice = 15000,

			AttackType = "Cone",
			AttackSize = 32,
			Ability = "Sword of Light",

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
	idle = "124109483162475",
	walk = "17264216432",
	Lsomething = "84088711751133",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		pcall(function()
			if unit.Name ~= "ShinyModel" then return end
			local Lsomething = unit:WaitForChild("Lsomething", 15)
			if Lsomething then
				AnimModule.PlayCustomAnim(Unit.animations.Lsomething, Lsomething:WaitForChild("AnimationController"), 1, "Lsomething", {Weight = 2, Fade = .15})
			end
		end)
	end)
	--print("animated")
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit