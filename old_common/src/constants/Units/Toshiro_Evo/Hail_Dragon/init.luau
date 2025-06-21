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
	HitDelay = 2, -- seconds
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

local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end 

				local _delay = v:GetAttribute("EmitDuration")       
				if _delay then
					v.Enabled = true
					task.delay(_delay, function()  
						v.Enabled = false
					end)
				end
			end)()
		end
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.3, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.1)

	emit.emitvfx(unit.Torso.jump)

	task.wait(.7)
	
	local dragon = script["Plane.005"]:Clone() 
	dragon.Parent = workspace.Effects
	dragon.CFrame = rt.CFrame + (rt.CFrame.LookVector * -2) + Vector3.new(0,2,0) + (rt.CFrame.RightVector * 3)
	emit.emitvfx(dragon)
	emit.enablevfx(dragon,true)
	debris.AddItem(dragon,3)	
	
	local endposs = rt.CFrame + (rt.CFrame.LookVector * 25)
	
	
	for i, v in pairs(dragon:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				v.Width0 = 0
				v.Width1 = 0
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
			end
		end)
	end	
	
	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.55)

	local TweenComplete = tween_service:Create(dragon,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = endposs + (rt.CFrame.LookVector * -2.5)  + (rt.CFrame.LookVector * 5) + Vector3.new(0,2,0)})
	TweenComplete:Play()
	
	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = (endposs + (rt.CFrame.LookVector * -2.5))})
	TweenComplete:Play()
	
	task.wait(.27)

	local impact = script.dragonimpact:Clone()
	impact.Position = dragon.Position
	impact.Parent = effectsfolder
	debris.AddItem(impact,3)
	emit.emitvfx(impact)
	
	
	emit.enablevfx(dragon,false)
	emit.emitvfx(dragon)
	
	dragon.Transparency = 1
	
	task.wait(.65)

	emit.emitvfx(unit)
	rt.CFrame = startpos
	task.wait(.05)
	emit.emitvfx(unit)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
