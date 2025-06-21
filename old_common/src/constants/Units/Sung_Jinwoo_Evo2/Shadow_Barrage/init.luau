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
	HitDelay = 1.25, -- seconds
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

	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	local atk = script.Attack1:FindFirstChild("Model"):Clone()
	atk.Part.CFrame = rt.CFrame
	atk.Parent = effectsfolder
	debris.AddItem(atk,6)

	EmitParticles(atk)

	spawn(function()


		task.wait(1.5)

		for i, v in pairs(atk.beam:GetChildren()) do
			if v:IsA("Beam") then
				local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
			end
		end 

		task.wait(1.4)

		for i, v in pairs(atk.beam1:GetChildren()) do
			if v:IsA("Beam") then
				local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
			end
		end 

	end)


	


	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
