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
	HitDelay = .5, -- seconds
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



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1"], rt, Replicated.SoundGroups.UnitSFX)
	
	local summonPart = Instance.new("Part")
	summonPart.Anchored = true
	summonPart.Parent = effectsfolder
	summonPart.CFrame = rt.CFrame
	summonPart.CanTouch = false
	summonPart.CanCollide = false
	summonPart.Transparency = 1
	summonPart.CFrame = CFrame.new(summonPart.Position, pos.Position)
	debris.AddItem(summonPart,10)


	local impact =  script:FindFirstChild("impact"):Clone()
	impact.Parent = effectsfolder
	impact.CFrame = pos.CFrame * CFrame.new(0,0,0)
	impact.Orientation = Vector3.new(0, 0, 0)
	debris.AddItem(impact,5)





	for i, v in pairs(unit.teleport1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end
	task.wait(0.15)
	local shoottween = tween_service:Create(rt,TweenInfo.new(0.01,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,0,1)}):Play()
	task.wait(0.3)
	for i, v in pairs(impact:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end

	task.wait(0.5)
	
	
	for i, v in pairs(unit.teleport1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end
	task.wait(0.15)

	rt.CFrame = summonPart.CFrame

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
