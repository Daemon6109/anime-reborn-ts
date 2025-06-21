local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)
local GameVariables = Replicated:WaitForChild("GameVariables")

module.config = {
	HitDelay = .25, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	AnimModule.PlayAnim(script.Anim, unit, 1, script.Anim, {Weight = 2, Fade = .15})
	task.wait(.25)

	for i = 1, 4 do
		local Effect = script[tostring(i)]:Clone()
		Effect.CFrame = rt.CFrame * CFrame.new(0, -1, 0)
		Effect.Parent = workspace.Effects
		VFXModule.Debris(Effect, 3)
		VFXModule.Emit(Effect)

		task.wait(.25)
	end

	local CC = script.CC:Clone()
	CC.Parent = game.Lighting
	VFXModule.Debris(CC, 4)
	VFXModule.Emit(CC)

	local CCContrast, CCSaturation = CC.Contrast, CC.Saturation
	CC.Contrast, CC.Saturation = 0, 0
	TweenService:Create(CC, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Contrast = CCContrast, Saturation = CCSaturation}):Play()
	task.spawn(function()
		task.wait(4/GameVariables.GameSpeed.Value)
		TweenService:Create(CC, TweenInfo.new(.35, Enum.EasingStyle.Quad), {Contrast = 0, Saturation = 0}):Play()
	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
