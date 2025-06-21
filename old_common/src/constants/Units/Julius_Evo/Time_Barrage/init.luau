local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .9, -- seconds
	HitCount = 24, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3SFX"], rt, Replicated.SoundGroups.UnitSFX, {PlaybackSpeed = 1})

	local Model = script.Move3:FindFirstChild("Model"):Clone()
	Model.part.CFrame = rt.CFrame
	Model.Parent = effectsfolder
	debris.AddItem(Model,4)

	local floor = script.Move3:FindFirstChild("floor"):Clone()
	floor.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	floor.Parent = effectsfolder
	debris.AddItem(floor,4)

	EmitParticles(floor)

	EmitParticles(Model)

	wait(0.8)
	spawn(function()
		for i = 1,24 do
			task.wait(.06)
			spawn(function()

				local kiblast = script.Move3:FindFirstChild("KiBlast"):Clone()
				kiblast.CFrame = rt.CFrame
				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,4)


				local rocketpos = kiblast.Position
				local enemypos = pos.Position + Vector3.new(math.random(-7,7),math.random(-1,6),math.random(-7,7))
				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 10
				local LookAt = CFrame.new(rocketpos,enemypos)
				local Time = math.random(-25,25)/100
				local Time2 = math.random(-25,25)/200
				spawn(function()
					for i = 1,Step do
						kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end
					kiblast.Transparency = 1
					SetParticlesEnabled(kiblast,false)

					spawn(function()

						local untitled = script.Move3:FindFirstChild("untitled"):Clone()
						untitled.Root.CFrame = kiblast.CFrame
						untitled.Parent = effectsfolder
						debris.AddItem(untitled, 5)

						tween_service:Create(untitled.Icosphere, TweenInfo.new(.74, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { Rotation = Vector3.new(math.random(-125, 125), math.random(-125, 125), math.random(-125, 125)) }):Play()


						local ta = script.Move3:FindFirstChild("ta"):Clone()
						ta.CFrame = untitled.Root.CFrame
						ta.Parent = effectsfolder
						debris.AddItem(ta, 5)



						EmitParticles(ta)

						spawn(function()
							local maxSize = 1.1 -- Tamanho máximo desejado
							local step = 0.1 -- Aumente o passo para menos iterações
							local growthDuration = 0.175 -- Duração total do crescimento em segundos
							local numSteps = maxSize / step
							local growthInterval = growthDuration / numSteps

							-- Crescimento do modelo
							for i = 1, numSteps do
								local t = i / numSteps
								local smoothScale = t^0.25 * maxSize -- Interpolação cúbica
								untitled:ScaleTo(smoothScale)
								task.wait(growthInterval)
							end
						end)



						tween_service:Create(untitled.Root, TweenInfo.new(.175, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = untitled.Root.CFrame * CFrame.new(0,.2,0)}):Play()

						wait(0.175)

						tween_service:Create(untitled.Root, TweenInfo.new(.175, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = untitled.Root.CFrame * CFrame.new(0,-.2,0)}):Play()


						wait(0.175)

						EmitParticles(ta)



						tween_service:Create(untitled.Icosphere, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Transparency = 1, Size = Vector3.new(5,5,5)}):Play()

						SetParticlesEnabled(untitled,false)

						for i, v in pairs(untitled.Icosphere:GetChildren()) do
							if v:IsA("Beam") then
								local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 00,Width1 = 00}):Play()
							end
						end

					end)



				end)

			end)
		end

	end)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
