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
			local function createhighlight(parentpart,fillcolor,filltransparenc,outlinecolor,outlinetranspcnr)
				local highlight = Instance.new("Highlight")
				highlight.Parent = parentpart
				highlight.FillColor = fillcolor
				highlight.FillTransparency = filltransparenc
				highlight.OutlineColor = outlinecolor
				highlight.OutlineTransparency = outlinetranspcnr
				return highlight
			end

			task.spawn(function()
				local hgl = createhighlight(rock,Color3.fromRGB(255, 208, 21),1,Color3.fromRGB(255, 213, 107),0)	
				task.wait(.4)

				hgl:Destroy()
			end)			
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
	
	local LoadAnim = unit.DIO.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation3))
	LoadAnim:Play()

	local LoadAnim2 = unit.DIO["Dio stand"].AnimationController:LoadAnimation(AnimModule.GetAnim(script["Animation3 Stand"]))
	LoadAnim2:Play()
	
	AnimModule.ChangeAnimSpeed(LoadAnim2,1.6)
	AnimModule.ChangeAnimSpeed(LoadAnim,1.6)
	
	task.spawn(function()
		task.wait(.2)
		SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	end)
	
	local Positionrt = Instance.new("Part")
	Positionrt.Anchored = true
	Positionrt.Transparency = 1
	Positionrt.CanCollide = false
	Positionrt.CanTouch = false
	Positionrt.CFrame = rt.CFrame
	Positionrt.Parent = effectsfolder
	debris.AddItem(Positionrt,5)

	EmitParticles(unit.DIO["Dio stand"].RootPart.aa)



	wait(0.5)



	unit.DIO["Dio stand"].RootPart.Anchored = true

	task.wait(0.01)

	local s = script.Attack3:FindFirstChild("s"):Clone()
	s.Parent = effectsfolder
	debris.AddItem(s,5)
	s.CFrame = unit.DIO["Dio stand"].RootPart.CFrame * CFrame.new(.4,.4,.2)
	s.CFrame = CFrame.new(s.Position, pos.Position)

	EmitParticles(s)
	local Transparencyshoottween = tween_service:Create(unit.DIO["Dio stand"].RootPart,TweenInfo.new(.6,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,-0.3,0)}):Play()


	wait(1.4)

	local Model = script.Attack3:FindFirstChild("Model"):Clone()
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)
	Model.Part.CFrame = unit.DIO["Dio stand"].RootPart.CFrame * CFrame.new(0,-1,-.9)

	local Model2 = script.Attack3:FindFirstChild("Model2"):Clone()
	Model2.Parent = effectsfolder
	debris.AddItem(Model,5)
	Model2.Part.CFrame = unit.DIO["Dio stand"].RootPart.CFrame * CFrame.new(0,-1,-.9)

	spawn(function()
		local maxSize = 1 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.2 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Função de interpolação cúbica
			Model:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)
	spawn(function()
		local maxSize = 1.4 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.2 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Função de interpolação cúbica
			Model2:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)
	local Model1 = script.Attack3:FindFirstChild("Model1"):Clone()
	Model1.Parent = effectsfolder
	debris.AddItem(Model1,5)
	Model1.Part.CFrame = unit.DIO["Dio stand"].RootPart.CFrame * CFrame.new(0,-1,-.9)


	spawn(function()
		local maxSize = 1.79 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.1 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.1 * maxSize -- Função de interpolação cúbica
			Model1:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)
	local ex = script.Attack3:FindFirstChild("ex"):Clone()
	ex.Parent = effectsfolder
	debris.AddItem(ex,5)
	ex.CFrame = unit.DIO["Dio stand"].RootPart.CFrame * CFrame.new(0,-1,-.9)

	EmitParticles(ex)

	rocks({

		amount = 12;
		minSideForce = 25;
		maxSideForce = 33;
		minYForce = 45;
		maxYForce = 66;
		minRotation = 5;
		maxRotation = 10;
		minSize = 0.75;
		maxSize = 1.2;
		filter = {};
		transparency = 0;
		position = ex.Position;
		tweenSizeTime = 0.1;
		mass = 1;
		radius = 1; 
		collide = false;
	})



	wait(0.8)




	for i, v in pairs(Model:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.4,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end
	for i, v in pairs(Model2:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(.4,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end

	for i, v in pairs(Model1:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(.4,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end
	unit.DIO["Dio stand"].RootPart.Anchored = false

	local Transparencyshoottween = tween_service:Create(unit.DIO["Dio stand"].RootPart,TweenInfo.new(.35,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = unit.DIO.RootPart.CFrame}):Play()





	task.wait(1.391)




	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
