local module = {}
local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local vfx_custom = require(Replicated:WaitForChild("Libs"):WaitForChild("VFX_Custom"))
local Run = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Sound = script.SFX
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = .8, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
	Speed = 80,
}

function module:Effect(Tab)

	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local hum = unit:FindFirstChild("Humanoid")
	local SavedDirection = rt.CFrame.LookVector
	local Enemy = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	local o = rt.CFrame

	local anim = AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(Sound.Slash, rt, Replicated.SoundGroups.UnitSFX)
	task.wait(.15)
	SoundWrapper:PlaySound(Sound.Flash, rt, Replicated.SoundGroups.UnitSFX)
	for i=1, 5 do
		local Explosion = script.SpearExplosion:Clone()
		Explosion.CFrame = CFrame.new(pos.Position) * CFrame.new(0, -1, 0)
		Explosion.Parent = workspace.Effects
		VFXModule.Emit(Explosion)
		VFXModule.Debris(Explosion, 3)
		task.wait(0.15)
	end
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
