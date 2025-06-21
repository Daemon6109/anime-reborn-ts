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
	HitDelay = 1.25, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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
	
	local LoadAnim = unit.DIO.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation1))
	LoadAnim:Play()
	
	task.spawn(function()
		task.wait(.6)
		SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	end)
	

	local Length = (rt.Position - pos.Position).magnitude


	wait(0.7)
	spawn(function()
		for i = 1,7 do
			task.wait(.06)
			spawn(function()

				local kiblast = script.Attack1:FindFirstChild("Model"):Clone()
				kiblast.trail.CFrame = rt.CFrame * CFrame.new(math.random(-2.2,2.2),math.random(-1,1),math.random(-2,-0.5))
				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,4)
				EmitParticles(kiblast.trail.Start)

				wait(0.3)

				local rocketpos = kiblast.trail.Position
				local enemypos = pos.Position + Vector3.new(math.random(-4,4),math.random(-1,3.6),math.random(-4,4))
				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 11
				local LookAt = CFrame.new(rocketpos,enemypos)
				local Time = math.random(-25,25)/100
				local Time2 = math.random(-25,25)/200
				spawn(function()
					for i = 1,Step do
						kiblast.trail.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (35 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end

					emit.enablevfx(kiblast,false)
					EmitParticles(kiblast.trail.Emit)
					kiblast.trail.aa:Destroy()



				end)
			end)
		end

	end)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
