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
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.15, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	

	
	local charge = script.UraumeCharge:Clone()
	charge.Parent = effectsfolder
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	
	debris.AddItem(charge, 4)
	emit.enablevfx(charge,true)



	local meshj = script.Uraumeicewall:Clone()
	meshj.Parent = effectsfolder
	meshj.Position = rt.Position + Vector3.new(0,-1,0)
	meshj.Uraumeicewall.Position = rt.Position + Vector3.new(0,-1,0)
	debris.AddItem(meshj, 4)
	emit.enablevfx(meshj,true)
	emit.emitvfx(meshj)

	task.wait(.8)
	
	emit.enablevfx(unit["Left Arm"].blastpart,true)
	
	for i, v in pairs(unit["Left Arm"].blastpart:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1

				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.6,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.6,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				task.wait(1)

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.15,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()
				
				task.wait(.6)
				
				v.Width0 = oldbeamsize
				v.Width1 = oldbeamsize2

			end
		end)
	end		

	
	task.wait(1)
	emit.enablevfx(charge,false)
	emit.enablevfx(meshj,false)
	emit.emitvfx(meshj)
	meshj.Transparency = 1
	meshj.Uraumeicewall.Transparency = 1

	emit.enablevfx(unit["Left Arm"].blastpart,false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
