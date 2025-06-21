local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local rn = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 2.2, -- seconds
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

function Beam(model,dur,t,t2,x)
	for i,v in pairs(model:GetChildren()) do
		if v:IsA('Beam') then
			local w0 = v.Width0 
			local w1 = v.Width1

			v.Width0 = 0
			v.Width1 = 0

			v.Enabled = true

			if t == nil then
				t = .15
			end

			if t2 == nil then
				t2 = .15
			end

			if x == nil then
				x = 2
			end

			tween_service:Create(v,TweenInfo.new(t2),{Width0 = w0*x;Width1 = w0*x}):Play()
			delay(.1,function()
				tween_service:Create(v,TweenInfo.new(t),{Width0 = w0;Width1 = w1}):Play()
				delay(dur,function()
					tween_service:Create(v,TweenInfo.new(t),{Width0 = 0;Width1 = 0}):Play()
				end)
			end)

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

local function lerp(p0,p1,t)
	return p0*(1-t) + p1*t
end

local function quad(p0,p1,p2, t)
	local l1 = lerp(p0,p1,t)
	local l2 = lerp(p1,p2,t)
	local quad = lerp(l1,l2,t)
	return quad
end

function Particle(particle,dl)
	for i,v in pairs(particle:GetChildren()) do
		if v:IsA('ParticleEmitter') then
			v.Enabled = true

			delay(dl,function()
				v.Enabled = false
			end)
		elseif v:IsA('Attachment') then
			for i,v2 in pairs(v:GetChildren()) do
				if v2:IsA("ParticleEmitter") then
					v2.Enabled = true

					delay(dl,function()
						v2.Enabled = false
					end)
				end
			end
		end
	end
end

function rocks(properties)
	local rand = Random.new()
	local defaultProperties = {
		amount = 10;
		minSideForce = 10;
		maxSideForce = 40;
		minYForce = 65;
		maxYForce = 130;
		minRotation = 5;
		maxRotation = 10;
		minSize = 2;
		maxSize = 4;
		color = Color3.fromRGB(163, 162, 165);
		material = Enum.Material.Rock;
		useColorAndMaterial = false;
		filter = {};
		transparency = 0;
		position = Vector3.new();
		tweenSizeTime = 0.1;
		mass = 1;
		radius = 0; 
		collide = false;
		useParticle = false;
		particleLifetime = 1.5;
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

			local offsetPos = pos+Vector3.new(rand:NextNumber(-radius,radius),0.5,rand:NextNumber(-radius,radius))
			local direction = Vector3.new(0,-4.5)

			local rayParams = RaycastParams.new()

			local chars = {}
			for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
				if plr.Character then
					table.insert(chars,plr.Character)
				end
			end

			for _,char in pairs(chars) do
				table.insert(properties["filter"],char)
			end

			rayParams.FilterDescendantsInstances = properties["filter"]

			local rayResult = workspace:Raycast(offsetPos,direction,rayParams)

			local rockPos = rayResult and rayResult.Position or pos
			local rockMaterial = properties["useColorAndMaterial"] and properties["material"] or (rayResult and rayResult.Material or properties["material"])
			local rockColor = properties["useColorAndMaterial"] and properties["color"] or (rayResult and rayResult.Instance.Color or properties["color"])

			local rock = Instance.new("Part")

			local particle

			if properties["useParticle"] then
				particle = properties["useParticle"]:Clone()
				particle.Enabled = true
				particle.Parent = rock
			end

			rock.Size = Vector3.new()

			local sizeNumber = rand:NextNumber(properties["minSize"],properties["maxSize"])
			local endSize = Vector3.new(sizeNumber,sizeNumber,sizeNumber)

			tween_service:Create(rock,TweenInfo.new(properties["tweenSizeTime"],Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = endSize}):Play()

			rock.CustomPhysicalProperties = PhysicalProperties.new(properties["mass"],0.3,0.5,1,1)

			rock.Color = rockColor
			rock.Material = rockMaterial
			rock.Anchored = false
			rock.CanCollide = false
			rock.Transparency = properties["transparency"]

			local cosTheta = math.random()*2 - 1
			local theta = math.acos(cosTheta)
			local phi = math.random()*math.pi*2
			local x = math.sin(theta)*math.cos(phi)
			local y = math.sin(theta)*math.sin(phi)
			local z = cosTheta
			local v = Vector3.new(x, y, z)

			rock.CFrame = CFrame.lookAt(rockPos,rockPos+v)
			local startPos = rock.Position
			rock.Parent = workspace

			local velocityX = rand:NextNumber(-maxXZForce,maxXZForce)
			local velocityY = rand:NextNumber(minYForce,maxYForce)
			local velocityZ = rand:NextNumber(-maxXZForce,maxXZForce)

			if math.random() > 0.5 then
				velocityX = ( (velocityX > minXZForce or velocityX < -minXZForce) or (velocityZ > minXZForce or velocityZ < -minXZForce) ) and velocityX or (math.random()>0.5 and minXZForce or -minXZForce)
			else
				velocityZ = ( (velocityZ > minXZForce or velocityZ < -minXZForce) or (velocityX > minXZForce or velocityX < -minXZForce) ) and velocityZ or (math.random()>0.5 and minXZForce or -minXZForce)
			end

			local impulseVector = Vector3.new(velocityX,velocityY,velocityZ)

			rock.Velocity = impulseVector

			local rotationX = math.random()>0.5 and rand:NextNumber(properties["minRotation"],properties["maxRotation"]) or rand:NextNumber(-properties["minRotation"],-properties["maxRotation"])
			local rotationY = math.random()>0.5 and rand:NextNumber(properties["minRotation"],properties["maxRotation"]) or rand:NextNumber(-properties["minRotation"],-properties["maxRotation"])
			local rotationZ = math.random()>0.5 and rand:NextNumber(properties["minRotation"],properties["maxRotation"]) or rand:NextNumber(-properties["minRotation"],-properties["maxRotation"])

			local rotationVelocity = Vector3.new(rotationX,rotationY,rotationZ)

			rock.RotVelocity = rotationVelocity

			if properties["collide"] then
				task.delay(0.1,function()
					rock.CanCollide = true
					local touchCon
					touchCon = rock.Touched:Connect(function(obj)
						touchCon:Disconnect()

						task.delay(1+rand:NextNumber(-0.3,0.7),function()

							--disable particles
							if properties["useParticle"] then
								particle.Enabled = false

								task.wait(properties["particleLifetime"]-1)
							end

							tween_service:Create(rock,TweenInfo.new(0.5,Enum.EasingStyle.Linear),{Transparency = 1}):Play()

							task.delay(0.5,rock.Destroy,rock)

						end)

					end)
				end)



			else

				task.spawn(function()
					repeat
						task.wait()
					until rock.Position.Y < startPos.Y-5

					tween_service:Create(rock,TweenInfo.new(properties["tweenSizeTime"]+0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Size = Vector3.new()}):Play()

					if properties["useParticle"] then
						particle.Enabled = false

						task.wait(properties["particleLifetime"]-(properties["tweenSizeTime"]+0.1))
					end

					game:GetService("Debris"):AddItem(rock,properties["tweenSizeTime"]+0.1)

				end)

			end

		end)
	end
end

function SetRock(Middle,Cound,Area,Size,dur)
	spawn(function()

		local C = Cound or 5
		local A = Area or 25
		local Si = Size or 25

		local RockModel = Instance.new("Model")
		RockModel.Name = "Rock"

		RockModel.Parent = workspace.CurrentCamera
		game.Debris:AddItem(RockModel,12)

		local Info = TweenInfo.new(
			.3, 
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out, 
			0, 
			false, 
			0 
		)

		local SS = Area/7.5 * 20
		local Goals = {
			Size = Vector3.new(SS,SS,SS);
		}

		delay(0.1,function()
			local Goals = {
				Transparency = 1
			}

		end)

		for i = 1,C do
			local Rather = A * math.random(5,10)/7.5


			local R = Instance.new("Part")
			R.Parent = RockModel
			R.Material = "Slate"
			R.Name = "Rock".. math.random(.5,50) * math.random(.5,50)
			R.Color = Color3.new(0.2, 0.2, 0.2)
			R.Anchored = true
			R.CanCollide = false

			R.Size = Vector3.new(Si*1,Si*1,Si*1)
			R.CFrame = Middle * CFrame.new( (math.cos(math.rad((i *  (-360 / C) )))* Rather) ,-9, (math.sin(math.rad((i *  (-360 / C)))) * Rather)) 
			R.CFrame = CFrame.new(R.Position,Middle.Position)


			spawn(function()
				local Info = TweenInfo.new(
					.25, -- Time
					Enum.EasingStyle.Sine, 
					Enum.EasingDirection.Out, 
					0, 
					false,
					0 
				)


				local Goals = {
					Position = R.Position + Vector3.new(0,6.5,0)

				}


				local Tween = tween_service:Create(R, Info, Goals)
				Tween:Play()


			end)
		end

		for i,rock in pairs(RockModel:GetChildren()) do
			rock.CanCollide = false
		end

		wait(dur)
		for i,rock in pairs(RockModel:GetChildren()) do
			local Info = TweenInfo.new(
				2, 
				Enum.EasingStyle.Sine,
				Enum.EasingDirection.InOut,
				0, 
				false, 
				0 
			)

			local Goals = {
				Transparency = 1;
				Position = rock.Position + Vector3.new(0,-3,0);
				Size = Vector3.new(0,0,0)
			}	

			local Tween = tween_service:Create(rock, Info, Goals)
			Tween:Play()

		end

	end)
end

local function tp(humrp,cf)

	local x = {humrp,cf}

	for i = 1,2 do
		local model = script.Blink:Clone()
		model.CFrame = x[i]
		model.Parent = effectsfolder
		debris.AddItem(model,4)

		Particle(model,.35)
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
		task.wait(0.45)
		SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	end)	
	task.wait(1)
	local humrp = rt
	local Enemy = pos
	
	local o = humrp.CFrame

	local c = script.Ground:Clone()
	c:SetPrimaryPartCFrame(humrp.CFrame)
	c.Parent = effectsfolder
	debris.AddItem(c,5)
	
	emit.emitvfx(c.Crack)
	emit.emitvfx(c.Ground)

	task.wait(.45)

	for i = 1,3 do

		task.spawn(function()
			local module = require(script.DragonCurve)
			module.DragonCurve(Enemy,unit,i)

		end)

	end

	task.delay(.45,function()

		local model = script.Explosion_Burst:Clone()
		model:SetPrimaryPartCFrame(Enemy.CFrame * CFrame.new(0,-1,0))
		model.Parent = effectsfolder
		debris.AddItem(model,5)

		local dur = .5

		task.spawn(function()
			for i = 1,10 do
				model.Sparkle:ScaleTo(model.Sparkle:GetScale() + .2)
				rn.Heartbeat:Wait()
			end

		end)

		Particle(model.Sparkle.Spark,.2)
		task.wait(.15)

		task.spawn(function()

			tween_service:Create(model.Particle.Crack.PL,TweenInfo.new(.5),{Brightness = 3;Range = 25}):Play()

			for i = 1,10 do
				model.Particle:ScaleTo(model.Particle:GetScale() + .075)
				rn.Heartbeat:Wait()
			end

			for i,v in pairs(model.Particle:GetChildren()) do
				if v.Name == 'Wind' then
					Beam(v,dur,.15,.15)
				end
			end

			Particle(model.Particle.Explosion,dur)
			Particle(model.Particle.Shards,dur)
			Particle(model.Particle.Crack,dur)
			Particle(model.Particle.Crack_,dur)

			emit.emitvfx(model.Particle.Explosion)
			emit.emitvfx(model.Particle.Shards)
			emit.emitvfx(model.Particle.Crack)
			emit.emitvfx(model.Particle.Crack_)


			task.delay(dur,function()
				tween_service:Create(model.Particle.Crack.PL,TweenInfo.new(2),{Brightness = 0;Range = 0}):Play()
			end)

		end)

		task.spawn(function()
			for i = 1,90 do
				model.Wind:SetPrimaryPartCFrame(model.Wind:GetPrimaryPartCFrame() * CFrame.Angles(0,math.rad(-2),0))
				rn.Heartbeat:Wait()
			end
		end)

		task.spawn(function()
			for i = 1,10 do
				model.Wind:ScaleTo(model.Wind:GetScale() + .175)
				rn.Heartbeat:Wait()
			end
		end)

		task.delay(dur,function()
			for i,v in pairs(model.Wind:GetChildren()) do
				tween_service:Create(v,TweenInfo.new(.5),{Transparency = 1}):Play()
			end
		end)

	end)


end


	

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
