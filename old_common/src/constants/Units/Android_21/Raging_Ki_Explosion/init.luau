local module = {}
local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local vfx_custom = require(Replicated:WaitForChild("Libs"):WaitForChild("VFX_Custom"))
local Run = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Animations = script
local Sound = script.Parent:WaitForChild("Sound")
local Mesh = script.Mesh
local Scaler = require(Replicated.Libs.VFX_Scale)
local effectsfolder = workspace.Effects

module.config = {
	HitDelay = 3.25, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[2] = .3,
	--	[3] = .5,
	--	[4] = 0,
	--	[5] = 0,
	--	[6] = 0,
	--},
	ScaleFactor = 1.85,
}

Scaler:scale(module.config.ScaleFactor, Mesh)

local function SetParticlesEnabled(part, shouldEnable)
	for i, v in ipairs(part:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v.Enabled = shouldEnable
				end
			end)()
		end
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
	
	local back = unit.back
	
	local hum = unit:FindFirstChild("Humanoid")
	local SavedDirection = rt.CFrame.LookVector
	local Enemy = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	back.CFrame = CFrame.new(back.Position, pos.Position)

	local function movehere2()
		local animation = AnimModule.PlayAnim(Animations["Animation2"], unit, 1, "", {Weight = 2, Fade = .15})

		local lt = Mesh.Lightning:Clone()
		lt.part.CFrame = rt.CFrame * CFrame.new(0,-1.35,0)
		lt.Parent = effectsfolder
		debris.AddItem(lt,6)


		local emit3 = Mesh.ExplosionImpact1:Clone()
		emit3.CFrame = rt.CFrame * CFrame.new(0,-1.35,0)
		emit3.Parent = effectsfolder
		debris.AddItem(emit3,6)

		SoundWrapper:PlaySound(Sound["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)

		wait(0.3)

		spawn(function()
			for i = 1,12 do
				local kiblast = Mesh:FindFirstChild("Kiblast1"):Clone()
				kiblast.CFrame = rt.CFrame * CFrame.new(math.random(-7,7),math.random(-7.5,7.5),math.random(-7,7))
				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,2)
				local rocketpos = kiblast.Position
				local enemypos = unit.Torso.Position 
				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 15
				local LookAt = CFrame.new(rocketpos,enemypos)
				local Time = math.random(-66,66)/100
				local Time2 = math.random(-66,66)/200
				spawn(function()
					for i = 1,Step do
						kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end
				end)
				task.wait(0.045)
			end
		end)


		SoundWrapper:PlaySound(Sound["magic-charge10"], rt, Replicated.SoundGroups.UnitSFX)

		EmitParticles(unit.Torso.emit)


		wait(0.6)

		SoundWrapper:PlaySound(Sound["fire-ignite1"], rt, Replicated.SoundGroups.UnitSFX)

		SetParticlesEnabled(lt,true)

		spawn(function()

			local maxSize = 1
			local step = 0.01
			local duration = 0.2 

			local numSteps = maxSize / step
			local interval = duration / numSteps

			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^0.2 * maxSize 
				lt:ScaleTo(smoothScale)
				task.wait(interval)
			end

		end)

		wait(.5)

		SoundWrapper:PlaySound(Sound["magic-charge06"], rt, Replicated.SoundGroups.UnitSFX)

		wait(1.5)

		SoundWrapper:PlaySound(Sound.explosion03, rt, Replicated.SoundGroups.UnitSFX)

		EmitParticles(emit3)

		SetParticlesEnabled(lt,false)


	end
	movehere2()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
