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
	HitDelay = 1.2, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .12, -- delay between hits in a multi-hit move
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


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	local Mnainanim = AnimModule.PlayAnim(script.Animation1, unit, 1, "Mainanim", {Weight = 2, Fade = .15})
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "Mainaim", {Weight = 2, Fade = .5})
	
	task.spawn(function()
		task.wait(.3)
		SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	end)
	
	task.wait(.85)
	
	for i=0,6,1 do
		task.wait(.075)
		task.spawn(function()
			
			local fireball = script.FireBall:Clone()		
			fireball.Parent = effectsfolder
			fireball.Position = unit["Right Arm"].RightGripAttachment.WorldPosition
			emit.enablevfx(fireball,true)
			debris.AddItem(fireball,3)








			local PointA = fireball.CFrame 
			local PointB = fireball.CFrame + (rt.CFrame.LookVector * math.random(2,11) + Vector3.new(math.random(-4,4),math.random(-1,5),math.random(-4,4)))
			local PointC = pos.CFrame + Vector3.new(math.random(-4,4),math.random(-1,1),math.random(-4,4))



			task.spawn(function()
				for d=0,1,.08 do
					fireball.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))

					wait(math.random(0.05,2.2) / 100)
				end						


				emit.enablevfx(fireball,false)

				
				local impat = script.FireBallExplosion:Clone()		
				impat.Parent = effectsfolder
				impat.Position = fireball.Position
				emit.emitvfx(impat)
				debris.AddItem(impat,3)
				
			end)
		end)	
	end	

	task.wait(.2)

	emit.emitvfx(unit.Torso)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
