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
	MaxUpgrades = 8 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Karrot [Easter]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 950 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Electro Charge", "Electric Surge"},
	Damage = 1100 :: number,
	AttackSpeed = 7.5 :: number,
	Range = 18 :: number,
	Ability = "Fierce Lightning Claw" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 11 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 2,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1760,
			AttackSpeed = 7,
			Range = 19.5,
			UpgradePrice = 1200,
		},
		[2] = {
			Damage = 2500,
			AttackSpeed = 7,
			Range = 21.5,
			UpgradePrice = 1750,
		},
		[3] = {
			Damage = 2800,
			AttackSpeed = 6.5,
			Range = 23,
			UpgradePrice = 2330,
		},
		[4] = {
			Damage = 3000,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 3680,
		},
		[5] = {
			Damage = 3620,
			AttackSpeed = 6,
			Range = 26,
			UpgradePrice = 4720,
			Ability = "Lightning Onslaught",
			AttackType = "Circle",
			AttackSize = 16,
		},
		[6] = {
			Damage = 4020,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 6640,
		},
		[7] = {
			Damage = 4850,
			AttackSpeed = 5.5,
			Range = 27,
			UpgradePrice = 8720,
			
			Ability = "Lightning Barrage",
			AttackType = "Circle",
			AttackSize = 22,
		},
		[8] = {
			Damage = 5150,
			AttackSpeed = 5.5,
			Range = 29,
			UpgradePrice = 11850,
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
	cloth = "84056396477200",
	head1 = "78793620191393",
	head2 = "121131065991192"
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
	task.spawn(function()
		local AnimModule = require(game.ReplicatedStorage.AnimModule)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.cloth, unit:WaitForChild("cloth"):WaitForChild("AnimationController"), 1, "IIYYYYanim", {Weight = 2, Fade = .15})
			end)
		end)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.head1, unit:WaitForChild("head1"):WaitForChild("AnimationController"), 1, "hairanim", {Weight = 2, Fade = .15})
			end)
		end)
		task.spawn(function()
			pcall(function()
				AnimModule.PlayCustomAnim(Unit.animations.head2, unit:WaitForChild("head2"):WaitForChild("AnimationController"), 1, "hair1anim", {Weight = 2, Fade = .15})
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