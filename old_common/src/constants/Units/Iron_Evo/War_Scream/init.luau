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
	HitDelay = 1, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .23, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Model = script.Attack3:FindFirstChild("Model"):Clone()
	Model.part.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model, 5)
	EmitParticles(Model)


	task.wait(0.5)

	spawn(function()
		for i = 1,20 do


			local destroco = script.Attack3:FindFirstChild("Part1"):Clone()
			destroco.CFrame = rt.CFrame * CFrame.new(math.random(-5, 5), math.random(-3, 6), math.random(0, 1))
			destroco.Parent = effectsfolder
			debris.AddItem(destroco,5)


			local kp = destroco.Position
			local enemypos = rt.Position + Vector3.new(math.random(-8, 8), math.random(-2,11), math.random(-28,-6))

			local magnitude = (kp-enemypos).magnitude
			local Step = 25

			local LookAt = CFrame.new(kp,enemypos)

			local Time = math.random(-25,25)/100
			local Time2 = math.random(-25,25)/100


			spawn(function()

				for i = 0,Step do
					destroco.CFrame = LookAt * CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45  * Time),math.sin(math.rad((i * (180/Step)))) * (15 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()

				end
			end)
			task.wait(0.04)
		end
	end)	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
