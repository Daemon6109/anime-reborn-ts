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
	HitDelay = 0.6, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
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
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector

	task.wait(.35)
	
	local function spearspawn(lookat)
		task.spawn(function()
			local Spear = script.Spear:Clone()
			Spear.CFrame = rt.CFrame + (rt.CFrame.LookVector * 0.5) 
			Spear.Parent = effectsfolder
			debris.AddItem(Spear,5)
			emit.emitvfx(Spear)
			emit.enablevfx(Spear,true)

			--Spear.CFrame = CFrame.lookAt(Spear.Position, lookat)


			for i, v in pairs(Spear:GetDescendants()) do -- tween for making the beams appear smooth
				task.spawn(function()
					if v:IsA("Beam") then
						local oldbeamsize = v.Width0
						local oldbeamsize2 = v.Width1
						v.Width0 = 0
						v.Width1 = 0
						local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
						TweenComplete:Play()
						local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
						TweenComplete:Play()
					end
				end)
			end	

			local TweenCompletepo = tween_service:Create(Spear,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = lookat})
			TweenCompletepo:Play()
			
			task.wait(.3)
			SoundWrapper:PlaySound(script.Parent.Explosion, rt, Replicated.SoundGroups.UnitSFX)
			local Impact = script.Explosion:Clone()
			Impact.Position = Spear.Position
			Impact.Parent = effectsfolder
			debris.AddItem(Impact,5)
			emit.emitvfx(Impact)
			emit.enablevfx(Spear,false)
		end)
	end
		
	spearspawn(rt.CFrame + (rt.CFrame.RightVector * 5) + (rt.CFrame.LookVector * 15))	
	spearspawn(rt.CFrame + (rt.CFrame.RightVector * -5) + (rt.CFrame.LookVector * 15))	
	spearspawn(rt.CFrame + (rt.CFrame.LookVector * 15))	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
