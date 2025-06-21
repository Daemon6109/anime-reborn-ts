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
	HitDelay = 1.65, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .3, -- delay between hits in a multi-hit move
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

local rand = Random.new()


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local heartt = script.KissPistol:Clone()
	heartt.Parent = unit["Right Arm"]
	heartt.CFrame = unit["Right Arm"].CFrame * CFrame.new(0, -2, 0)
	debris.AddItem(heartt, 5)

	local weld = Instance.new("Motor6D")
	weld.Parent = unit["Right Arm"]
	weld.Part0 = unit["Right Arm"]
	weld.Part1 = heartt
	weld.C1 = CFrame.new(0, 0.525, 0)

	emit.enablevfx(heartt,true)

	local slavearrow = script.SlaveArrow:Clone()
	slavearrow.Parent = effectsfolder
	slavearrow.CFrame = rt.CFrame * CFrame.new(0,0,-1)
	slavearrow.Sideline.CFrame = rt.CFrame + (rt.CFrame.LookVector * 7.5) + Vector3.new(0,-1.25,0) + (rt.CFrame.RightVector * -1.5)
	slavearrow.Sideline2.CFrame = rt.CFrame + (rt.CFrame.LookVector * 7.5) + Vector3.new(0,-1.25,0)+ (rt.CFrame.RightVector * 1.5)

	emit.emitvfx(unit.Torso.jump)

	debris.AddItem(slavearrow,5)

	task.wait(.85)
	emit.enablevfx(heartt,false)

	emit.enablevfx(slavearrow,true)

	task.wait(2)

	emit.enablevfx(slavearrow,false)

 
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
