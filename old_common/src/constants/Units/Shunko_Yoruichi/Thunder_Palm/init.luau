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
	HitDelay = 1.1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Thirdattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["3"], rt, Replicated.SoundGroups.UnitSFX)
	
	unit.Torso.lightning.Enabled = true
	unit.Torso.lightning1.Enabled = true
	
	task.wait(.6)

	local hit = script.thunderblast:Clone()  
	hit.Parent = workspace.Effects
	hit.CFrame = rt.CFrame + (rt.CFrame.LookVector * 3) 
	hit.CFrame = CFrame.lookAt(hit.Position, pos.Position)

	emit.emitvfx(hit)

	task.spawn(function()
		local meshvf = script.Shockwvae:Clone() -- vfx
		meshvf.Parent = workspace.Effects
		meshvf.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * -.6)
		meshvf.Orientation = meshvf.Orientation + Vector3.new(90,0,0)
		
		spr.target(meshvf, 1.3, 1.3, {Size = Vector3.new(22.615, 0.756, 22.615)})

		local TweenComplete = tween_service:Create(meshvf,TweenInfo.new(.6,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Transparency = 1})
		TweenComplete:Play()
		task.wait(.6)
		meshvf:Destroy()
	end)

	emit.emitbeam(hit.beamemits,0.3,0.9,.7)
	
	rocksmodule.Trail(rt.Position + Vector3.new(0,-1,0),rt, 20, Vector3.new(.6, .6, .6), nil, 22, .75)
	unit.Torso.lightning.Enabled = false
	unit.Torso.lightning1.Enabled = false

	task.wait(1)
		
	debris.AddItem(hit,1)

	task.wait(1.5)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
