local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Required = nil;
local Transforming = false;

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

Unit.Radius = 2.5
Unit.Tradable = false

local Transformations = {
	[1] = "Default",
	[2] = "SuperSaiyan",
	[3] = "Blue",
	[4] = "GoD",
}

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 3 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Vegoto [Unlimited]" :: string,
	Rarity = "Mythical" :: Enums.Rarities ,
	--============================--
	PlacementType = "Air" :: Enums.PlacementTypes,
	Element = "Water" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 900 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Saiyan Prince", "Saiyans Pride"},
	Damage = 800 :: number,
	AttackSpeed = 5.5 :: number,
	Range = 30 :: number,
	Ability = "Galick Gun" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 15 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 1200,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 1275,
		},
		[2] = {
			Damage = 1500,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 2000,
		},
		[3] = {
			Damage = 1800,
			AttackSpeed = 5.5,
			Range = 35,
			UpgradePrice = 2600,
		},
		[4] = {
			Damage = 2150,
			AttackSpeed = 5,
			Range = 36,
			UpgradePrice = 3550,

			Ability = "Ki Blasts",
			AttackType = "Circle",
			AttackSize = 17,
		},
		[5] = {
			Damage = 2300,
			AttackSpeed = 5,
			Range = 37,
			UpgradePrice = 4450,
		},
		[6] = {
			Damage = 2600,
			AttackSpeed = 5,
			Range = 38,
			UpgradePrice = 5100,

			Ability = "Final Flash",
			AttackType = "Circle",
			AttackSize = 18,
		},
		[7] = {
			Damage = 2900,
			AttackSpeed = 5,
			Range = 40,
			UpgradePrice = 5900,
		},
		[8] = {
			Damage = 3200,
			AttackSpeed = 4.5,
			Range = 40,
			UpgradePrice = 6700,

			Ability = "Final Explosion",
			AttackType = "Full",
			AttackSize = 40,
		},
		[9] = {
			Damage = 3800,
			AttackSpeed = 4.5,
			Range = 41,
			UpgradePrice = 7000,

		},
	},
	--============================--
}

Unit.misc = {
	ScriptLink = script,
	Model = script:FindFirstChild("Model"),
	ShinyModel = script:FindFirstChild("Model"),
}

Unit.animations = {
	idle = "112043809456767",
	walk = "17264216432",
}

Unit:CacheAbilities()

function Unit:customizeVisuals(plr, unit)
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

local function Transparent(Model, Value)
	for i,v in pairs(Model:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Transparency = Value
		end
	end
end

local function Transform(Unit, LastTransformation, Unit2)

	local lastTransform = Transformations[LastTransformation] :: string
	local newTransform = Transformations[LastTransformation+1] :: string
	
	if not newTransform then warn("no new transform") return end
	if lastTransform == newTransform then warn("Same transformation") return end

	local TModels = Unit:FindFirstChild("Transformations") :: Folder
	local PreviousModel = TModels:FindFirstChild(lastTransform) :: Model
	local NewModel = TModels:FindFirstChild(newTransform) :: Model

	local Face = Unit.Head:FindFirstChild(newTransform)
	local oldFace = Unit.Head:FindFirstChild(lastTransform)

	if newTransform == "GoD" then
		task.delay(3, function()
			Transparent(TModels, 1)
			Transparent(NewModel, 0)
			if oldFace then
				oldFace.Transparency = 1
			end
			if Face then
				Face.Transparency = 0
			end
		end)
		if Transforming then return end
		if not Required then
			Required = require(script["Transformation"]) 
		end
		Transforming = true
		Required:Effect(Unit2)
		Transforming = false
	else
		Transparent(TModels, 1)
		Transparent(NewModel, 0)
		if oldFace then
			oldFace.Transparency = 1
		end
		if Face then
			Face.Transparency = 0
		end
	end
end

function Unit:onWave(unit, LastTransformation)

	local UnitCu = unit.VisualModelLink.Value
	Transform(UnitCu, LastTransformation, unit)

end

return Unit