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
	HitDelay = 1.67, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector


	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	task.wait(0.817)

	local a = script.Attack1:FindFirstChild("a"):Clone()
	a.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
	a.Parent = effectsfolder
	debris.AddItem(a, 5)

	EmitParticles(a)


	local direction = (pos.Position - rt.Position).unit

	local targetPosition = rt.Position + direction * Length

	local _, targetRotationY, _ = rt.CFrame:toEulerAnglesXYZ()

	local targetCFrame = CFrame.new(targetPosition) * CFrame.fromEulerAnglesXYZ(0, targetRotationY, 0)

	local Tween = tween_service:Create(rt, TweenInfo.new(0.566, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = targetCFrame}):Play()

	task.wait(0.55)

	local W = script.Attack1:FindFirstChild("w"):Clone()
	W.CFrame = rt.CFrame * CFrame.new(0, 0, 0)
	W.Parent = effectsfolder
	debris.AddItem(W, 5)
	EmitParticles(W)





	task.wait(0.05)

	local aaa = script.Attack1:FindFirstChild("aaaaaa"):Clone()
	aaa.CFrame = rt.CFrame * CFrame.new(0, -1.5, -3)
	aaa.Parent = effectsfolder
	debris.AddItem(aaa, 5)
	EmitParticles(aaa)

	local newaa = script:FindFirstChild("Iron1"):Clone()
	newaa.CFrame = rt.CFrame * CFrame.new(0, -1.5, -3)
	newaa.Parent = effectsfolder
	debris.AddItem(newaa, 5)
	EmitParticles(newaa)


	rocks({
		amount = 10,
		minSideForce = 18,
		maxSideForce = 35,
		minYForce = 45,
		maxYForce = 88,
		minRotation = 5,
		maxRotation = 10,
		minSize = .4,
		maxSize = 1.5,
		filter = {},
		transparency = 0,
		position = rt.Position + Vector3.new(0,-1,-2.5),
		tweenSizeTime = 0.1,
		mass = 1,
		radius = 1,
		collide = false,
	})


	local Tween = tween_service:Create(aaa.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Range = 16}):Play()

	task.wait(0.3)
	local Tween = tween_service:Create(aaa.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Range = 0}):Play()

	task.wait(1.25)


	local aa = script.Attack1:FindFirstChild("aa"):Clone()
	aa.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
	aa.Parent = effectsfolder
	debris.AddItem(aa, 3.5)



	task.wait(0.001)

	EmitParticles(aa)



	local aa1 = script.Attack1:FindFirstChild("aa"):Clone()
	aa1.CFrame = back * CFrame.new(0,-1.5,0)
	aa1.Parent = effectsfolder
	debris.AddItem(aa1, 3.5)



	task.wait(0.001)

	rt.CFrame = back

	EmitParticles(aa1)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
