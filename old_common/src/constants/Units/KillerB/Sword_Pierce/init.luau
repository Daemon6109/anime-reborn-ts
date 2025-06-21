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
	HitDelay = .9, -- seconds
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
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.6, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.enablevfx(unit.Torso.jump,true)

	task.wait(.55)
	
	local slashb = script:FindFirstChild("Second moveSlash"):Clone()
	slashb.Parent = effectsfolder
	slashb.CFrame = rt.CFrame + (rt.CFrame.LookVector * .2)
	debris.AddItem(slashb, 4)
	emit.emitvfx(slashb)
	
	task.wait(.1)
	
	local slash = script.Slash:Clone()
	slash.Parent = effectsfolder
	slash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	debris.AddItem(slash, 4)
	emit.emitvfx(slash)
	emit.enablevfx(slash,true)
	emit.enablevfx(unit.Torso.jump,false)

	for i, v in pairs(slash:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1


				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				task.wait(.3)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()

			end
		end)
	end		

	local TweenCompletepo = tween_service:Create(slash,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = startpos + (startpos.LookVector * 22) })
	TweenCompletepo:Play()

	task.wait(.3)
	
	local impact = script.SecondImpact:Clone()
	impact.Parent = effectsfolder
	impact.Position = slash.Position + Vector3.new(0,-.2,0)
	debris.AddItem(impact, 4)
	emit.emitvfx(impact)
	
	emit.emitvfx(slash)
	emit.enablevfx(slash,false)
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
