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
	HitDelay = 1.45, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector

	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	local Model = script.Attack1:FindFirstChild("Model"):Clone()
	Model.rtt.CFrame = rt.CFrame * CFrame.new(0,0,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)
	Model.rtt.CFrame = CFrame.new(Model.rtt.Position, pos.Position)
	EmitParticles(Model)

	task.wait(0.001)

	rt.CFrame = pos.CFrame

	task.wait(0.001)
	local Model1 = script.Attack1:FindFirstChild("Model1"):Clone()
	Model1.root.CFrame = rt.CFrame * CFrame.new(0,0,0)
	Model1.Parent = effectsfolder
	debris.AddItem(Model1,5)
	EmitParticles(Model1)
	
	task.spawn(function()
		task.wait(1)
		SoundWrapper:PlaySound(script["Explosion"], rt, Replicated.SoundGroups.UnitSFX)
	end)
	task.wait(2.26)

	Model1.Part.Anchored = true
	Model1.Part.CFrame = CFrame.new(Model1.Part.Position, back.Position)

	task.wait(0.01)

	local a = tween_service:Create(rt,TweenInfo.new(0.05,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = back}):Play()

	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
