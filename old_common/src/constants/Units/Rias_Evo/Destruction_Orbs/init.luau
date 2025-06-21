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
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
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

local rand = Random.new()


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector
	
	local back = rt.CFrame



	local a = script.Attack1:FindFirstChild("a"):Clone()    
	a.CFrame = unit["Left Arm"].cfr.CFrame
	a.Parent = effectsfolder
	debris.AddItem(a,5)

	local a1 = script.Attack1:FindFirstChild("a"):Clone()    
	a1.CFrame = unit["Right Arm"].cfr.CFrame
	a1.Parent = effectsfolder
	debris.AddItem(a1,5)


	local part1 = unit["Left Arm"].cfr -- Altere para o caminho da sua primeira parte
	local part2 = a -- Altere para o caminho da sua segunda parte


	local part11 = unit["Right Arm"].cfr -- Altere para o caminho da sua primeira parte
	local part22 = a1 -- Altere para o caminho da sua segunda parte

	task.wait(0.001)
	local weld = Instance.new("Weld")
	weld.Part0 = part1
	weld.Part1 = part2
	weld.Parent = part1
	debris.AddItem(weld,4)


	local weld1 = Instance.new("Weld")
	weld1.Part0 = part11
	weld1.Part1 = part22
	weld1.Parent = part11
	debris.AddItem(weld1,4)

	a1.Anchored = false
	a.Anchored = false

	task.wait(0.4)


	emit.enablevfx(a1,true)

	a1.AuraAt.Emit:Emit(1)


	task.wait(0.1)

	a.AuraAt.Emit:Emit(1)
	emit.enablevfx(a,true)

	wait(0.750)

	a.Anchored = true

	task.wait(0.001)

	local rocketpos = a.Position
	local enemypos = pos.Position + Vector3.new(0,-1,0)

	local magnitude = (rocketpos-enemypos).magnitude
	local Step = 15

	local LookAt = CFrame.new(rocketpos,enemypos)

	local Time = math.random(35,35)/100
	local Time2 = math.random(15,35)/200
	spawn(function()

		for i = 1,Step do
			a.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
			game:GetService("RunService").Heartbeat:Wait()
		end
		local ex = script.Attack1:FindFirstChild("ex"):Clone()    
		ex.CFrame = a.CFrame
		ex.Parent = effectsfolder
		debris.AddItem(ex,5)
		ex.Orientation = Vector3.new()
		EmitParticles(ex)
		task.wait(0.001)
		a:Destroy()
	end)

	task.wait(.4)



	a1.Anchored = true

	task.wait(0.001)

	local rocketpos = a1.Position
	local enemypos = pos.Position + Vector3.new(0,-1,0)

	local magnitude = (rocketpos-enemypos).magnitude
	local Step = 15

	local LookAt = CFrame.new(rocketpos,enemypos)

	local Time = math.random(-35,-35)/100
	local Time2 = math.random(15,35)/200
	spawn(function()

		for i = 1,Step do
			a1.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
			game:GetService("RunService").Heartbeat:Wait()
		end

		local ex = script.Attack1:FindFirstChild("ex"):Clone()    
		ex.CFrame = a1.CFrame
		ex.Parent = effectsfolder
		debris.AddItem(ex,5)
		ex.Orientation = Vector3.new()
		EmitParticles(ex)
		task.wait(0.001)
		a1:Destroy()
	end)

	task.wait(.5)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
