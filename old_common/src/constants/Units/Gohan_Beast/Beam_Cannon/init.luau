local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 1.9, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
	EndingDelay = .4
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	
	AnimModule.PlayAnim(script.attk3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3"], rt, Replicated.SoundGroups.UnitSFX)
	
	local summonPart = Instance.new("Part")
	summonPart.Anchored = true
	summonPart.Parent = effectsfolder
	summonPart.CFrame = rt.CFrame
	summonPart.CanTouch = false
	summonPart.CanCollide = false
	summonPart.Transparency = 1
	summonPart.CFrame = rt.CFrame 
	debris.AddItem(summonPart,10)


	local a =  script.attack3:FindFirstChild("a"):Clone()
	a.Parent = effectsfolder
	a.jump.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	debris.AddItem(a,7)
	emit.emitvfx(a)




	wait(0.9)
	emit.emitvfx(unit["Right Arm"].Enableta)
	emit.emitvfx(unit["Left Arm"].Enableta)

	emit.enablevfx(unit["Right Arm"].Enableta,true)

	emit.enablevfx(unit["Left Arm"].Enableta,true)

	local shoottween = tween_service:Create(rt,TweenInfo.new(0.4,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = rt.CFrame * CFrame.new(0,8,0)}):Play()
	wait(0.4)

	local Model1 =  script.attack3:FindFirstChild("Model1"):Clone()
	Model1.Parent = effectsfolder
	Model1.root.CFrame = rt.CFrame * CFrame.new(0,1,1)
	debris.AddItem(Model1,5)

	emit.enablevfx(Model1,true)

	wait(0.2)


	local FinalImpact =  script.attack3:FindFirstChild("FinalImpact"):Clone()
	FinalImpact.Parent = effectsfolder
	FinalImpact.RootPart.CFrame = rt.CFrame * CFrame.new(0,1,.5)
	debris.AddItem(FinalImpact,5)

	local Model =  script.attack3:FindFirstChild("Model"):Clone()
	Model.Parent = effectsfolder
	Model.root.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	debris.AddItem(Model,5)

	local ExplosionImpact1 =  script.attack3:FindFirstChild("ExplosionImpact"):Clone()
	ExplosionImpact1.Parent = effectsfolder
	ExplosionImpact1.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	debris.AddItem(ExplosionImpact1,5)

	FinalImpact.RootPart.CFrame = CFrame.new(FinalImpact.RootPart.Position, pos.Position)



	task.wait(0.001)

	FinalImpact.end1.Anchored = true
	task.wait(0.001)


	local shoottween = tween_service:Create(FinalImpact.end1,TweenInfo.new(0.175,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,-1,0)}):Play()

	emit.emitvfx(FinalImpact.wS)

	wait(0.175)

	emit.enablevfx(Model1,false)

	emit.enablevfx(unit["Right Arm"].Enableta,false)

	emit.enablevfx(unit["Left Arm"].Enableta,false)

	emit.emitvfx(ExplosionImpact1)

	emit.enablevfx(Model,true)

	wait(0.85)

	emit.enablevfx(Model,false)

	emit.emitvfx(FinalImpact.wS)

	for i, v in pairs(FinalImpact.end1:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.175,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end


	emit.enablevfx(FinalImpact,false)

	wait(0.35)
	local shoottween = tween_service:Create(rt,TweenInfo.new(0.5,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = summonPart.CFrame}):Play()

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
