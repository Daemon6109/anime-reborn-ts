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
	
	
	--local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.2, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(0.35)
	unit.Torso.tp:Emit(25)
	task.wait(0.1)
	rt.CFrame = CFrame.new(pos.Position.X,rt.Position.Y,pos.Position.Z)  *CFrame.new(0,0,0) * CFrame.Angles(math.rad(rt.Orientation.X),math.rad(rt.Orientation.Y),math.rad(rt.Orientation.Z) ) 
	unit.Torso.tp:Emit(25)
	rt.CFrame = rt.CFrame + (rt.CFrame.LookVector * -1)

	local Slash1 = script:WaitForChild("Slash1"):Clone()
	Slash1.Parent = effectsfolder
	Slash1.CFrame = rt.CFrame
	debris.AddItem(Slash1,5)

	local Slash2 = script:WaitForChild("Slash2"):Clone()
	Slash2.Parent = effectsfolder
	Slash2.CFrame = rt.CFrame
	debris.AddItem(Slash2,5)

	task.wait(0.5)

	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})

	task.wait(0.75)

	EmitParticles(Slash1)
	task.wait(0.3)
	EmitParticles(Slash2)

	local punch = script:WaitForChild("Punch"):Clone()
	punch.Parent = effectsfolder
	punch.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	debris.AddItem(punch,5)
	emit.emitvfx(punch)

	task.wait(.75)

	task.wait(0.3)
	unit.Torso.tp:Emit(25)
	task.wait(0.35)
	rt.CFrame = startpos
	unit.Torso.tp:Emit(25)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
