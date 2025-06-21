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
	HitDelay = 1.7, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.2, "", {Weight = 2, Fade = .15})
	

	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local humrp = rt
	local Enemy = pos

	local o = humrp.CFrame


	local c = script.Ground:Clone()
	c:SetPrimaryPartCFrame(humrp.CFrame)
	c.Parent = effectsfolder
	debris.AddItem(c,5)

	local dur = 1.35

	Particle(c.Crack,dur)
	Particle(c.Ground,dur)

	Particle(c.Crack,dur)
	Particle(c.Ground,dur)

	delay(.5,function()
		local dur = 1
		Particle(unit.Acc.Charge_,dur)
		tween_service:Create(unit.Acc.Charge_.PL,TweenInfo.new(.35),{Range= 8;Brightness = 1}):Play()
		delay(dur,function()
			tween_service:Create(unit.Acc.Charge_.PL,TweenInfo.new(.35),{Range= 0;Brightness = 0}):Play()
		end)
	end)


	task.spawn(function()
		for i = 1,8 do

			task.spawn(function()
				local en = script.Aura:Clone()
				if i > 4 then
					en = script.Aura_:Clone()
				end

				en.CFrame = humrp.CFrame * CFrame.new(math.random(-5,5),math.random(-3,7),math.random(-12.5,12.5))
				en.Parent = effectsfolder
				debris.AddItem(en,5)

				local cf_ = unit["Right Arm"].CFrame
				local start = en.Position
				local finish = cf_.Position
				local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-25,-15),math.random(-3,5),math.random(-10,10))

				if i%2 == 0 then
					middle = ((en.Position+finish)/2) + Vector3.new(math.random(15,25),math.random(-3,5),math.random(-10,10))
				end

				Particle(en,.35)

				local step = math.random(20,25)

				for i = 1,step do
					en.CFrame = CFrame.lookAt(en.Position,finish) 
					en.Position = quad(start,middle,finish,i/step)
					game:GetService('RunService').Heartbeat:Wait()
				end
			end)

			task.wait(.1)

		end
	end)

	task.wait(1)

	task.spawn(function()

		local en = script.Blast:Clone()
		en.CFrame = humrp.CFrame * CFrame.new(.35,.15,-1.5)
		en.Parent = effectsfolder
		debris.AddItem(en,5)


		Particle(en,.35)
		local step = math.random(20,25)

		local model = script.Impact_:Clone()
		model.CFrame = CFrame.new(en.Position) * CFrame.Angles(math.rad(90),0,0)
		model.Parent = effectsfolder
		debris.AddItem(model,5)


		local dur = .35

		emit.emitvfx(model,2)
		Particle(model,dur)
		tween_service:Create(model.PointLight,TweenInfo.new(.35),{Brightness = 1;Range = 15}):Play()
		delay(dur,function()
			tween_service:Create(model.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
		end)

		tween_service:Create(en,TweenInfo.new(.2),{CFrame= Enemy.CFrame}):Play()
		task.wait(.2)

		tween_service:Create(en.PL,TweenInfo.new(.25),{Brightness = 0;Range = 0}):Play()

		local model = script.Impact:Clone()
		model.CFrame = Enemy.CFrame
		model.Parent = effectsfolder
		debris.AddItem(model,5)

		local dur = .35

		emit.emitvfx(model,2)
		Particle(model,dur)
		tween_service:Create(model.PointLight,TweenInfo.new(.35),{Brightness = 1;Range = 15}):Play()
		delay(dur,function()
			tween_service:Create(model.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
		end)

		local model = script["Burst"]:Clone()
		model:SetPrimaryPartCFrame(Enemy.CFrame * CFrame.new(0,-8.15,0) * CFrame.Angles(math.rad(90),0,0))
		model.Parent = effectsfolder
		debris.AddItem(model,5)

		local dur = .35

		task.wait(.2)

		rocks({
			amount = 35;
			minSideForce = 15;
			maxSideForce = 25;
			minYForce = 35;
			maxYForce = 105;
			minRotation = 3;
			maxRotation = 7;
			minSize = 0.3;
			maxSize = 1;
			color = Color3.new(0.2, 0.2, 0.2);
			material = Enum.Material.Slate;
			useColorAndMaterial = true;
			filter = {};
			transparency = 0;
			position = Enemy.Position;
			tweenSizeTime = 0.1;
			mass = 1;
			radius = 2; 
			collide = true;
			particleLifetime = 2;

		})
		SetRock(Enemy.CFrame,8,4,3,1)
		SetRock(Enemy.CFrame,12,6,2.5,1)
		SetRock(Enemy.CFrame,12,12,2.5,1)

		Particle(model.Charge,dur)
		Particle(model.Impact,dur)
		Particle(model.Ground,dur+.35)

		model.Charge.Att_.Realistic_Contrast:Emit(1)

		emit.emitvfx(model.Impact,1)
		emit.emitvfx(model.Charge,1)
		emit.emitvfx(model.Ground)


		model.Charge.Sparkle.Enabled = false
		model.Charge.Sparkle_.Enabled = false

		tween_service:Create(model.Charge.PointLight,TweenInfo.new(.35),{Brightness = 1;Range = 15}):Play()
		delay(dur-.35,function()
			tween_service:Create(model.Charge.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
		end)

		task.spawn(function()
			for i = 1,6 do

				task.spawn(function()
					local en = script.Aura:Clone()

					if i > 3  then
						en = script.Aura_:Clone()
					end

					en.CFrame = Enemy.CFrame * CFrame.new(math.random(-10,10),math.random(-1.5,3),math.random(-10,10))
					en.Parent = effectsfolder
					debris.AddItem(en,5)

					local cf_ = Enemy.CFrame * CFrame.new(math.random(-25,25),math.random(13,20),math.random(-25,25))
					local start = en.Position
					local finish = cf_.Position
					local middle = ((en.Position+finish)/2) + Vector3.new(math.random(-25,-10),math.random(-3,15),math.random(-20,20))

					if i%2 == 0 then
						middle = ((en.Position+finish)/2) + Vector3.new(math.random(10,25),math.random(-3,15),math.random(-20,20))
					end

					Particle(en,.35)

					local step = math.random(35,45)

					for i = 1,step do
						en.CFrame = CFrame.lookAt(en.Position,finish) 
						en.Position = quad(start,middle,finish,i/step)
						game:GetService('RunService').Heartbeat:Wait()
					end
				end)

				task.wait(.1)

			end
		end)
	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
