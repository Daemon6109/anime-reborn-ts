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
	HitDelay = 1.1, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .225, -- delay between hits in a multi-hit move
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
	
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.2)
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})


	local Start = script.ChouMakouhouCharge:Clone() 
	Start.Parent = workspace.Effects
	Start.CFrame = rt.CFrame + (rt.CFrame.LookVector * .3) + Vector3.new(0,.5,0)
	EmitParticles(Start)
	debris.AddItem(Start,3)
	
	task.wait(.5)
	
	for i=0,7,1 do
		task.wait(.2)
		task.spawn(function()
			
			local mouthblast = script.ChouMakouhouAtMouth:Clone() 
			mouthblast.Parent = workspace.Effects
			mouthblast.CFrame = rt.CFrame + (rt.CFrame.LookVector * .3) + Vector3.new(0,.5,0)
			emit.emitvfx(mouthblast)
			debris.AddItem(mouthblast,3)
			
			task.wait(.15)

			local blast = script.ChouMakouhouImp:Clone() 
			blast.Parent = workspace.Effects
			blast.CFrame = pos.CFrame + Vector3.new(math.random(-2,2),0,math.random(-2,2))
			emit.emitvfx(blast)
			debris.AddItem(blast,3)
			
		end)
		
	end

	task.wait(1)
	
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
