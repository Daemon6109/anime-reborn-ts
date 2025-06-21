local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.configuration = {
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 8 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Demon Droid" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType,
	--============================--
	PlacementPrice = 555 :: number,
	CanSell = true :: boolean,
	--============================--
	Damage = 1500 :: number,
	AttackSpeed = 8 :: number,
	Range = 35 :: number,
	Ability = "Demonic Ki Blast" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		
		[1] = {
			Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory
			
				Currencies = { -- List of currencies to check. Index = name, Value = amount
				
				};
			
				Items = { -- List of items to check. Index = name, Value = amount
				
				};
			
				Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically
				
				};
			
				CheckFunction = function(player: Player): boolean? -- Must return true to proceed! RUNS ON SERVER!
					return true
				end,
			};

			TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

			EvolvesInto = "Bulma" :: string; -- The unit to evolve into
		};	
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 2000,
			AttackSpeed = 4.5,
			--Ability = "Shadow Clone Rasengan",
			--UnitType = "Hybrid",
			AttackSize = 30,
			UpgradePrice = 600,
		},
		[2] = {
			Damage = 5000,
			Ability = "Raging Ki Explosion",
			--AttackType = "Circle"
			AttackType = "Full",
			UpgradePrice = 900,
		},
		[3] = {
			Damage = 7500,
			UpgradePrice = 1500,
			AttackSpeed = 5,
		},
		[4] = {
			Damage = 11000,
			--Ability = "Fireball Jutsu",
			UpgradePrice = 2200,
		},
		[5] = {
			Damage = 16000,
			UpgradePrice = 3000,
		},
		[6] = {
			Damage = 16000,
			UpgradePrice = 3000,
		},
		[7] = {
			Damage = 16000,
			Ability = "Death Ball",
			AttackSize = 23,
			AttackType = "Circle",
			UpgradePrice = 3000,
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
	idle = "18172212518",
	walk = "17264216432",
}

function Unit:customizeVisuals(plr, unit)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local Animations = script.Animations

	AnimModule.PlayCustomAnim(Animations["Tail"], unit:WaitForChild("cloths"):WaitForChild("untitled"):WaitForChild("AnimationController"), 1, "TailAnim", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim(Animations["Hair"], unit:WaitForChild("cloths"):WaitForChild("hair"):WaitForChild("AnimationController"), 1, "HairAnim", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit