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
	HitDelay = 1.75, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
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
	local startpos = unit.DIO.RootPart.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
--	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.6, "", {Weight = 2, Fade = .15})
--	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.6, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local LoadAnim = unit.DIO.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation2))
	LoadAnim:Play()

	local LoadAnim2 = unit.DIO["Dio stand"].AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation2Satnd))
	LoadAnim2:Play()
	
	AnimModule.ChangeAnimSpeed(LoadAnim2,1.3)
	
	
	wait(0.3)

	unit.DIO["Dio stand"].RootPart.Anchored = true

	task.wait(0.01)

	local Transparencyshoottween = tween_service:Create(unit.DIO["Dio stand"].RootPart,TweenInfo.new(0.65,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame}):Play()

	wait(.7)

	local at = script.Attack2:FindFirstChild("atka"):Clone()
	at.Parent = effectsfolder
	debris.AddItem(at,6)
	at.CFrame = unit.DIO["Dio stand"].RootPart.CFrame



	local Model = script.Attack2:FindFirstChild("Model"):Clone()
	Model.Parent = effectsfolder
	debris.AddItem(at,6)
	Model.root.CFrame = unit.DIO["Dio stand"].RootPart.CFrame


	spawn(function()
		wait(0.05)
		emit.enablevfx(Model.aa,true)
		emit.enablevfx(Model.bb,true)
		wait(0.1)
		emit.enablevfx(at,true)
		emit.enablevfx(Model.Lines,true)
	end)

	spawn(function()
		local startTime = tick()  -- Marca o tempo inicial

		while (tick() - startTime) < 1.4 do

			spawn(function()

				local fist = script.Attack2:FindFirstChild("Fist"):Clone()

				-- Define a posição do "fist" relativa ao rtStand
				local spawnOffset = CFrame.new(math.random(-1, 1), math.random(-1, 1), -0.7)
				fist["Right Arm"].CFrame = unit.DIO["Dio stand"].RootPart.CFrame * spawnOffset
				fist["Right Arm"].Orientation = Vector3.new(90, 0, 0)
				fist.Parent = workspace.Camera
				debris.AddItem(fist, 0.4)
				fist["Right Arm"].Transparency = 1

				local rocketpos = fist["Right Arm"].Position 

				-- Calcula a posição do inimigo dentro do círculo baseado na orientação do rtStand
				local enemypos = unit.DIO["Dio stand"].RootPart.Position + (unit.DIO["Dio stand"].RootPart.CFrame.LookVector * 6) + Vector3.new(math.random(0, 1) == 0 and -2 or 2, math.random(-2.5, 2.5), 0)
				local magnitude = (rocketpos - enemypos).magnitude
				local Step = 11

				-- Cria o CFrame de direção para mirar no enemypos
				local LookAt = CFrame.new(rocketpos, enemypos)

				local Time = math.random(-9, 9) / 100
				local Time2 = math.random(-9, 9) / 100

				spawn(function()
					for i = 1, Step do
						-- Ajusta a posição e rotação do braço conforme a orientação de rtStand
						local offset = CFrame.new(
							math.sin(math.rad(i * -(180 / Step))) * (45 * Time),
							math.sin(math.rad(i * (180 / Step))) * (15 * Time2),
							-(magnitude / Step) * i
						)

						local adjustedCFrame = LookAt * offset * CFrame.Angles(math.rad(90), 0, 0)
						fist["Right Arm"].CFrame = adjustedCFrame
						game:GetService("RunService").Heartbeat:Wait()
					end
				end)

				task.wait(0.05)

				fist["low poly.036"].Transparency = 0

				task.wait(0.05)

				-- Tween para suavizar a transparência
				tween_service:Create(fist["low poly.036"], TweenInfo.new(0.13, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Transparency = 1}):Play()

			end)

			task.wait(0.014)  -- Ajusta o tempo de espera conforme necessário

		end
	end)




	wait(1.5)
	emit.enablevfx(Model,false)
	emit.enablevfx(at,false)

	wait(.25)

	local Transparencyshoottween = tween_service:Create(unit.DIO["Dio stand"].RootPart,TweenInfo.new(.6,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = startpos}):Play()


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
