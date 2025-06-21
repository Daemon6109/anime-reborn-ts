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
	HitDelay = 2.9, -- seconds
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

			rock.Parent = effectsfolder

			EmitParticles(rock)

			if properties["useParticle"] then
				task.delay(properties["particleLifetime"], function()
					particle.Enabled = false
					task.delay(1, function()
						rock:Destroy()
					end)
				end)
			else
				task.delay(2, function()

					debris.AddItem(rock,1)
					local shoottween = tween_service:Create(rock,TweenInfo.new(0.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new()}):Play()

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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame


	local a = script.Attack3:FindFirstChild("a"):Clone()    
	a.CFrame = unit["Left Arm"].cfr.CFrame
	a.Parent = effectsfolder
	debris.AddItem(a,5)

	local a1 = script.Attack3:FindFirstChild("a"):Clone()    
	a1.CFrame = unit["Right Arm"].cfr.CFrame
	a1.Parent = effectsfolder
	debris.AddItem(a1,5)


	local part1 = unit["Left Arm"].cfr -- Altere para o caminho da sua primeira parte
	local part2 = a -- Altere para o caminho da sua segunda parte


	local part11 = unit["Right Arm"].cfr -- Altere para o caminho da sua primeira parte
	local part22 = a1 -- Altere para o caminho da sua segunda parte

	local Model = script.Attack3:FindFirstChild("Model"):Clone()    
	Model.root.CFrame = rt.CFrame
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)
	EmitParticles(Model)


	task.wait(0.001)

	a1.Anchored = false
	a.Anchored = false

	task.wait(0.001)

	local Part = script.Attack3:FindFirstChild("Part"):Clone()    
	Part.CFrame = rt.CFrame * CFrame.new(0,1,0)
	Part.Parent = effectsfolder
	debris.AddItem(Part,5)

	local floor = script.Attack3:FindFirstChild("floor"):Clone()    
	floor.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	floor.Parent = effectsfolder
	debris.AddItem(floor,5)

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


	task.wait(0.6)

	emit.enablevfx(a1,true)
	emit.enablevfx(a,true)

	task.wait(0.4)

	emit.enablevfx(floor,true)

	emit.enablevfx(Part,true)




	task.wait(1)

	a:Destroy()
	a1:Destroy()
	local bb = script.Attack3:FindFirstChild("ballkimove3"):Clone()    
	bb.Part.CFrame = rt.CFrame * CFrame.new(0,1,-4.5)
	bb.Parent = effectsfolder
	debris.AddItem(bb,5)


	local trail1 = script.Attack3:FindFirstChild("Trail"):Clone()
	trail1.Parent = effectsfolder
	trail1.Position = bb.Part.Position + Vector3.new(0,-2,0)
	debris.AddItem(trail1,4)

	tween_service:Create(trail1,TweenInfo.new(.6),{Position = trail1.Position + Vector3.new(0,8.5,0)}):Play()
	tween_service:Create(trail1,TweenInfo.new(.6),{Orientation = Vector3.new(0,700,0)}):Play()


	spawn(function()
		local maxSize = .7 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.4 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.4 * maxSize -- Função de interpolação cúbica
			bb:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	tween_service:Create(bb.Part.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Range = 14}):Play()

	local part1 = script.Attack3:FindFirstChild("part1"):Clone()    
	part1.CFrame = rt.CFrame * CFrame.new(0,-1,-4)
	part1.Parent = effectsfolder
	debris.AddItem(part1,5)

	local a12 = script.Attack3:FindFirstChild("a12"):Clone()    
	a12.CFrame = rt.CFrame * CFrame.new(0,-1,-4)
	a12.Parent = effectsfolder
	debris.AddItem(a12,5)

	EmitParticles(a12)

	emit.enablevfx(part1,true)

	wait(0.6)

	local rockemit = script.Attack3:FindFirstChild("rockemit"):Clone()    
	rockemit.CFrame = rt.CFrame * CFrame.new(0,1,-4)
	rockemit.Parent = effectsfolder
	debris.AddItem(rockemit,5)



	EmitParticles(rockemit)

	emit.enablevfx(trail1,false)

	emit.enablevfx(Part,false)
	local trail = script.Attack3:FindFirstChild("trail"):Clone()    
	trail.CFrame = rt.CFrame * CFrame.new(0,-1,-4)
	trail.Parent = effectsfolder
	debris.AddItem(trail,5)

	emit.enablevfx(trail,true)


	tween_service:Create(bb.Part, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,0,-32)}):Play()

	tween_service:Create(trail, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,0,-32)}):Play()
	task.wait(0.499)
	emit.enablevfx(trail,false)
	local ex = script.Attack3:FindFirstChild("exp"):Clone()    
	ex.CFrame = rt.CFrame * CFrame.new(0,-1,-32)
	ex.Parent = effectsfolder
	debris.AddItem(ex,5)

	EmitParticles(ex)

	task.wait(0.01)

	rocks({
		amount = 10,
		minSideForce = 12,
		maxSideForce = 35,
		minYForce = 45,
		maxYForce = 88,
		minRotation = 5,
		maxRotation = 10,
		minSize = 0,
		maxSize = 0,
		filter = {},
		transparency = 0,
		position = ex.Position,
		tweenSizeTime = 0.1,
		mass = 0.3,
		radius = 1,
		collide = false,
	})

	bb:Destroy()

	emit.enablevfx(floor,false)

	emit.enablevfx(part1,false)



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
