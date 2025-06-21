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
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .27, -- delay between hits in a multi-hit move
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
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	tween_service:Create(unit.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0}):Play()

	task.wait(1)

	local Shoot = script.Move1.Shoot:Clone()
	Shoot.Parent = effectsfolder
	Shoot.CFrame = rt.CFrame * CFrame.new(0,0,-5)
	for _, particle in pairs(Shoot:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end
	debris.AddItem(Shoot,6)

	task.wait(0.25)

	for _, particle in pairs(Shoot:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end

	task.wait(0.25)

	for _, particle in pairs(Shoot:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end

	task.wait(2)

	tween_service:Create(unit.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()

	--humanoid:LoadAnimation(animations.attk1):Stop()

	task.wait(0.1)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
