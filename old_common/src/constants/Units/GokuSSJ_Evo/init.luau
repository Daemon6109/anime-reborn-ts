local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "GokuSSJ"
Unit.Tradable = false

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Super Gohu [Powered]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Air" :: Enums.UnitType,
	--============================--
	PlacementPrice = 1890 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Overflowing Power II"},
	Damage = 225 :: number,
	AttackSpeed = 8 :: number,
	Range = 25 :: number,
	Ability = "Ki Blast" :: string, -- starting ability
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

		{

			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

				Items = { -- List of items to check. Index = name, Value = amount
					
					["Cosmic Crystal"] = 1,
					["Wind Crystal"] = 50,
					
					["Dragon Ball (1)"] = 1,
					["Dragon Ball (2)"] = 1,
					["Dragon Ball (3)"] = 1,
					["Dragon Ball (4)"] = 1,
					["Dragon Ball (5)"] = 1,
					["Dragon Ball (6)"] = 1,
					["Dragon Ball (7)"] = 1,

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
				"+30% Damage";
				"+New Moves";
				"+New Passive";
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Goku [Evo]" :: string; -- The unit to evolve into

		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 313,
			AttackSpeed = 8,
			Range = 27,
			UpgradePrice = 2250,
		},
		[2] = {
			Damage = 407,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 3400,
		},
		[3] = {
			Damage = 456,
			AttackSpeed = 7,
			Range = 31,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 540,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 4650,
		},
		[5] = {
			Damage = 644,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 5000,
			AttackType = "Line",
			Ability = "Kame Beam",
			AttackSize = 7,
		},
		[6] = {
			Damage = 800,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 6500,
		},
		[7] = {
			Damage = 954,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 8500,
		},
		[8] = {
			Damage = 1063,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 12500,
		},
		[9] = {
			Damage = 1220,
			AttackSpeed = 7,
			Range = 33,
			UpgradePrice = 16000,
			AttackType = "Circle",
			Ability = "Spirit Bomb",
			AttackSize = 19,
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
	idle = "121034505739814",
	walk = "17264216432",
	hair = "74141329654855",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)

	AnimModule.PlayCustomAnim(Unit.animations.hair, unit:WaitForChild("hairgokussj3"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
	--print("animated")
end

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit