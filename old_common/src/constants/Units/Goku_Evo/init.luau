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
	[3] = "God",
	[4] = "UI",
	[5] = "MUI"
}

Unit.configuration = {
	Viewport = CFrame.new(0, .6, -1.65)*CFrame.Angles(0,math.rad(180),0) :: CFrame,
	PreviewViewport = CFrame.new(0.1, -0.02, -3.3) * CFrame.Angles(0,math.rad(180),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 1 :: number,
	SellCost = 100 :: number,
	MaxUpgrades = 5 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Gohu [Instinct]" :: string,
	Rarity = "Reborn" :: Enums.Rarities , --bro you brok it, done touch it
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Hybrid" :: Enums.UnitType,
	--============================--
	PlacementPrice = 2700 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Reborn", "Saiyan Blood", "Ultra Instinct"},
	Damage = 820 :: number,
	AttackSpeed = 6.5 :: number,
	Range = 25 :: number,
	Ability = "Mini Spirit Bomb" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Circle" :: Enums.AttackTypes,
	AttackSize = 14 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 5,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 2000,
			AttackSpeed = 6,
			Range = 27,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 2700,
			AttackSpeed = 6,
			Range = 28,
			UpgradePrice = 3120,
		},
		[3] = {
			Damage = 3500,
			AttackSpeed = 5.5,
			Range = 29,
			UpgradePrice = 3830,
			
			Ability = "Kamehameha",
			AttackType = "Line",
			AttackSize = 12,
		},
		[4] = {
			Damage = 4300,
			AttackSpeed = 5.5,
			Range = 30,
			UpgradePrice = 4700,
		},
		[5] = {
			Damage = 5000,
			AttackSpeed = 5.5,
			Range = 32,
			UpgradePrice = 6320,
			Ability = "Ki Bind",
			AttackType = "Circle",
			AttackSize = 17,
		},
		[6] = {
			Damage = 6500,
			AttackSpeed = 5.5,
			Range = 34,
			UpgradePrice = 7430,
		},
		[7] = {
			Damage = 8000,
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 9230,
			
			Ability = "Super Kamehameha",
			AttackType = "Line",
			AttackSize = 16,
		},
		[8] = {
			Damage = 10000,
			AttackSpeed = 5,
			Range = 35,
			UpgradePrice = 11000,
		},
		[9] = {
			Damage = 17500,
			AttackSpeed = 4.5,
			Range = 36,
			UpgradePrice = 13000,
			Ability = "Super Spirit Bomb",
			AttackType = "Circle",
			AttackSize = 18,
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
	idle = "80547683773408",
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

local function EnableAura(Model, Bool)

	for i, v in pairs(Model:GetDescendants()) do 
		if v:IsA("ParticleEmitter") then 
			v.Enabled = Bool 
		end 
	end

end

local function Transform(Unit, LastTransformation, Unit2)

	local lastTransform = Transformations[LastTransformation] :: string
	local newTransform = Transformations[LastTransformation+1] :: string


	warn(lastTransform, newTransform)
	if not newTransform then warn("no new transform") return end
	if lastTransform == newTransform then warn("Same transformation") return end

	local TModels = Unit:FindFirstChild("Transformations") :: Folder
	local PreviousModel = TModels:FindFirstChild(lastTransform) :: Model
	local NewModel = TModels:FindFirstChild(newTransform) :: Model

	local Auras = Unit:FindFirstChild("Auras") :: Folder
	local Aurafound = Auras:FindFirstChild(newTransform)

	local Face = Unit.Head:FindFirstChild(newTransform)
	local oldFace = Unit.Head:FindFirstChild(lastTransform)

	if newTransform == "MUI" then
		Transparent(TModels, 1)
		Transparent(NewModel, 0)
		if oldFace then
			oldFace.Transparency = 1
		end
		if Face then
			Face.Transparency = 0
		end
		if Transforming then return end
		if not Required then
			Required = require(script["MUI Transformation"]) 
		end
		Transforming = true
		Required:Effect(Unit2)
		Transforming = false
	else
		Transparent(TModels, 1)
		Transparent(NewModel, 0)
		EnableAura(Auras, false)
		warn("Aura Found", Aurafound)
		if Aurafound then
			EnableAura(Aurafound, true)
		end
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
	local Stacks = unit:GetAttribute("GokuStacks") or 0
	Transform(UnitCu, LastTransformation, unit)

end

return Unit