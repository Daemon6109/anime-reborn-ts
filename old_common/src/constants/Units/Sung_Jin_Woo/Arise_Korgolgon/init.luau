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
	HitDelay = 3.5, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
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
	
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	local atk = script.Attack2:FindFirstChild("Model"):Clone()
	atk.Part.CFrame = rt.CFrame * CFrame.new(-2.936, -1, 1.835)
	atk.Parent = effectsfolder
	debris.AddItem(atk,6)

	task.wait(0.5)

	local ShadowMage = script.Attack2:FindFirstChild("ShadowMage"):Clone()
	ShadowMage.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(-0.936, -5, -3.835)
	atk.Part.CFrame =  rt.CFrame * CFrame.new(-0.936, -1, -3.835)
	ShadowMage.Parent = effectsfolder
	
	debris.AddItem(ShadowMage,5)
	emit.enablevfx(atk,true)
	for i, v in pairs(atk.Part:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.375,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 1.2,Width1 = 1.2}):Play()
		end
	end 
	emit.enablevfx(atk,true)
	local ANIMM = AnimModule.PlayAnim(script.Animation2Mage, ShadowMage, 1, "", {Weight = 2, Fade = .15})
	--local animation = ShadowMage.Humanoid:LoadAnimation(script.Animation2Mage):Play()
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	
	spawn(function()
		local maxSize = .7 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.1 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.1 * maxSize -- Função de interpolação cúbica
			atk:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	local Transparencyshoottween = tween_service:Create(ShadowMage.HumanoidRootPart,TweenInfo.new(0.8,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = ShadowMage.HumanoidRootPart.CFrame * CFrame.new(0,5,0)}):Play()

	task.wait(0.5)

	for i, v in pairs(atk.Part:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.375,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end 

	task.wait(1.5)

	local Meteor = script.Attack2:FindFirstChild("Meteor"):Clone()
	Meteor.CFrame = rt.CFrame * CFrame.new(-0.936, 17, -3.835)
	Meteor.Parent = effectsfolder
	debris.AddItem(Meteor,5)

	local bb = script.Attack2:FindFirstChild("bbbb"):Clone()
	bb.CFrame = Meteor.CFrame
	bb.Orientation = Vector3.new()
	bb.Parent = effectsfolder
	debris.AddItem(bb,5)



	EmitParticles(bb)

	local Transparencyshoottween = tween_service:Create(Meteor,TweenInfo.new(0.9,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,-1,0)}):Play()

	task.wait(0.9)

	local aa = script.Attack2:FindFirstChild("aaaaaa"):Clone()
	aa.CFrame = Meteor.CFrame
	aa.Orientation = Vector3.new()
	aa.Parent = effectsfolder
	debris.AddItem(aa,5)

	emit.enablevfx(Meteor,false)

	EmitParticles(aa)

	rocks({
		amount = 7,
		minSideForce = 12,
		maxSideForce = 25,
		minYForce = 45,
		maxYForce = 66,
		minRotation = 5,
		maxRotation = 10,
		minSize = 0,
		maxSize = 0,
		filter = {},
		transparency = 0,
		position = aa.Position,
		tweenSizeTime = 0.1,
		mass = 1,
		radius = 1,
		collide = false,
	})

	local Transparencyshoottween = tween_service:Create(Meteor.PointLight,TweenInfo.new(0.5,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 0}):Play()

	task.wait(0.3)


	for i, v in pairs(atk.Part:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.375,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 1.2,Width1 = 1.2}):Play()
		end
	end 

	local Transparencyshoottween = tween_service:Create(ShadowMage.HumanoidRootPart,TweenInfo.new(0.7,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = ShadowMage.HumanoidRootPart.CFrame * CFrame.new(0,-6,0)}):Play()

	task.wait(0.5)

	emit.enablevfx(atk,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
