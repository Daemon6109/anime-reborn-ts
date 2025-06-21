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
	HitDelay = 2.3, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
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
					
					rock.Attachment.Stars:Emit(1)
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)

	local emitss = script.Move1:FindFirstChild("emitsaa"):Clone()
	emitss.Parent = effectsfolder
	debris.AddItem(emitss,5)
	emitss.root.CFrame = rt.CFrame * CFrame.new(0,-1,0)

	EmitParticles(emitss)

	wait(1.4)

	-- Cria a IceSpike
	local Icespike1 = script.Move1:FindFirstChild("IceSpike1"):Clone()
	Icespike1.Part.CFrame = rt.CFrame * CFrame.new(0,0.75,-1)
	Icespike1.Parent = effectsfolder
	debris.AddItem(Icespike1, 5)
	Icespike1.Part.CFrame = CFrame.new(Icespike1.Part.Position, pos.Position)

	local Part = script.Move1:FindFirstChild("Part"):Clone()
	Part.CFrame = Icespike1.Part.CFrame * CFrame.new(0,0,-0.5)
	Part.Parent = effectsfolder
	debris.AddItem(Icespike1, 5)

	local Part11 = script.Move1:FindFirstChild("Part1"):Clone()
	Part11.CFrame = Icespike1.Part.CFrame * CFrame.new(0,0,-0.5)
	Part11.Parent = effectsfolder
	debris.AddItem(Part11, 5)

	local Part2 = script.Move1:FindFirstChild("Part2"):Clone()
	Part2.CFrame = Icespike1.Part.CFrame
	Part2.Parent = effectsfolder
	debris.AddItem(Part2, 5)

	EmitParticles(Part)

	Icespike1.ShardNeon.ParticleEmitter:Emit(4)


	Icespike1.Shard.ParticleEmitter.Enabled = true



	EmitParticles(Icespike1.Part)
	tween_service:Create(Icespike1.Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Range = 6}):Play()
	tween_service:Create(Icespike1.Shard, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(0.329, 5.364, 0.256)}):Play()
	tween_service:Create(Icespike1.ShardNeon, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(0.237, 5.328, 0.316)}):Play()

	for _, v in pairs(Icespike1.Shard.Beam:GetChildren()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 1.5}):Play()
		end
	end


	wait(0.4)



	local aa = script.Move1:FindFirstChild("aa"):Clone()
	aa.Parent = effectsfolder
	debris.AddItem(aa,5)
	aa.root.CFrame = rt.CFrame * CFrame.new(0,-1,-1.75)

	tween_service:Create(aa.root, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = pos.CFrame * CFrame.new(0,-1,0)}):Play()

	EmitParticles(Part2) 

	tween_service:Create(Icespike1.Part, TweenInfo.new(0.125, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = pos.CFrame}):Play()
	wait(0.125)

	local gira = script.Move1:FindFirstChild("gira"):Clone()
	gira.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	gira.Parent = effectsfolder
	debris.AddItem(gira, 5)

	EmitParticles(gira)

	emit.enablevfx(aa,false)

	Icespike1.Shard.ParticleEmitter.Enabled = false

	tween_service:Create(gira.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Range = 6}):Play()
	rocks({

		amount = 6;
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
		position = pos.Position + Vector3.new(0,0,0);
		tweenSizeTime = 0.1;
		mass = 1;
		radius = 1; 
		collide = false;
	})

	for _, v in pairs(Icespike1.Shard.Beam:GetChildren()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		end
	end

	EmitParticles(Icespike1.Part)
	tween_service:Create(Icespike1.Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Range = 0}):Play()
	tween_service:Create(Icespike1.Shard, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()
	tween_service:Create(Icespike1.ShardNeon, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new()}):Play()



	local Part1 = script.Move1:FindFirstChild("Part1"):Clone()
	Part1.CFrame = Icespike1.Part.CFrame
	Part1.Parent = effectsfolder
	debris.AddItem(Part1, 5)

	EmitParticles(Part1)

	wait(0.15)

	tween_service:Create(gira.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Range = 0}):Play()


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
