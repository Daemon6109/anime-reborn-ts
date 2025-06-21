local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local SoundWrapper = require(Replicated.Libs.SoundWrapper)

local rand = Random.new()

module.config = {
	HitDelay = 2.55, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4SFX"], rt, Replicated.SoundGroups.UnitSFX, {PlaybackSpeed = 1.4})

	for i = 1, 6 do

		spawn(function()

			local rck = script.Move4:FindFirstChild("Rock"):Clone()
			rck.CFrame = rt.CFrame * CFrame.new(math.random(-11, 11), math.random(-5, -5), math.random(1,9))
			rck.Parent = effectsfolder
			debris.AddItem(rck, 5)


			local taa = script.Move4:FindFirstChild("taa"):Clone()
			taa.CFrame = rck.CFrame * CFrame.new(0,4.5,0)
			taa.Parent = effectsfolder
			debris.AddItem(taa, 5)
			taa.Orientation = Vector3.new()

			rck.Size = Vector3.new(math.random(2, 2.5), math.random(2, 2.5), math.random(2, 2.5))

			tween_service:Create(rck, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { CFrame = CFrame.new(rck.Position.X, math.random(5, 12), rck.Position.Z) }):Play()

			tween_service:Create(rck, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { Rotation = Vector3.new(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360)) }):Play()
			wait(0.2)

			EmitParticles(taa)

			wait(0.3)

			rck.Anchored = false

			local untitled = script.Move4:FindFirstChild("untitled"):Clone()
			untitled.Root.CFrame = rck.CFrame
			untitled.Parent = effectsfolder
			debris.AddItem(untitled, 5)

			tween_service:Create(untitled.Icosphere, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { Rotation = Vector3.new(math.random(-55, 55), math.random(-55, 55), math.random(-55, 55)) }):Play()

			local ta = script.Move4:FindFirstChild("ta"):Clone()
			ta.CFrame = untitled.Root.CFrame
			ta.Parent = effectsfolder
			debris.AddItem(ta, 5)

			task.wait(0.01)

			EmitParticles(ta)

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = untitled.Root
			weld.Part1 = rck
			weld.Parent = untitled.Root

			spawn(function()
				local maxSize = 1 -- Tamanho máximo desejado
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





			tween_service:Create(untitled.Root, TweenInfo.new(1.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { CFrame = CFrame.new(untitled.Root.Position.X, math.random(5, 8), untitled.Root.Position.Z) }):Play()

			wait(1.45)

			local aa = script.Move4:FindFirstChild("aa"):Clone()
			aa.CFrame = untitled.Root.CFrame
			aa.Parent = effectsfolder
			debris.AddItem(aa, 5)

			EmitParticles(aa)

			tween_service:Create(untitled.Icosphere, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Transparency = 1, Size = Vector3.new(5,5,5)}):Play()

			SetParticlesEnabled(untitled,false)

			for i, v in pairs(untitled.Icosphere:GetChildren()) do
				if v:IsA("Beam") then
					local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 00,Width1 = 00}):Play()
				end
			end



			tween_service:Create(untitled.Root, TweenInfo.new(0.175, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), { CFrame = pos.CFrame * CFrame.new(math.random(-6,6),math.random(-1.4,-1.4),math.random(-6,6))}):Play()

			wait(0.175)



			rocks({

				amount = 2;
				minSideForce = 6;
				maxSideForce = 15;
				minYForce = 15;
				maxYForce = 25;
				minRotation = 5;
				maxRotation = 10;
				minSize = .2;
				maxSize = .45;
				filter = {};
				transparency = 0;
				position = untitled.Icosphere.Position + Vector3.new(0,0,0);
				tweenSizeTime = 0.1;
				mass = 1;
				radius = 1; 
				collide = false;
			})

			local ex = script.Move4:FindFirstChild("ex"):Clone()
			ex.CFrame = untitled.Icosphere.CFrame
			ex.Orientation = Vector3.new()
			ex.Parent = effectsfolder
			debris.AddItem(ex, 5)

			EmitParticles(ex)

			tween_service:Create(rck, TweenInfo.new(0.075, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Transparency = 1}):Play()

		end)

		task.wait(0.0375)

	end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
