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
local rn = game:GetService("RunService")

module.config = {
	HitDelay = .7, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.15, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.15)
	
	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.35)
	
	task.spawn(function()
		for i=0,8,1 do
			task.wait(.06)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(39, 143, 255)),0.00000000005,.5,"Long",true,5,.5,1.1)
		end
	end)
	
	local endpos = startpos + (startpos.LookVector * 15)
	
	local front = script.ArlongThing:Clone()
	front.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	front.Parent = effectsfolder
	debris.AddItem(front,3)
	emit.enablevfx(front,true)

	local TweenComplete = tween_service:Create(rt,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = endpos})
	TweenComplete:Play()

	local TweenComplete = tween_service:Create(front,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = endpos + (startpos.LookVector * 1.3)})
	TweenComplete:Play()

	
	task.wait(.8)
	
	emit.enablevfx(front,false)

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
