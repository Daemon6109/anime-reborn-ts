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
	HitDelay = 1.8, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.6, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.3)
	
	emit.enablevfx(unit["Right Arm"].Icebvall,true)
	emit.emitvfx(unit["Right Arm"].Icebvall)
	
	task.wait(1.2)
	
	emit.emitvfx(unit.Torso.jump)

	local ball = script.IceBall:Clone() 
	ball.Parent = workspace.Effects
	ball.CFrame = unit["Right Arm"].Icebvall.WorldCFrame
	debris.AddItem(ball,3)
	emit.enablevfx(ball,true)
	emit.emitvfx(ball)
	emit.enablevfx(unit["Right Arm"].Icebvall,false)
	emit.emitvfx(unit["Right Arm"].Icebvall)

	local TweenComplete = tween_service:Create(ball,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position =pos.Position})
	TweenComplete:Play()

	task.wait(.25)
	emit.enablevfx(ball,false)

	local Impact = script["Retopo_Cube.002"]:Clone()
	Impact.Position = pos.Position + Vector3.new(0,1,0)
	Impact["Retopo_Cube.002"].Position = pos.Position + Vector3.new(0,1,0)
	Impact.Parent = effectsfolder
	debris.AddItem(Impact,3)
	emit.emitvfx(Impact)
	emit.enablevfx(Impact,true)
	
	local oldsize = Impact.Size
	Impact.Size = Vector3.new(0,0,0)
	local TweenComplete = tween_service:Create(Impact,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = oldsize})
	TweenComplete:Play()
	
	local oldsize = Impact["Retopo_Cube.002"].Size
	Impact["Retopo_Cube.002"].Size = Vector3.new(0,0,0)
	local TweenComplete = tween_service:Create(Impact["Retopo_Cube.002"]	,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = oldsize})
	TweenComplete:Play()
	
	
	task.wait(.4)	
	
	local ImpactLast = script["Part"]:Clone()
	ImpactLast.Position = Impact.Position + Vector3.new(0,-1.7,0)
	ImpactLast.Parent = effectsfolder
	debris.AddItem(ImpactLast,3)
	emit.emitvfx(ImpactLast)
	
	Impact["Retopo_Cube.002"].Transparency = 1
	Impact.Transparency = 1
	emit.enablevfx(Impact,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
