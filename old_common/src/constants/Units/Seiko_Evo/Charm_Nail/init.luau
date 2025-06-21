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
	HitDelay = 2.1, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
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
	
	local aninm= AnimModule.PlayAnim(script.Animation3, unit, 1.4, "", {Weight = 2, Fade = .5})
	SoundWrapper:PlaySound(script["Trap Place"], rt, Replicated.SoundGroups.UnitSFX)
		
	emit.enablevfx(	unit.Bat.Enableonlyonmove3,true)	
	emit.emitvfx(unit.Bat.Enableonlyonmove3)
		
	task.wait(.35)	
	
	AnimModule.ChangeAnimSpeed(aninm,5)

	task.wait(.1)
	AnimModule.ChangeAnimSpeed(aninm,1)
	local impact2 = script.Impactwhendone:Clone() 
	impact2.Parent = workspace.Effects
	impact2.Position = rt.Position + (rt.CFrame.LookVector * .5) + Vector3.new(0,-.6,0)
	emit.emitvfx(impact2)
	debris.AddItem(impact2,3)
	task.wait(.15)
	
	--AnimModule.PlayAnim(script.Animation3p2, unit, 1, "", {Weight = 2, Fade = .15})
			
	local Bottom = script.CircleSeiko:Clone() 
	Bottom.Parent = workspace.Effects
	Bottom.Position = pos.Position + Vector3.new(0,-1.4,0)
	emit.enablevfx(Bottom,true)
	emit.emitvfx(Bottom)
	debris.AddItem(Bottom,3)

	task.wait(.5)

		
	impact2.Position = unit.Bat.Enableonlyonmove3.WorldPosition
	emit.emitvfx(impact2)	
	emit.emitvfx(unit.Torso.jump)
	emit.enablevfx(unit.Bat.Enableonlyonmove3,false)	

	task.wait(.5)

	Bottom:Destroy()
	local impact = script.Forcirclehit:Clone() 
	impact.Parent = workspace.Effects
	impact.Position = Bottom.Position
	SoundWrapper:PlaySound(script["Trap Explode"], rt, Replicated.SoundGroups.UnitSFX)

	EmitParticles(impact)

	emit.enablevfx(Bottom,false)
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
