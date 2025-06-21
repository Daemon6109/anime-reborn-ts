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
	HitDelay = 2, -- seconds
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
		radius = 15; 
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

			--rock.Color = rockColor
			--rock.Material = rockMaterial
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

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
--	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move4"], rt, Replicated.SoundGroups.UnitSFX)


	local move4 = script.Move4:FindFirstChild("Move4"):Clone()
	move4.Parent = effectsfolder
	debris.AddItem(move4,5.5)
	move4.jump.CFrame = rt.CFrame * CFrame.new( 0 , -1.25 , 0 )

	emit.emitvfx(move4)

	task.wait(1.5)

	rocks({

		amount = 6;
		minSideForce = 10;
		maxSideForce = 45;
		minYForce = 35;
		maxYForce = 66;
		minRotation = 5;
		maxRotation = 10;
		minSize = 1;
		maxSize = 2;
		filter = {};
		transparency = 0;
		position = rt.Position + Vector3.new(0,-2,0);
		tweenSizeTime = 0.1;
		mass = 1;
		radius = 8; 
		collide = false;
	})

	spawn(function()

		local unit = rt -- Supondo que rt seja uma parte ou instância da sua unidade
		local unitPosition = unit.Position -- Acessa a propriedade Position da unidade
		local tremorDistance = 25 -- Distância máxima para causar o tremor (em studs)

		-- Função para calcular a distância entre o player e a unidade

		-- THIS IS FOR A POTENTIAL CAMERA SHAKE

		local function isPlayerNear()


			--local playerPosition = character:WaitForChild("HumanoidRootPart").Position THIS IS FOR A POTENTIAL CAMERA 


			--			local distance = (playerPosition - unitPosition).Magnitude
			--	return distance <= tremorDistance
		end

		-- THIS IS FOR A POTENTIAL CAMERA SHAKE


		local function ShakeScreen(intensity, frequency, duration)
			if not isPlayerNear() then return end -- Se o player estiver longe, não treme

			local startTime = tick()

			local function onRenderStep()
				if tick() - startTime < duration then
					local offset = Vector3.new(
						math.random() * intensity - intensity / 2,
						math.random() * intensity - intensity / 2,
						math.random() * intensity - intensity / 2
					)
					--humanoid1.CameraOffset = offset
				else
					--humanoid1.CameraOffset = Vector3.new() -- Parar o tremor
					--RunService:UnbindFromRenderStep("CameraShake")
				end
			end

			--			RunService:BindToRenderStep("CameraShake", Enum.RenderPriority.Camera.Value, onRenderStep)
		end


		-- THIS IS FOR A POTENTIAL CAMERA SHAKE

		task.spawn(function()
			-- Exemplo: Apenas um ataque especial causa tremor
			ShakeScreen(0.2, 0.04, 0.35)
		end)

	end)

	task.wait(0.5)

	rocks({

		amount = 7;
		minSideForce = 10;
		maxSideForce = 45;
		minYForce = 35;
		maxYForce = 66;
		minRotation = 5;
		maxRotation = 10;
		minSize = 1;
		maxSize = 2;
		filter = {};
		transparency = 0;
		position = rt.Position + Vector3.new(0,-2,0);
		tweenSizeTime = 0.1;
		mass = 1;
		radius = 10; 
		collide = false;
	})


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
