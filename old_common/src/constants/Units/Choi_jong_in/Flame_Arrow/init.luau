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
	HitDelay = 1.7, -- seconds
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
	
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.2, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.2)
	
	emit.enablevfx(unit.Bow,true)

	for i, v in pairs(unit.Bow:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				v.Width0 = 0
				v.Width1 = 0
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
			end
		end)
	end	

	
	task.wait(.5)
	

	local Arrow = script.Arrow:Clone()
	Arrow.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2.5) 
	Arrow.Parent = effectsfolder
	debris.AddItem(Arrow,5)
	emit.emitvfx(Arrow)
	emit.enablevfx(Arrow,true)
	
	for i, v in pairs(Arrow:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				v.Width0 = 0
				v.Width1 = 0
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
			end
		end)
	end	
	
	local TweenCompletepo = tween_service:Create(Arrow,TweenInfo.new(.7,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Position = pos.Position})
	TweenCompletepo:Play()
	
	task.wait(.5)

	emit.emitvfx(unit.Torso)

	task.wait(.2)

	SoundWrapper:PlaySound(script.Parent.Explosion, rt, Replicated.SoundGroups.UnitSFX)
	local Impact = script.Explosion:Clone()
	Impact.Position = Arrow.Position + Vector3.new(0,-1,0)
	Impact.Parent = effectsfolder
	debris.AddItem(Impact,5)
	emit.emitvfx(Impact)
	emit.enablevfx(Arrow,false)
	emit.enablevfx(unit.Bow,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
