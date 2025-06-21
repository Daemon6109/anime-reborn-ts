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
	HitDelay = .45, -- seconds
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
	
	
	unit.Torso.tp:Emit(20)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1.5)
	task.wait(.05)
	unit.Torso.tp:Emit(20)

	unit["Right Arm"].Axe.Transparency = 0
	
	for i, v in pairs(unit["Right Arm"].Axe:GetDescendants()) do
		v.Transparency = 0
	end
	

	task.wait(.4)
	local BloodEffect = script.BloodEffect:Clone()
	BloodEffect.Parent = effectsfolder
	BloodEffect.CFrame = rt.CFrame * CFrame.new(0,0,-3)


	for i,v in pairs(BloodEffect:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
	
	game.Debris:AddItem(BloodEffect,6)
	
	task.wait(.3)
	unit["Right Arm"].Axe.Transparency = 1

	for i, v in pairs(unit["Right Arm"].Axe:GetDescendants()) do
		v.Transparency = 1
	end
	
	task.wait(.3)
	
	unit.Torso.tp:Emit(20)
	rt.CFrame = startpos
	task.wait(.05)
	unit.Torso.tp:Emit(20)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
