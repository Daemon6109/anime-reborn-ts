local Unit = {}
local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)

setmetatable(Unit,{__index = require(replicated.Registry.UnitBaseMethods)})

--Unit.height = .15
Unit.Radius = 3
Unit.Tradable = true

Unit.configuration = {
	CameraOffset = CFrame.new(-.5,0,.05),
	CameraZoom = 65,
	Viewport = CFrame.new(-.6, .4, -2)*CFrame.Angles(0,math.rad(200),0) :: CFrame,
	PreviewViewport = CFrame.new(0.5, -0.02, -3) * CFrame.Angles(0,math.rad(-160),0) :: CFrame,
	UnitCardViewport = (CFrame.new(.45, .65, -1)*CFrame.Angles(0,math.rad(180),0))*CFrame.Angles(0,math.rad(-20),0) :: CFrame,
	MaxPlacementAmount = 2 :: number,
	MaxUpgrades = 5 :: number,
	SellCost = 100 :: number,
	--============================--
	TrueName = script.Name:: string,
	DisplayName = "Delta Brothers" :: string,
	Rarity = "Secret" :: Enums.Rarities ,
	--============================--
	PlacementType = "Ground" :: Enums.PlacementTypes,
	Element = "Light" :: Enums.Elements,
	UnitType = "Ground" :: Enums.UnitType, --
	--============================--
	PlacementPrice = 2000 :: number,
	CanSell = true :: boolean,
	--============================--
	Passives = {"Delta One"},
	Damage = 550 :: number,
	AttackSpeed = 10 :: number,
	Range = 15 :: number,
	Ability = "Blaster Shots" :: string, -- starting ability
	SpecialAbility = "" :: string,
	SpecialAbilityCooldown = 0 :: number, -- in seconds
	IsSpecialAbilityGlobalCooldown = false :: boolean, -- if true then all the same units share global special cooldown
	Money = 0 :: number, -- for farms
	--============================--
	AttackType = "Cone" :: Enums.AttackTypes,
	AttackSize = 20 :: Enums.AttackSizeTypes,
	AttackEffect = "", --effects that applies on the enemy when attacked
	AttackEffectDuration = 0,
	AttackCriticalChance = 0.05,
	AttackCriticalDamage = .3,
	--============================--
	EvolveData = { -- If this exists, the unit will be evolvable
		{
		Requirements = { -- Requirements to evolve. All of them are optional. Subtracts the requirements from the player's inventory

			Items = { -- List of items to check. Index = name, Value = amount
				["RedBlaster"] = 1,
				["BlueBlaster"] = 1,
				["RainbowStar"] = 2,
				["LightStone"] = 5,				
			};

			Units = { -- List of units to check. Index = name, Value = amount. The old unit is checked and subtracted from the player's inventory automatically

			};

			--CheckFunction = function(player: Player): boolean? -- Must return true to proceed! Doesn't need to exist
			--	return true
			--end,
		};
		
		DisplayBuffs = {
			"+20% Damage";
			"+1 New Special Move: Core Breaker";
			"+1 New Passive: Delta Two";
		};

		TransferStats = true :: boolean?; -- Whether to transfer stats like Level from the old unit when evolving

		EvolvesInto = "Gamma Brothers [Evo]" :: string; -- The unit to evolve into
		}
	};
	--============================--
	UpgradesInfo = {
		[1] = {
			Damage = 630,
			AttackSpeed = 9,
			Range = 15,
			UpgradePrice = 2500,
		},
		[2] = {
			Damage = 730,
			AttackSpeed = 9,
			Range = 18,
			UpgradePrice = 3000,
		},
		[3] = {
			Damage = 930,
			AttackSpeed = 8,
			Range = 20,
			UpgradePrice = 4000,
		},
		[4] = {
			Damage = 1050,
			AttackSpeed = 8,
			Range = 20,
			UpgradePrice = 5000,
		
		},
		[5] = {
			Damage = 1300,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 5750,
			UnitType = "Hybrid",
			Ability = "Delta Impact",
			AttackSize = 15,
			AttackType = "Circle",
		},
		[6] = {
			Damage = 1500,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 6600,
		},
		[7] = {
			Damage = 1740,
			AttackSpeed = 8,
			Range = 22,
			UpgradePrice = 9000,
		},
		[8] = {
			Damage = 1850,
			AttackSpeed = 9,
			Range = 22,
			UpgradePrice = 10200,
			Ability = "Super Delta Blast",
			AttackSize = 10,
			AttackType = "Line",
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
	idle = "75256281553824",
	walk = "17264216432",
	IdleG1 = "100987371000238",
	IdleG2 = "76242587909173",
	leftwalk = "86422637935687",
	rightwalk = "106582949256031", 
}

Unit:CacheAbilities()

--function Unit:CustomPlace(UnitAdded)
--	local UnitsRegistry = _G.Registry.registry.Units
--	local http = game:GetService("HttpService")
--	local plr = game.Players.LocalPlayer
--	task.spawn(function()
--		local FoundDataInRegistry = UnitsRegistry[UnitAdded.Name]

--		if not UnitAdded:HasTag("customized") and FoundDataInRegistry then
--			local _RegistryUnitData = UnitsRegistry[UnitAdded.Name]
--			local _UnitHeight = _RegistryUnitData.height
--			local HeightCFrame = CFrame.new(0,0,0)

--			if _UnitHeight then
--				HeightCFrame = CFrame.new(0,_UnitHeight,0)
--			end

--			local ModelToCustomize = FoundDataInRegistry:GetModel({Shiny = UnitAdded:HasTag("Shiny")}):Clone() --.misc.Model:Clone()
--			ModelToCustomize.Name = http:GenerateGUID(false)
--			ModelToCustomize:SetAttribute("UnitName", UnitAdded.Name)
--			ModelToCustomize:PivotTo(UnitAdded:GetPivot()*HeightCFrame)

--			local size = ModelToCustomize:GetExtentsSize()

--			local Height = size.Y

--			xpcall(function()
--				local FoundHum = ModelToCustomize.Humanoid
--				FoundHum.EvaluateStateMachine = false

--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
--				FoundHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)

--				FoundHum.DisplayName = ""
--				FoundHum.BreakJointsOnDeath = false
--				FoundHum.AutomaticScalingEnabled = false
--				FoundHum.AutoRotate = false
--				FoundHum.AutoJumpEnabled = false
--				FoundHum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
--				FoundHum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
--				FoundHum.JumpPower = 0
--				FoundHum.MaxHealth = 0
--				FoundHum.Health = 0
--				FoundHum.MaxSlopeAngle = 0
--				FoundHum.NameDisplayDistance = 0
--				FoundHum.NameOcclusion = Enum.NameOcclusion.OccludeAll
--				FoundHum.PlatformStand = true
--				FoundHum.UseJumpPower = true
--				FoundHum.WalkSpeed = 0
--			end, function(err)
--				warn("[CLIENT UNIT HANDLER] errored somehow while setting humanoid states?", err)
--			end)

--			task.spawn(function()
--				if UnitAdded:WaitForChild("configuration"):WaitForChild("Owner").Value == plr.Name then
--					local UnitOverhead = replicated.Other.UnitOverhead:Clone()
--					UnitOverhead.Adornee = ModelToCustomize:WaitForChild("Head")
--					UnitOverhead.Parent = ModelToCustomize.Head

--					local CircleIndicator = replicated.Effects.UnitCircle.Circle.GroundAttachment:Clone()
--					CircleIndicator.CFrame = CFrame.new(0,-(UnitAdded:WaitForChild("HumanoidRootPart").Size.Y/2+UnitAdded:WaitForChild("Left Leg").Size.Y)+0.02,0)

--					local PM = CircleIndicator.ParticleEmitter
--					local InCircle = CircleIndicator["in"]

--					local PMSize = PM.Size.Keypoints[1]
--					local InCircleSize = InCircle.Size.Keypoints

--					local PMNewSize = NumberSequence.new(_RegistryUnitData.Radius and _RegistryUnitData.Radius/2*PMSize.Value or Height/defaultHeight*PMSize.Value)
--					local BufferTable = {}

--					for i, v in ipairs(InCircleSize) do
--						BufferTable[i] = NumberSequenceKeypoint.new(v.Time, _RegistryUnitData.Radius and _RegistryUnitData.Radius/2*v.Value or Height/defaultHeight*v.Value,v.Envelope)
--					end

--					local InSizeNew = NumberSequence.new(BufferTable)

--					PM.Size = PMNewSize
--					InCircle.Size = InSizeNew


--					CircleIndicator.Parent = UnitAdded.PrimaryPart

--					ImmediatelyEmitSlowParticles(CircleIndicator)

--					local PlaceSparkles = replicated.Effects["PlaceSparkles(Mauw)"].Stars:Clone()
--					PlaceSparkles.Parent = ModelToCustomize.HumanoidRootPart
--					local PlaceDots = replicated.Effects["PlaceSparkles(Mauw)"].dots:Clone()
--					PlaceDots.Parent = ModelToCustomize.HumanoidRootPart

--					local UpgradeVFX = replicated.Effects.UpgradeVFX.UpgradeVFXPart.Upgrade:Clone()
--					UpgradeVFX.Parent = ModelToCustomize.HumanoidRootPart

--					PlaceSparkles:Emit(PlaceSparkles:GetAttribute("EmitCount"))
--					PlaceDots:Emit(PlaceDots:GetAttribute("EmitCount"))

--					SoundWrapper:PlaySound(script.Placement, ModelToCustomize, replicated.SoundGroups.GeneralSFX)

--					Debris.AddItem(PlaceSparkles, 5)
--				else
--					local CircleIndicator = replicated.Effects.UnitCircle.CircleOther.GroundAttachment:Clone()
--					CircleIndicator.CFrame = CFrame.new(0,-(UnitAdded:WaitForChild("HumanoidRootPart").Size.Y/2+UnitAdded:WaitForChild("Left Leg").Size.Y)+0.02,0)

--					local PM = CircleIndicator.ParticleEmitter
--					local InCircle = CircleIndicator["in"]

--					local PMSize = PM.Size.Keypoints[1]
--					local InCircleSize = InCircle.Size.Keypoints

--					local PMNewSize = NumberSequence.new(_RegistryUnitData.Radius and _RegistryUnitData.Radius/2*PMSize.Value or Height/defaultHeight*PMSize.Value)
--					local BufferTable = {}

--					for i, v in ipairs(InCircleSize) do
--						BufferTable[i] = NumberSequenceKeypoint.new(v.Time, _RegistryUnitData.Radius and _RegistryUnitData.Radius/2*v.Value or Height/defaultHeight*v.Value,v.Envelope)
--					end

--					local InSizeNew = NumberSequence.new(BufferTable)

--					PM.Size = PMNewSize
--					InCircle.Size = InSizeNew


--					CircleIndicator.Parent = UnitAdded.PrimaryPart

--					ImmediatelyEmitSlowParticles(CircleIndicator)
--				end

--				ModelToCustomize:AddTag("Loaded")
--			end)

--			local RootModelLink = Instance.new("ObjectValue")
--			RootModelLink.Name = "RootModelLink"
--			RootModelLink.Value = UnitAdded
--			RootModelLink.Parent = ModelToCustomize

--			local VisualModelLink = Instance.new("ObjectValue")
--			VisualModelLink.Name = "VisualModelLink"
--			VisualModelLink.Value = ModelToCustomize
--			VisualModelLink.Parent = UnitAdded

--			ModelToCustomize.Parent = workspace.UnitVisuals

--			task.spawn(function()
--				for i,v in {"Trait1", "Trait2", "Trait3"} do
--					local TraitName = UnitAdded:GetAttribute(v)
--					local TraitInRegistry = Registry.Traits[TraitName]

--					if TraitInRegistry then
--						TraitInRegistry:ApplyEffectToModel(ModelToCustomize)
--					end
--				end

--				local AOE = _G.AOE:CreateAOE(FoundDataInRegistry.configuration, ModelToCustomize)
--				if AOE then
--					AOE.Event:Fire("Hide")
--				end
--			end)

--			AnimModule.PlayAnim(replicated.Animations.Generic.Placement1, ModelToCustomize, 2, "")
--			AnimModule.PlayAnim(FoundDataInRegistry.animations.idle, ModelToCustomize, 1, "")

--			FoundDataInRegistry:customizeVisuals(plr, ModelToCustomize)

--			--repeat task.wait() until _G.clientGUIServices and _G.clientGUIServices.VFX
--		end
--	end)
--end

function Unit:customizeVisuals(plr, unit:Instance)
	local AnimModule = require(game.ReplicatedStorage.AnimModule)
	local Animations = Unit.animations

	AnimModule.PlayCustomAnim(Animations["IdleG1"], unit:WaitForChild("Gamma1"):WaitForChild("Humanoid"):WaitForChild("Animator"), 1, "Idle1", {Weight = 2, Fade = .15})
	AnimModule.PlayCustomAnim(Animations["IdleG2"], unit:WaitForChild("Gamma2"):WaitForChild("Humanoid"):WaitForChild("Animator"), 1, "Idle2", {Weight = 2, Fade = .15})
end

function Unit:onPlace(plr, unit)
end

function Unit:onDelete(plr, unit)
end

return Unit