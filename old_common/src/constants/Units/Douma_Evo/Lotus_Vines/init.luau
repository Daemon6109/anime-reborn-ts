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
	HitDelay = 1.6, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.2, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local charge = script.Charge:Clone() 
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1.3,0)
	emit.enablevfx(charge,true)
	debris.AddItem(charge,3)

	task.wait(1.15)
	
	
	local groundfx = script.Skill2Ground:Clone() 
	groundfx.Parent = workspace.Effects
	groundfx.Position = rt.Position + Vector3.new(0,-1.3,0)
	debris.AddItem(groundfx,3)	
	emit.emitvfx(groundfx)
	
	
	for i = 0,7,1 do
		task.wait(.025)
		task.spawn(function()
			
			--local endposs = rt.CFrame + (rt.CFrame.LookVector * math.random(12,15)) + (rt.CFrame.RightVector * math.random(-3,3))
				
			local Vine = script.Vine:Clone() 
			Vine.Parent = workspace.Effects
			Vine.CFrame = rt.CFrame 
			Vine["Vine.001"].CFrame = rt.CFrame

			debris.AddItem(Vine,3)	

			local oldsize = Vine.Size
			Vine.Size = Vector3.new(0,0,0)
			Vine["Vine.001"].Size = Vector3.new(0,0,0)
			emit.enablevfx(Vine,true)

			local extendsize = Vector3.new(oldsize.X, oldsize.Y, (pos.Position - Vine.Position).Magnitude + 1)
			
			
			Vine.Orientation = Vector3.new(math.random(-180,180),math.random(-180,180),math.random(-180,180))
			Vine["Vine.001"].Orientation = Vector3.new(math.random(-180,180),math.random(-180,180),math.random(-180,180))

			local endposs = Vine.CFrame + (Vine.CFrame.LookVector * math.random(12,15))
		
			local VineSend = script.VineSend:Clone() 
			VineSend.Parent = workspace.Effects
			VineSend.CFrame = Vine.CFrame + (Vine.CFrame.LookVector * 6)
			debris.AddItem(VineSend,3)	
			emit.emitvfx(VineSend)
		
			local TweenComplete = tween_service:Create(Vine,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = extendsize})
			TweenComplete:Play()
			local TweenComplete = tween_service:Create(Vine["Vine.001"],TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = extendsize})
			TweenComplete:Play()
			
			local TweenComplete = tween_service:Create(Vine["Vine.001"],TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{CFrame = endposs + (rt.CFrame.LookVector * -8)})
			--TweenComplete:Play()
			local TweenComplete = tween_service:Create(Vine,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{CFrame = endposs + (rt.CFrame.LookVector * -8) })
		--	TweenComplete:Play()
		
		
			--Vine.CFrame = CFrame.lookAt(Vine.Position, endposs.Position)
			Vine["Vine.001"].CFrame = CFrame.lookAt(Vine["Vine.001"].Position, endposs.Position)
			
			--print("abc")
			
			local VineSend = script.VineSend:Clone() 
			VineSend.Parent = workspace.Effects
			VineSend.CFrame = Vine.CFrame + (rt.CFrame.LookVector * 1)
			debris.AddItem(VineSend,3)	
			--emit.emitvfx(VineSend)
			
			task.wait(1.2)
			emit.enablevfx(Vine,false)
			emit.emitvfx(Vine)
			Vine.Transparency = 1
			Vine["Vine.001"].Transparency = 1
			
			
		end)
		
	end
	emit.enablevfx(charge,false)
	
	task.wait(1.2)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
