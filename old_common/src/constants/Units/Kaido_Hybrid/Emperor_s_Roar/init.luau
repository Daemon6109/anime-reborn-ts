local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .375, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	
	
	local Model = script.Move2:FindFirstChild("Model"):Clone()
	Model.Parent = workspace.Effects
	debris.AddItem(Model,5)
	Model.part.CFrame = rt.CFrame * CFrame.new(0,-1,0)

	local ac = script.Move2:FindFirstChild("ac"):Clone()
	ac.Parent = workspace.Effects
	debris.AddItem(ac,5)
	ac.CFrame = rt.CFrame * CFrame.new(0,0,0)

	local initial = script.Move2:FindFirstChild("initial"):Clone()
	initial.Parent = workspace.Effects
	debris.AddItem(initial,5)
	initial.CFrame = rt.CFrame * CFrame.new(0,-1.85,0)

	SoundWrapper:PlaySound(script["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	SoundWrapper:PlaySound(script["haki2"], rt, Replicated.SoundGroups.UnitSFX)
	wait(0.1)
	SoundWrapper:PlaySound(script["startup"], rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(script["body-collapse02"], rt, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(initial,true)
	emit.enablevfx(ac,true)
	

	task.spawn(function()
		for i=0,6,1 do
			task.wait(.05)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 20, 20)),0.00000000005,.5,"Mid",true,5,.5,3.6)
		end
	end)
	
	wait(0.2)



	SoundWrapper:PlaySound(script["Laugh"], rt, Replicated.SoundGroups.UnitSFX)
	
	wait(0.2)

	emit.emitvfx(unit.Head.emit)

	emit.enablevfx(ac,false)
	emit.enablevfx(Model,true)

	wait(2.6)


	SoundWrapper:PlaySound(script["bless09"], rt, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(initial,false)

	emit.emitvfx(unit.Head.emit)

	emit.enablevfx(Model,false)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
