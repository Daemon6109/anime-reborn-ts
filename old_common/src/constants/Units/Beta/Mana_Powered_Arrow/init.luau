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
local rn = game:GetService("RunService")

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


local function lerp(p0,p1,t)
	return p0*(1-t) + p1*t
end

local function quad(p0,p1,p2, t)
	local l1 = lerp(p0,p1,t)
	local l2 = lerp(p1,p2,t)
	local quad = lerp(l1,l2,t)
	return quad
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.3, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.emitvfx(unit.Bow.Handle)
	unit.Bow.Handle.Transparency = 0
	task.spawn(function()
		for i=0,6,1 do
			task.wait(.06)
			emit.bezier(unit.Bow.Handle.CFrame,ColorSequence.new(Color3.fromRGB(255, 61, 64)),0.00000000005,.5,"Long",true,5,.5,1.6)
		end
	end)
	
	task.wait(1)

	emit.emitvfx(unit.Torso.jump)

	task.wait(.3)

	local arrw = script.DisplayArrow2:Clone()
	arrw.CFrame = unit.Bow.Handle.CFrame
	arrw.Parent = effectsfolder
	debris.AddItem(arrw,3)
	emit.enablevfx(arrw,true)

	local TweenComplete = tween_service:Create(arrw,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position =pos.Position})
	TweenComplete:Play()

	task.wait(.2)

	emit.enablevfx(arrw,false)
	arrw.Transparency = 1
	
	emit.emitvfx(unit.Bow.Handle)
	unit.Bow.Handle.Transparency = 1

	local impact = script.bowimpact:Clone()
	impact.CFrame = arrw.CFrame
	impact.Parent = effectsfolder
	debris.AddItem(impact,3)
	emit.emitvfx(impact)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
