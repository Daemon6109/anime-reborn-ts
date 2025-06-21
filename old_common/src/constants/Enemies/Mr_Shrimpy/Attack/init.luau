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
	HitDelay = 1.85, -- seconds
	Duration = .25,
	TurnTime = .7,
	StunTime = 5,
	AttackRange = 35,
	AttackSize = 15,
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

for i,v in script:GetDescendants() do
	if v:IsA("BasePart") and not v:HasTag("NoAnchor") then
		v.Anchored = true
	end
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

	local oldcf = rt.CFrame

	local attack = script:WaitForChild("Flashy Fist"):Clone()
	attack.Parent = effectsfolder
	attack.CFrame = pos.CFrame
	debris.AddItem(attack, 5)

	task.wait(.5)
	emit.emitvfx(unit.Torso.movement)

	tween_service:Create(rt,TweenInfo.new(1.1),{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) * rt.CFrame.Rotation * CFrame.new(0,0,1)}):Play()
	
	for i=0,2,1 do
		task.wait(.25)
		emit.emitvfx(unit.Torso.movement)
	end
	
	task.wait(0.5)


	emit.emitvfx(attack)

	task.wait(1)

	unit.Torso.tp:Emit(25)
	task.wait(.12)

	rt.CFrame = oldcf

	wait(.03)
	unit.Torso.tp:Emit(25)	

	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
