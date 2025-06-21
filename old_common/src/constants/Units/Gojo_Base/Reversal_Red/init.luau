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
local Animations = script.Parent.Animations
local Mesh = script.Mesh
local Sound = script.Parent.Sound
local Scaler = require(Replicated.Libs.VFX_Scale)
local effectsfolder = workspace.Effects

module.config = {
	HitDelay = 2.25, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[1] = .35,
	--},
	ScaleFactor = 1,
}

Scaler:scale(module.config.ScaleFactor, Mesh)

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

			local rock = Instance.new("Part")

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

			rock.Color = rockColor
			rock.Material = rockMaterial
			rock.Anchored = properties["anchored"]
			rock.CanCollide = properties["collide"]
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
					rock:Destroy()
				end)
			end
		end)
	end
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
	--
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local hum = unit:FindFirstChild("Humanoid")
	local SavedDirection = rt.CFrame.LookVector
	local Enemy = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	local function movehere3()
		local animation = AnimModule.PlayAnim(Animations.Animation3, unit, 1, "GojoAnim3")
		local redexp = Mesh:FindFirstChild("redexp"):Clone()
		redexp.a.CFrame = rt.CFrame * CFrame.new(-0.35,-.6,-1)
		redexp.Parent = effectsfolder
		debris.AddItem(redexp,5)

		local MainBox = Mesh:FindFirstChild("MainBox"):Clone()
		MainBox.CFrame = rt.CFrame * CFrame.new(0,-1,0)
		MainBox.Parent = effectsfolder
		debris.AddItem(MainBox,5)
		SoundWrapper:PlaySound(Sound.cape2, rt, Replicated.SoundGroups.UnitSFX)
		wait(0.2)
		unit["Left Arm"].red.tt.ParticleEmitter.Enabled = true
		EmitParticles(unit["Left Arm"].red.emit)
		SoundWrapper:PlaySound(Sound["magic-charge22"], rt, Replicated.SoundGroups.UnitSFX)
		wait(0.4)
		tween_service:Create(unit["Left Arm"].red.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 16}):Play()
		spawn(function()
			for i = 1,8 do
				local kiblast = Mesh:FindFirstChild("trails"):Clone()
				kiblast.CFrame = unit["Left Arm"].red.CFrame * CFrame.new(math.random(-14,14),math.random(-15.5,14.5),math.random(-12,12))

				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,2)

				local rocketpos = kiblast.Position
				local enemypos = unit["Left Arm"].red.Position

				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 25

				local LookAt = CFrame.new(rocketpos,enemypos)

				local Time = math.random(-77,77)/100
				local Time2 = math.random(-77,77)/200
				spawn(function()

					for i = 1,Step do
						kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end
				end)
				task.wait(0.025)
			end
		end)
		SetParticlesEnabled(MainBox,true)

		SetParticlesEnabled(unit["Left Arm"].red,true)

		for _, v in ipairs(unit["Left Arm"].red.beam:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 1.4}):Play()
			end
		end

		wait(0.9)
		SoundWrapper:PlaySound(Sound["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)
		wait(.3)
		SoundWrapper:PlaySound(Sound["magic-cast-a08"], rt, Replicated.SoundGroups.UnitSFX)
		tween_service:Create(unit["Left Arm"].red.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 22,Brightness = 4}):Play()
		SetParticlesEnabled(MainBox,false)

		EmitParticles(redexp)
		SetParticlesEnabled(unit["Left Arm"].red,false)

		for _, v in ipairs(unit["Left Arm"].red.beam:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		spawn(function()
			wait(0.3)
			tween_service:Create(unit["Left Arm"].red.PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 0,Brightness = 0}):Play()
		end)
	end
	movehere3()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
