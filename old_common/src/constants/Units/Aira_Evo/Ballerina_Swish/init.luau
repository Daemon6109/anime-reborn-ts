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
	HitDelay = 2.1, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	local ta = script.Attack2:FindFirstChild("ta"):Clone()
	ta.rtt.CFrame = rt.CFrame * CFrame.new(0,0,0)
	ta.Parent = effectsfolder
	debris.AddItem(ta,5)

	EmitParticles(ta)



	task.wait(1.333)



	local a = tween_service:Create(rt,TweenInfo.new(0.45,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame}):Play()

	task.wait(0.45)


	local Model = script.Attack2:FindFirstChild("Model"):Clone()
	Model.root.CFrame = rt.CFrame * CFrame.new(0,0,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)	

	emit.enablevfx(Model,true)

	wait(1.75)

	emit.enablevfx(Model,false)



	local ta1 = script.Attack2:FindFirstChild("wS"):Clone()
	ta1.CFrame = unit.Torso.CFrame * CFrame.new(0,0,0)
	ta1.Parent = effectsfolder
	debris.AddItem(ta1,5)

	ta1.CFrame = CFrame.new(ta1.Position, startpos.Position)



	EmitParticles(ta1)



	task.wait(0.001)



	rt.CFrame = startpos

	task.wait(0.25)

	local aa = script.Attack2:FindFirstChild("aa"):Clone()
	aa.CFrame = startpos * CFrame.new(0,-1,0)
	aa.Parent = effectsfolder
	debris.AddItem(aa,5)




	EmitParticles(aa)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
