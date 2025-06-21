local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Evolved = "Nanami"
Unit.Tradable = true

Unit.configuration = {
	Viewport = CFrame.new(-.08, .1, -1.75)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Nonomi [Overtime]" :: string,
	Rarity = "Exclusive" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 1300 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Overtime", "Employee of the Month"},
	Damage = 264 :: number,
	AttackSpeed = 5 :: number,
	Range = 16 :: number,
	Ability = "Cursed Explosion" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 6 :: Enums.AttackSizeTypes,
	AttackEffect = "Weak Point", --effects that applies on the enemy when attacked
	AttackEffectDuration = 10,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 372,
			AttackSpeed = 5,
			Range = 17,
			UpgradePrice = 1800,
		},
		[2] = {
			Damage = 480,
			AttackSpeed = 4.5,
			Range = 20,
			UpgradePrice = 2250,
		},
		[3] = {
			Damage = 600,
			AttackSpeed = 4.5,
			Range = 22,
			UpgradePrice = 3000,
		},
		[4] = {
			Damage = 750,
			AttackSpeed = 4,
			Range = 22,
			UpgradePrice = 3600,
		},
		[5] = {
			Damage = 960,
			AttackSpeed = 7,
			Range = 22,
			UpgradePrice = 5000,

			Ability = "Ratio Technique",
			AttackSize = 10,
			AttackType = "Circle",
		},
		[6] = {
			Damage = 1080,
			AttackSpeed = 6,
			Range = 25,
			UpgradePrice = 6500,
		},
		[7] = {
			Damage = 1360,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 7750,
		},
		[8] = {
			Damage = 1700,
			AttackSpeed = 7,
			Range = 29,
			UpgradePrice = 8150,
			
			Ability = "Dark Flash",
			AttackSize = 8,
			AttackType = "Circle",
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
	idle = "112626968929674",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:onPlace(plr, unit)

end

function Unit:onDelete(plr, unit)
end

return Unit