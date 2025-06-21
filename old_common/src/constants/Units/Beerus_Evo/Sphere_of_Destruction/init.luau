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
	HitDelay = 4.285, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .26, -- delay between hits in a multi-hit move
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

local rand = Random.new()

local function rocks(properties)
	local defaultProperties = {
		amount = 15;
		minSideForce = 10;
		maxSideForce = 40;
		minYForce = 65;
		maxYForce = 130;
		minRotation = 5;
		maxRotation = 10;
		minSize = 2;
		maxSize = 4;
		anchored = false;
		filter = {};
		transparency = 0;
		position = Vector3.new();
		tweenSizeTime = 0.1;
		mass = 1;
		radius = 0; 
		collide = false;

	}

	properties = properties or defaultProperties

	for i,v in pairs(defaultProperties) do
		if properties[i] == nil then
			properties[i] = defaultProperties[i]
		end
	end

	local minXZForce,maxXZForce = properties["minSideForce"],properties["maxSideForce"]
	local minYForce,maxYForce = properties["minYForce"],properties["maxYForce"]

	local pos = properties["position"]
	local radius = properties["radius"]

	for i=1,properties["amount"] do
		task.spawn(function()
			local offsetPos = pos + Vector3.new(rand:NextNumber(-radius,radius), 0.5, rand:NextNumber(-radius,radius))
			local direction = Vector3.new(0, -10, 0) -- Ajuste aqui para -10 unidades abaixo

			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = properties["filter"]

			local rayResult = workspace:Raycast(offsetPos, direction, rayParams)

			local rockPos = rayResult and rayResult.Position or offsetPos
			local rockMaterial = properties["useColorAndMaterial"] and properties["material"] or (rayResult and rayResult.Material or properties["material"])
			local rockColor = properties["useColorAndMaterial"] and properties["color"] or (rayResult and rayResult.Instance.Color or properties["color"])

			local rock = script:FindFirstChild("rock"):Clone()

			local particle
			if properties["useParticle"] then
				particle = properties["useParticle"]:Clone()
				particle.Enabled = true
				particle.Parent = rock
			end

			local sizeNumber = rand:NextNumber(properties["minSize"], properties["maxSize"])
			local endSize = Vector3.new(sizeNumber, sizeNumber, sizeNumber)

			rock.Size = endSize
			rock.CFrame = CFrame.new(rockPos)
			rock.CustomPhysicalProperties = PhysicalProperties.new(properties["mass"], 0.3, 0.5, 1, 1)

			rock.Anchored = properties["anchored"]
			rock.Transparency = properties["transparency"]

			local velocityX = rand:NextNumber(-maxXZForce, maxXZForce)
			local velocityY = rand:NextNumber(minYForce, maxYForce)
			local velocityZ = rand:NextNumber(-maxXZForce, maxXZForce)

			local impulseVector = Vector3.new(velocityX, velocityY, velocityZ)
			rock.Velocity = impulseVector

			local rotationX = math.random() > 0.5 and rand:NextNumber(properties["minRotation"], properties["maxRotation"]) or rand:NextNumber(-properties["minRotation"], -properties["maxRotation"])
			local rotationY = math.random() > 0.5 and rand:NextNumber(properties["minRotation"], properties["maxRotation"]) or rand:NextNumber(-properties["minRotation"], -properties["maxRotation"])
			local rotationZ = math.random() > 0.5 and rand:NextNumber(properties["minRotation"], properties["maxRotation"]) or rand:NextNumber(-properties["minRotation"], -properties["maxRotation"])

			local rotationVelocity = Vector3.new(rotationX, rotationY, rotationZ)
			rock.RotVelocity = rotationVelocity

			rock.Parent = workspace

			if properties["useParticle"] then
				task.delay(properties["particleLifetime"], function()
					particle.Enabled = false
					task.delay(1, function()
						rock:Destroy()
					end)
				end)
			else
				task.delay(2, function()

					tween_service:Create(rock, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()

					wait(0.3)



					rock:Destroy()

				end)
			end
		end)
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.2, "", {Weight = 2, Fade = .15})
	task.spawn(function()
		task.wait(1.9)
		SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	end)	
	task.wait(2.335)

	local em = script.Attack3:FindFirstChild("emitmove3ballki"):Clone()
	em.Parent = effectsfolder
	em.CFrame = rt.CFrame * CFrame.new(0,9,0)
	debris.AddItem(em,7)

	EmitParticles(em)


	local Model = script.Attack3:FindFirstChild("Model"):Clone()
	Model.root.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)
	EmitParticles(Model)

	emit.enablevfx(Model,true)

	for i, v in pairs(Model:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 5,Width1 = 5}):Play()
		end
	end 

	local Transparencyshoottween = tween_service:Create(Model.root.PointLight,TweenInfo.new(.4,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 16}):Play()

	local stars = script.Attack3:FindFirstChild("stars"):Clone()
	stars.CFrame = rt.CFrame * CFrame.new(0,5,0)
	stars.Parent = effectsfolder
	debris.AddItem(stars,5)
	EmitParticles(stars)


	local fr = script.Attack3:FindFirstChild("fireball"):Clone()
	fr.root.CFrame = rt.CFrame * CFrame.new(0,9,0)
	fr.Parent = effectsfolder
	debris.AddItem(fr,5)


	spawn(function()
		for i = 1,15 do
			local kiblast = script.Attack3:FindFirstChild("Kiblast1"):Clone()
			kiblast.CFrame = rt.CFrame * CFrame.new(math.random(-25,25),math.random(-15.5,25.5),math.random(-25,25))
			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,2)
			local rocketpos = kiblast.Position
			local enemypos = fr.root.Position
			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 15
			local LookAt = CFrame.new(rocketpos,enemypos)
			local Time = math.random(-155,155)/100
			local Time2 = math.random(-155,155)/200
			spawn(function()
				for i = 1,Step do
					kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end
			end)
			wait(0.015)
		end
	end)

	local Transparencyshoottween = tween_service:Create(fr.root,TweenInfo.new(1.2,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = fr.root.CFrame * CFrame.new(0,5,0)}):Play()
	spawn(function()
		local maxSize = 1 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 1.1 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^1.1 * maxSize -- Função de interpolação cúbica
			fr:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)
	spawn(function()

		task.wait(1.2)

		local dash = script.Attack3:FindFirstChild("dash"):Clone()
		dash.Parent = effectsfolder
		dash.CFrame = fr.root.CFrame
		debris.AddItem(dash,4)
		dash.CFrame = CFrame.new(dash.Position, pos.Position)
		EmitParticles(dash)
		for i, v in pairs(Model:GetChildren()) do
			if v:IsA("Beam") then
				local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
			end
		end 

		emit.enablevfx(Model,false)

		local Transparencyshoottween = tween_service:Create(Model.root.PointLight,TweenInfo.new(.5,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 0}):Play()
		local Transparencyshoottween = tween_service:Create(fr.root,TweenInfo.new(.75,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,-1,0)}):Play()

		task.wait(0.675)

		local sunexplosion = script.Attack3:FindFirstChild("sunexplosion"):Clone()
		sunexplosion.Part.CFrame = fr.root.CFrame * CFrame.new(0,-1.2,0)
		sunexplosion.Parent = effectsfolder
		debris.AddItem(sunexplosion,5)


		local aaaaaa = script.Attack3:FindFirstChild("aaaaaa"):Clone()
		aaaaaa.Parent = effectsfolder
		aaaaaa.CFrame = fr.root.CFrame * CFrame.new(0,-1.175,0)
		debris.AddItem(aaaaaa,5)

		EmitParticles(aaaaaa)

		spawn(function()
			local maxSize = 0.73 -- Defina o tamanho máximo desejado
			local step = 0.01
			local duration = 0.1 -- Defina a duração total do crescimento em segundos

			local numSteps = maxSize / step
			local interval = duration / numSteps

			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^0.1 * maxSize -- Função de interpolação cúbica
				sunexplosion:ScaleTo(smoothScale)
				task.wait(interval)
			end
		end)
		tween_service:Create(sunexplosion.Part.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Range = 18}):Play()





		emit.enablevfx(fr,false)

		task.wait(0.175)

		fr:Destroy()
		wait(0.5)

		spawn(function()
			for i = 1,15 do
				local kiblast = script.Attack3:FindFirstChild("Kiblast1"):Clone()
				kiblast.CFrame = sunexplosion.Part.CFrame * CFrame.new(math.random(-25,25),math.random(-15.5,25.5),math.random(-25,25))
				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,2)
				local rocketpos = kiblast.Position
				local enemypos =  sunexplosion.Part.Position
				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 15
				local LookAt = CFrame.new(rocketpos,enemypos)
				local Time = math.random(-155,155)/100
				local Time2 = math.random(-155,155)/200
				spawn(function()
					for i = 1,Step do
						kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end
				end)
				wait(0.015)
			end
		end)


		wait(0.3)

		for i ,v in ipairs(sunexplosion.beam.beams:GetDescendants()) do
			if v.Name == "Beam"  then
				tween_service:Create(v,TweenInfo.new(.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Width0 = 0,Width1 = 0}):Play()
			end
		end

		tween_service:Create(sunexplosion.Part.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Range = 0}):Play()

		tween_service:Create(sunexplosion.Part,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency = 1}):Play()
		EmitParticles(aaaaaa)

		emit.enablevfx(sunexplosion,false)

		rocks({
			amount = 12,
			minSideForce = 35,
			maxSideForce = 55,
			minYForce = 45,
			maxYForce = 88,
			minRotation = 5,
			maxRotation = 10,
			minSize = 1,
			maxSize = 2,
			filter = {},
			transparency = 0,
			position = sunexplosion.Part.Position,
			tweenSizeTime = 0.1,
			mass = 1,
			radius = 1,
			collide = false,
		})
	end)
end
	

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
