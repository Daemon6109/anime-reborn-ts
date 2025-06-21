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
	HitDelay = 2.25, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	
	local G_1 = unit.Gamma1
	local G_2 = unit.Gamma2

	local rtG1 = unit.Gamma1:WaitForChild("HumanoidRootPart")
	local rtG2 = unit.Gamma2:WaitForChild("HumanoidRootPart")

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script["Animation1(G1)"], G_1, 1, "", {Weight = 2, Fade = .15})
	AnimModule.PlayAnim(script["Animation1(G2)"], G_2, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["Move1"], rt, Replicated.SoundGroups.UnitSFX)
	
	G_1.Blast1.Transparency = 0
	G_2.Blast1.Transparency = 0

	task.wait(0.7)			

	local Length1 = (rtG1.Position - pos.Position).magnitude
	local back1 = rtG1.CFrame

	local Length2 = (rtG2.Position - pos.Position).magnitude
	local back2 = rtG2.CFrame

	local prk = script.Attack1:FindFirstChild("Prk"):Clone()
	prk.CFrame = unit.HumanoidRootPart.CFrame * CFrame.new(0,0.5,0)
	prk.Parent = effectsfolder
	debris.AddItem(prk,4)

	local blaster = script.Attack1:FindFirstChild("blast"):Clone()
	blaster.Her.CFrame = rtG2.CFrame * CFrame.new(1,0.5,-2)
	blaster.Parent = effectsfolder
	debris.AddItem(blaster,4)

	local blaster2 = script.Attack1:FindFirstChild("blastPurple"):Clone()
	blaster2.Her.CFrame = rtG1.CFrame * CFrame.new(0,0.5,-2)
	blaster2.Parent = effectsfolder
	debris.AddItem(blaster2,4)

	spawn(function()

		local a = 1

		for i = 1,6 do
			local kiblast = script.Attack1:FindFirstChild("FireTick1"):Clone()
			kiblast.CFrame = rtG1.CFrame * CFrame.new(math.random(-5,5),math.random(-1.5,5.5),math.random(-5,5))


			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,1)

			local rocketpos = kiblast.Position
			local enemypos = rtG1.Position + Vector3.new(1,0.5,-2)

			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 12

			local LookAt = CFrame.new(rocketpos,enemypos)

			local Time = math.random(-35,35)/100
			local Time2 = math.random(-35,35)/200
			spawn(function()

				for i = 1,Step do
					kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end


			end)
			task.wait(0.04)

		end

	end)

	spawn(function()

		local a = 1

		for i = 1,6 do
			local kiblast = script.Attack1:FindFirstChild("FireTick2"):Clone()
			kiblast.CFrame = rtG2.CFrame * CFrame.new(math.random(-5,5),math.random(-1.5,5.5),math.random(-5,5))


			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,1)

			local rocketpos = kiblast.Position
			local enemypos = rtG2.Position + Vector3.new(0,0.5,-2)

			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 12

			local LookAt = CFrame.new(rocketpos,enemypos)

			local Time = math.random(-35,35)/100
			local Time2 = math.random(-35,35)/200
			spawn(function()

				for i = 1,Step do
					kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end


			end)
			task.wait(0.04)

		end

	end)

	emit.emitvfx(blaster)
	emit.emitvfx(blaster2)
	emit.emitvfx(prk)

	task.wait(0.7)

	spawn(function()

		for i = 1,4 do

			spawn(function()

				local a1 = math.random(30,60)/100

				local spec = script.Attack1:FindFirstChild("part"):Clone()
				spec.CFrame = blaster.Her.CFrame * CFrame.new(0,0,-1)
				spec.Orientation = spec.Orientation
				spec.Parent = effectsfolder
				debris.AddItem(spec,2)

				emit.emitvfx(spec)

				-- Define o raio máximo do círculo e o desvio apenas para dentro
				local averageRadius = 6 -- Raio médio
				local innerDeviation = math.random(0, 5) -- Desvio para dentro, até 15 unidades

				-- Gera um ângulo e ajusta a distância para estar dentro do círculo
				local angle = math.rad(math.random(0, 360))
				local distance = averageRadius - innerDeviation

				-- Calcula a posição no plano XZ em torno do ponto central
				local offsetX = math.cos(angle) * distance
				local offsetZ = math.sin(angle) * distance

				local rocketPos = spec.Position + Vector3.new(math.random(-2,2)/100,math.random(-2,2)/100,math.random(-2,2)/100)
				local targetPos = pos.Position + Vector3.new(offsetX, math.random(-1,4), offsetZ)

				local magnitude = (rocketPos - targetPos).magnitude
				local steps = a1 * 60

				local lookAt = CFrame.new(rocketPos, targetPos)

				-- Trajetória com pequenos ajustes para criar uma curva irregular
				local randomDeviation1 = math.random(-20, 20) / 100
				local randomDeviation2 = math.random(-20, 20) / 100
				local extraDistance = 0

				local direction = (targetPos - rocketPos).unit

				spawn(function()
					for i = 1, steps do
						local offset = direction * (magnitude / steps) * i

						spec.CFrame = lookAt * CFrame.new(
							math.sin(math.rad(i * -(180 / steps))) * (45 * randomDeviation1),
							math.sin(math.rad(i * (180 / steps))) * (15 * randomDeviation2),
							-(offset.magnitude + extraDistance)
						)

						game:GetService("RunService").Heartbeat:Wait()
					end
				end)


				task.wait(a1 - 0.1) 

				spec.Transparency = 1

				local bb1 = script.Attack1:FindFirstChild("Ett"):Clone()
				bb1.Position = targetPos
				bb1.Orientation = spec.Orientation
				bb1.Parent = effectsfolder
				debris.AddItem(bb1,5)

				emit.emitvfx(bb1)

			end)

			task.wait(0.05)

		end

	end)

	spawn(function()

		for i = 1,4 do

			spawn(function()

				local a1 = math.random(30,60)/100

				local spec1 = script.Attack1:FindFirstChild("part2"):Clone()
				spec1.CFrame = blaster.Her.CFrame * CFrame.new(0,0,-1)
				spec1.Orientation = spec1.Orientation
				spec1.Parent = workspace.Camera
				debris.AddItem(spec1,2)

				emit.emitvfx(spec1)

				-- Define o raio máximo do círculo e o desvio apenas para dentro
				local averageRadius = 6 -- Raio médio
				local innerDeviation = math.random(0, 5) -- Desvio para dentro, até 15 unidades

				-- Gera um ângulo e ajusta a distância para estar dentro do círculo
				local angle = math.rad(math.random(0, 360))
				local distance = averageRadius - innerDeviation

				-- Calcula a posição no plano XZ em torno do ponto central
				local offsetX = math.cos(angle) * distance
				local offsetZ = math.sin(angle) * distance

				local rocketPos = spec1.Position + Vector3.new(math.random(-2,2)/100,math.random(-2,2)/100,math.random(-2,2)/100)
				local targetPos = pos.Position + Vector3.new(offsetX, math.random(-1,4), offsetZ)

				local magnitude = (rocketPos - targetPos).magnitude
				local steps = a1 * 60

				local lookAt = CFrame.new(rocketPos, targetPos)

				-- Trajetória com pequenos ajustes para criar uma curva irregular
				local randomDeviation1 = math.random(-20, 20) / 100
				local randomDeviation2 = math.random(-20, 20) / 100
				local extraDistance = 0

				local direction = (targetPos - rocketPos).unit

				spawn(function()
					for i = 1, steps do
						local offset = direction * (magnitude / steps) * i

						spec1.CFrame = lookAt * CFrame.new(
							math.sin(math.rad(i * -(180 / steps))) * (45 * randomDeviation1),
							math.sin(math.rad(i * (180 / steps))) * (15 * randomDeviation2),
							-(offset.magnitude + extraDistance)
						)

						game:GetService("RunService").Heartbeat:Wait()
					end
				end)


				task.wait(a1 - 0.1)

				spec1.Transparency = 1

				local bb1 = script.Attack1:FindFirstChild("Ett2"):Clone()
				bb1.Position = targetPos
				bb1.Parent = effectsfolder
				debris.AddItem(bb1,5)

				emit.emitvfx(bb1)

			end)

			task.wait(0.05)

		end


	end)

	task.wait(0.7)

	G_1.Blast1.Transparency = 1
	G_2.Blast1.Transparency = 1
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
