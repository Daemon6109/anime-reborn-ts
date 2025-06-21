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
	HitDelay = .75, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector
	
	task.wait(.6)
	
	
	local slash = script.Slash:Clone() 
	slash.Parent = workspace.Effects
	slash.CFrame = rt.CFrame 
	emit.enablevfx(slash,true)
	debris.AddItem(slash,3)
	local slashbac = script.Slashbac:Clone() 
	slashbac.Parent = workspace.Effects
	slashbac.CFrame = rt.CFrame 
	emit.enablevfx(slashbac,true)
	debris.AddItem(slashbac,3)

	local impact3 = script["Slash Spawn"]:Clone() 
	impact3.Parent = workspace.Effects
	impact3.CFrame = rt.CFrame 
	debris.AddItem(impact3,3)
	emit.emitvfx(impact3)

	for i, v in pairs(slash:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1


				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				task.wait(.3)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()

			end
		end)
	end		

	local TweenCompletepo = tween_service:Create(slash,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = startpos + (startpos.LookVector * 25) })
	TweenCompletepo:Play()
	local TweenCompletepo = tween_service:Create(slashbac,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = startpos + (startpos.LookVector * 25) })
	TweenCompletepo:Play()
	task.wait(.3)
	emit.enablevfx(slashbac,false)

	local impact = script["Slash End"]:Clone() 
	impact.Parent = workspace.Effects
	impact.CFrame = slash.CFrame 
	debris.AddItem(impact,3)
	emit.emitvfx(impact)
	emit.enablevfx(slash,false)


	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
