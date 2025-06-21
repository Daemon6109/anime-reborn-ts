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
	HitDelay = 1.7, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation3, unit, .7, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.emitvfx(unit.Planee)
	unit.Planee.Transparency = 1
	
	unit.PlaneeVFXENABLE.Transparency = 0
	emit.emitvfx(unit.PlaneeVFXENABLE)

			
	task.wait(0.4)
	emit.enablevfx(unit.PlaneeVFXENABLE,true)	
	
	emit.enablevfx(unit.Planee,false)	

	
	emit.enablevfx(unit.PlaneeVFXENABLE.Beams1,false)	
	emit.enablevfx(unit.PlaneeVFXENABLE.Beams2,false)	
	emit.enablevfx(unit.Torso.jump,true)
	
	task.wait(.4)
	
	local charge = script["Excalibur Morgan"]:Clone() 
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-.86,0)
	emit.emitvfx(charge)
	emit.enablevfx(charge,true)
	
	unit.PlaneeVFXENABLE.Shards.Impact:Emit(7)
	
	for i, v in pairs(charge:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				v.Width0 = 0
				v.Width1 = 0
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
			--	TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
			--	TweenComplete:Play()
				task.wait(1)
				
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
			end
		end)
	end	
	debris.AddItem(charge,3)	
	
	emit.enablevfx(unit.PlaneeVFXENABLE.Beams1,true)	
	
	for i, v in pairs(unit.PlaneeVFXENABLE:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				v.Width0 = 0
				v.Width1 = 0
					
				print(v.Width0)
				print("beambam")
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
				
				
			end
		end)
	end		
	
	task.wait(.51)
	unit.PlaneeVFXENABLE.Shards.ImpactUP:Emit(7)
	unit.PlaneeVFXENABLE.Shards.ImpactUP3:Emit(7)

	emit.emitvfx(charge)
	emit.enablevfx(unit.PlaneeVFXENABLE.Beams2,true)	

	for i, v in pairs(unit.PlaneeVFXENABLE.Beams2:GetDescendants()) do -- tween for making the beams appear smooth
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
	
	task.wait(1)
	
	emit.enablevfx(unit.PlaneeVFXENABLE.Beams1,false)	
	
	task.wait(.2)
	
	
	local impactgragra = script["Excalibur MorganImpact"]:Clone() 
	impactgragra.Parent = workspace.Effects
	impactgragra.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) + Vector3.new(0,-.3,0)
	impactgragra.Paticlepart.CFrame = rt.CFrame + (rt.CFrame.LookVector * 25) + Vector3.new(0,-1.5,0)
	emit.enablevfx(unit.PlaneeVFXENABLE,false)	

	emit.emitvfx(impactgragra)
	emit.enablevfx(impactgragra,true)
	for i, v in pairs(impactgragra:GetDescendants()) do -- tween for making the beams appear smooth
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
			end
		end)
	end		
	
	task.wait(.7)
	emit.enablevfx(charge,false)

	emit.emitvfx(impactgragra)
	emit.enablevfx(impactgragra,false)
	
	emit.enablevfx(unit.Torso.jump,false)

	emit.emitvfx(unit.Planee)
	unit.Planee.Transparency = 0

	unit.PlaneeVFXENABLE.Transparency = 1
	emit.emitvfx(unit.PlaneeVFXENABLE)
	emit.enablevfx(unit.PlaneeVFXENABLE,false)	
	emit.enablevfx(unit.Planee,true)	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
