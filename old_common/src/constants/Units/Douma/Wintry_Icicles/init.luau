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
	HitDelay = 1.15, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
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
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	

	

	local charge = script.Charge:Clone()
	charge.Parent = effectsfolder
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	debris.AddItem(charge, 4)
	emit.enablevfx(charge,true)

	task.wait(.5)

	for i=0,10,1 do
		task.wait(.065)
		task.spawn(function()

			local Iceshard = script.IceShard:Clone() 
			Iceshard.Parent = workspace.Effects
			Iceshard.Position = pos.Position + Vector3.new(math.random(-7,7),12,math.random(-7,7))
			emit.emitvfx(Iceshard.Impact)
			debris.AddItem(Iceshard,3)	

			local oldsize = Iceshard.Size
			Iceshard.Size = Vector3.new(0,0,0)

			local TweenComplete = tween_service:Create(Iceshard,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = oldsize})
			TweenComplete:Play()

			task.wait(.15)

			emit.emitvfx(Iceshard)
			emit.enablevfx(Iceshard,true)


			local TweenComplete = tween_service:Create(Iceshard,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position = Iceshard.Position + Vector3.new(0,-13,0)})
			TweenComplete:Play()

			task.wait(.2)
			emit.enablevfx(Iceshard,false)

			Iceshard.Transparency = 1
			local imp = script.ShardGroundHit:Clone()
			imp.Parent = effectsfolder
			imp.Position = Iceshard.Position
			debris.AddItem(imp, 4)
			emit.emitvfx(imp)
		end)
	end

	emit.enablevfx(charge,false)
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
