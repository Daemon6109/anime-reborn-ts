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
	HitDelay = .8, -- seconds
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



function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
		
	local Ball = script["Orb"]:Clone() 
	Ball.Parent = effectsfolder
	Ball.CFrame = rt.CFrame + (rt.CFrame.LookVector * .6) + (rt.CFrame.RightVector * 0.5)
	emit.enablevfx(Ball,true)
	emit.emitvfx(Ball)
	debris.AddItem(Ball, 5)
		
	task.wait(.4)
	local TP = script.EvilEyeTp:Clone() 
	TP.Parent = workspace.Effects
	TP.CFrame = rt.CFrame
	debris.AddItem(TP,3)

	emit.emitvfx(TP)
	
	local TweenCompletepo = tween_service:Create(Ball,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position = pos.Position})
	TweenCompletepo:Play()	

	emit.emitvfx(Ball)
	
	task.wait(.2)
	pcall(function()
		SoundWrapper:PlaySound(script["Explosion"], rt, Replicated.SoundGroups.UnitSFX)
	end)
	emit.enablevfx(Ball,false)
	Ball.Transparency = 1
	
	local Impact = script["Explosion"]:Clone() 
	Impact.Parent = effectsfolder
	Impact.Position = pos.Position + Vector3.new(0,-1,0)
	emit.emitvfx(Impact)
	debris.AddItem(Impact, 1)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
