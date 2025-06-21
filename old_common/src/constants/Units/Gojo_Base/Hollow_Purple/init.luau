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
	HitDelay = 3.35, -- seconds
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

	local function movehere4()
		local animation = AnimModule.PlayAnim(Animations.Animation4, unit, 1, "GojoAnim4")

		wait(0.25)

		SoundWrapper:PlaySound(Sound.cape2, rt, Replicated.SoundGroups.UnitSFX)

		wait(0.25)

		local blue1 = Mesh:FindFirstChild("blue1"):Clone()
		blue1.rootpart.CFrame = rt.CFrame * CFrame.new(-6,1,-2.5)
		blue1.Parent = effectsfolder
		debris.AddItem(blue1,5)

		SoundWrapper:PlaySound(Sound["magic-charge22"], rt, Replicated.SoundGroups.UnitSFX)

		tween_service:Create(blue1.blue.beam.cc, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 16}):Play()
		tween_service:Create(blue1.blue.beam.bb, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 10}):Play()
		tween_service:Create(blue1.blue.beam.aa, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 10}):Play()

		tween_service:Create(blue1.rootpart.PointLight, TweenInfo.new(.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 14}):Play()

		SetParticlesEnabled(blue1,true)

		blue1.rootpart.Attachment.ParticleEmitter:Emit(1)

		local lightning = Mesh:FindFirstChild("lightning"):Clone()
		lightning.CFrame = rt.CFrame * CFrame.new(0,1,-2.5)
		lightning.Parent = effectsfolder
		debris.AddItem(lightning,5)

		wait(0.3)

		local red1 = Mesh:FindFirstChild("red1"):Clone()
		red1.rootpart.CFrame = rt.CFrame * CFrame.new(6,1,-2.5)
		red1.Parent = effectsfolder
		debris.AddItem(red1,5)

		SetParticlesEnabled(red1,true)

		tween_service:Create(red1.rootpart.PointLight, TweenInfo.new(.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 14}):Play()

		tween_service:Create(red1.red.beam.cc, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 16}):Play()
		tween_service:Create(red1.red.beam.bb, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 10}):Play()
		tween_service:Create(red1.red.beam.aa, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 10}):Play()
		red1.rootpart.Attachment.ParticleEmitter:Emit(1)

		wait(0.25)

		local purple = Mesh:FindFirstChild("purple"):Clone()
		purple.RootPart.CFrame = rt.CFrame * CFrame.new(0,1,-2.5)
		purple.Parent = effectsfolder
		debris.AddItem(purple,6)

		local ex = Mesh:FindFirstChild("ExplosionImpact1"):Clone()
		ex.CFrame = rt.CFrame * CFrame.new(0,-1.35,-2.5)
		ex.Parent = effectsfolder
		debris.AddItem(ex,6)

		local aaa = Mesh:FindFirstChild("aaa"):Clone()
		aaa.CFrame = rt.CFrame * CFrame.new(0,1,-2.5)
		aaa.Parent = effectsfolder
		debris.AddItem(aaa,6)

		local pex = Mesh:FindFirstChild("purpleexp"):Clone()
		pex.a.CFrame = rt.CFrame * CFrame.new(0,-0.5,-2.5)
		pex.Parent = effectsfolder
		debris.AddItem(pex,6)

		local dash1 = Mesh:FindFirstChild("dash1"):Clone()
		dash1.CFrame = rt.CFrame * CFrame.new(0,-.75,-2.5)
		dash1.Parent = effectsfolder
		debris.AddItem(dash1,6)

		local MainBox1 = Mesh:FindFirstChild("MainBox1"):Clone()
		MainBox1.CFrame = rt.CFrame * CFrame.new(0,-1,-2.5)
		MainBox1.Parent = effectsfolder
		debris.AddItem(MainBox1,6)

		local a = Mesh:FindFirstChild("a"):Clone()
		a.CFrame = rt.CFrame * CFrame.new(0,0,-1)
		a.Parent = effectsfolder
		debris.AddItem(a,6)

		tween_service:Create(red1.rootpart, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = rt.CFrame * CFrame.new(0,1,-2.5)}):Play()
		tween_service:Create(blue1.rootpart, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = rt.CFrame * CFrame.new(0,1,-2.5)}):Play()


		wait(0.5)

		SetParticlesEnabled(lightning,true)

		wait(0.5)
		SoundWrapper:PlaySound(Sound["magic-cast-heavy05"], purple.RootPart, Replicated.SoundGroups.UnitSFX)

		SetParticlesEnabled(MainBox1,true)

		local groundimpact1 = Mesh:FindFirstChild("groundimpact1"):Clone()
		groundimpact1.CFrame = rt.CFrame * CFrame.new(0,-1,-66)
		groundimpact1.Parent = effectsfolder
		debris.AddItem(groundimpact1,6)

		local IMP = Mesh:FindFirstChild("IMP"):Clone()
		IMP.CFrame = rt.CFrame * CFrame.new(0,2,-66)
		IMP.Parent = effectsfolder
		debris.AddItem(IMP,6)

		tween_service:Create(blue1.rootpart.PointLight, TweenInfo.new(.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 0}):Play()
		tween_service:Create(red1.rootpart.PointLight, TweenInfo.new(.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 0}):Play()
		EmitParticles(aaa)

		SetParticlesEnabled(lightning,false)
		SetParticlesEnabled(red1,false)

		tween_service:Create(red1.red.beam.cc, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(red1.red.beam.bb, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(red1.red.beam.aa, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()


		tween_service:Create(blue1.blue.beam.cc, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(blue1.blue.beam.bb, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(blue1.blue.beam.aa, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()

		SetParticlesEnabled(blue1,false)



		purple.FireBall.tt.emit:Emit(1)


		SetParticlesEnabled(purple.FireBall,true)
		tween_service:Create(purple.FireBall.PointLight, TweenInfo.new(.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 18}):Play()

		wait(.75)

		EmitParticles(a)

		--Sound(sounds:FindFirstChild(""),purple.RootPart,5.5)
		SoundWrapper:PlaySound(Sound["magic-cast-heavy14"], purple.RootPart, Replicated.SoundGroups.UnitSFX)

		SetParticlesEnabled(MainBox1,false)
		SetParticlesEnabled(dash1,true)
		tween_service:Create(dash1, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = rt.CFrame * CFrame.new(0,-.75,-66)}):Play()

		EmitParticles(pex)
		EmitParticles(ex)

		tween_service:Create(purple.RootPart, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {CFrame = rt.CFrame * CFrame.new(0,1.5,-66)}):Play()
		SetParticlesEnabled(purple.part,true)
		rocks({

			amount = 12;
			minSideForce = 10;
			maxSideForce = 45;
			minYForce = 35;
			maxYForce = 125;
			minRotation = 5;
			maxRotation = 10;
			minSize = 1;
			maxSize = 2;
			filter = {};
			transparency = 0;
			position = purple.RootPart.Position;
			tweenSizeTime = 0.1;
			mass = 1;
			radius = 3; 
			collide = false;
		})
		spawn(function()
			wait(.2)
			rocks({

				amount = 12;
				minSideForce = 10;
				maxSideForce = 45;
				minYForce = 35;
				maxYForce = 125;
				minRotation = 5;
				maxRotation = 10;
				minSize = 1;
				maxSize = 2;
				filter = {};
				transparency = 0;
				position = purple.RootPart.Position;
				tweenSizeTime = 0.1;
				mass = 1;
				radius = 3; 
				collide = false;
			})
			wait(.4)
			rocks({

				amount = 12;
				minSideForce = 10;
				maxSideForce = 45;
				minYForce = 35;
				maxYForce = 125;
				minRotation = 5;
				maxRotation = 10;
				minSize = 1;
				maxSize = 2;
				filter = {};
				transparency = 0;
				position = purple.RootPart.Position;
				tweenSizeTime = 0.1;
				mass = 1;
				radius = 3; 
				collide = false;
			})
			wait(.4)
			rocks({

				amount = 12;
				minSideForce = 10;
				maxSideForce = 45;
				minYForce = 35;
				maxYForce = 125;
				minRotation = 5;
				maxRotation = 10;
				minSize = 1;
				maxSize = 2;
				filter = {};
				transparency = 0;
				position = purple.RootPart.Position;
				tweenSizeTime = 0.1;
				mass = 1;
				radius = 3; 
				collide = false;
			})
		end)
		wait(1)

		EmitParticles(IMP)

		SetParticlesEnabled(dash1,false)
		EmitParticles(groundimpact1)
		SetParticlesEnabled(purple,false)
		tween_service:Create(purple.FireBall.PointLight, TweenInfo.new(.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 26,Brightness = 5}):Play()
		spawn(function()
			wait(0.3)
			tween_service:Create(purple.FireBall.PointLight, TweenInfo.new(.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 0,Brightness = 0}):Play()
		end)
	end
	movehere4()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
