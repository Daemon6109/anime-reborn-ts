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
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Emits1 = script.Move2:FindFirstChild("Emits1"):Clone()
	Emits1.root.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	Emits1.Parent = effectsfolder
	debris.AddItem(Emits1,3)

	EmitParticles(Emits1)

	wait(0.75)


	local emitss = script.Move2:FindFirstChild("Model"):Clone()
	emitss.Parent = effectsfolder
	debris.AddItem(emitss,6)
	emitss.Root.CFrame = rt.CFrame * CFrame.new(0,-1,-2)

	spawn(function()
		for i = 1,12 do


			local destroco = script.Move2:FindFirstChild("Part1"):Clone()
			destroco.CFrame = rt.CFrame * CFrame.new(math.random(-6, 6), math.random(-3, 6), math.random(-1, -1))
			destroco.Parent = effectsfolder
			debris.AddItem(destroco,3)


			local kp = destroco.Position
			local enemypos = rt.Position + Vector3.new(math.random(-7, 7), math.random(-2,8), math.random(-12,-5))

			local magnitude = (kp-enemypos).magnitude
			local Step = 35

			local LookAt = CFrame.new(kp,enemypos)

			local Time = math.random(-12,12)/100
			local Time2 = math.random(-12,12)/100


			spawn(function()

				for i = 0,Step do
					destroco.CFrame = LookAt * CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45  * Time),math.sin(math.rad((i * (180/Step)))) * (15 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()

				end
			end)
		end
	end)

	task.spawn(function()
		local x = 3
		local y = 3
		local z = 4

		spawn(function()
			for count = 1, 12 do
				for i = 1, 2 do
					spawn(function()

						local IceShade = script.Move2.IceSpike:Clone()
						IceShade.Parent = workspace.CurrentCamera
						IceShade.Size = Vector3.new(x, z, y)


						IceShade.CFrame = rt.CFrame 
							* CFrame.new(0, -1, -1.5) 
							* CFrame.new(math.random(-1, 1), -y, -(count * 1)) 
							* CFrame.fromEulerAnglesYXZ(math.rad(math.random(-5, 5)), math.rad(math.random(-125, 55)), 0)

						debris.AddItem(IceShade,4)

						x = x + 0.1
						y = y + 0.1
						z = z + 0.3

						EmitParticles(IceShade)
						emit.enablevfx(IceShade, true)
						tween_service:Create(IceShade, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.InOut), 
							{ Position = IceShade.Position + Vector3.new(0, y, 0) }
						):Play()

						wait(1.05)



						tween_service:Create(IceShade.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), 
							{ Range = 6 }
						):Play()

						wait(0.15)
						emit.enablevfx(IceShade, false)
						EmitParticles(IceShade)

						tween_service:Create(IceShade, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), 
							{ Transparency = 1 }
						):Play()

						wait()

						tween_service:Create(IceShade.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), 
							{ Range = 0 }
						):Play()
					end)
				end
				wait()
			end
		end)
	end)

	wait(0.2)


	EmitParticles(emitss)

	wait(1.05)

	spawn(function()
		for i = 1,8 do


			local destroco = script.Move2:FindFirstChild("Part1"):Clone()
			destroco.CFrame = rt.CFrame * CFrame.new(math.random(-6, 6), math.random(-3, 6), math.random(-1, -1))
			destroco.Parent = effectsfolder
			debris.AddItem(destroco,3)


			local kp = destroco.Position
			local enemypos = rt.Position + Vector3.new(math.random(-7, 7), math.random(-2,8), math.random(-12,-5))

			local magnitude = (kp-enemypos).magnitude
			local Step = 35

			local LookAt = CFrame.new(kp,enemypos)

			local Time = math.random(-12,12)/100
			local Time2 = math.random(-12,12)/100


			spawn(function()

				for i = 0,Step do
					destroco.CFrame = LookAt * CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45  * Time),math.sin(math.rad((i * (180/Step)))) * (15 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()

				end
			end)
		end
	end)

	EmitParticles(emitss)


end
	


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
