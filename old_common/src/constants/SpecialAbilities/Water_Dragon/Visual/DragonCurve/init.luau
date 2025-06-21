local module = {}

local PlayersService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local vfx_custom = require(script.Parent.VFX_Custom)

--Bezier Dragon's Settings
local StartSpread = 20
local Point1Height = 25
local Point1Spread = 55
local Point2HeightSpread = 15
local Point2Spread = 50
local ProjectileTimeToArrive = 0.6

--Bezier Dropelts' settings
local AmountOfDroplets = 4
local DropletStartSpread = 5
local DropletPoint1Height = 15
local DropletPoint1Spread = 15
local DropletProjectileTimeToArrive = 0.5

function quadraticBezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
end

function cubicBezier(t, p0, p1, p2, p3)
	return (1 - t)^3 * p0 + 3 * (1 - t)^2 * t * p1 + 3 * (1 - t) * t^2 * p2 + t^3 * p3
end

local function RaycastDown(partPosition)
	local raycastResult = workspace:Raycast(partPosition + Vector3.new(0,200,0) , Vector3.new(0, -500, 0))
	if raycastResult then
		return raycastResult.Position.Y
	end
	return nil
end

local function GenerateQuadraticPoints(Hit:Vector3)

	local startPoint = Hit + Vector3.new(math.random(-DropletStartSpread, DropletStartSpread), 0, math.random(-DropletStartSpread, DropletStartSpread))
	local controlPoint1 = Vector3.new(startPoint.X + math.random(-DropletPoint1Spread, DropletPoint1Spread), startPoint.Y + DropletPoint1Height, startPoint.Z + math.random(-DropletPoint1Spread, DropletPoint1Spread))
	local endPoint =  Vector3.new((2*controlPoint1.X - startPoint.X) , Hit.Y , (2* controlPoint1.Z - startPoint.Z))
	endPoint = Vector3.new(endPoint.X,RaycastDown(endPoint),endPoint.Z)

	return startPoint, controlPoint1, endPoint
end



local function EmitParticles(part)
	if part:FindFirstChild('Particles') then
		local VfxAttachment = part.Particles
		for _, v in ipairs(VfxAttachment:GetChildren()) do
			local EmitCount = v:GetAttribute("EmitCount")
			local EmitDelay = v:GetAttribute("EmitDelay")
			task.delay(EmitDelay, function()
				v:Emit(EmitCount)
			end)
		end
	end
end

local function ParticleToggle(part,Status:boolean)
	part.Shiel.Enabled = Status
	part.Tris.Enabled = Status
end

local function SpawnDroplets(EndPos,Folder)
	for i = 0, AmountOfDroplets, 1 do
		task.spawn(function()
			local startPoint, controlPoint, endPoint = GenerateQuadraticPoints(EndPos)

			local Droplet = script.Droplet:Clone()
			Droplet.Position = startPoint
			Droplet.Parent = Folder


			local NumVal = Instance.new("NumberValue")
			NumVal.Value = 0
			NumVal.Parent = Folder

			local Connection
			Connection = NumVal.Changed:Connect(function()
				Droplet.CFrame = CFrame.new(quadraticBezier(NumVal.Value, startPoint, controlPoint, endPoint))
			end)

			local BezierTween = TweenService:Create(NumVal, TweenInfo.new(DropletProjectileTimeToArrive, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { Value = 1 }):Play()
			task.wait(DropletProjectileTimeToArrive)

			if Connection then
				Connection:Disconnect()
			end

			EmitParticles(Droplet)
			Debris:AddItem(Folder, 1)
			TweenService:Create(Droplet, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
		end)	
	end
end

local function StartEffect(Start:Vector3,Folder)
	local StartPart = script.Start:Clone()
	StartPart.Parent = Folder
	StartPart.Transparency = 1
	StartPart.Position = Start
	EmitParticles(StartPart)
end

function module.Droplet(EndPos)
	
	local Folder = Instance.new("Folder")
	Folder.Parent = workspace.Effects

	
	for i = 0, AmountOfDroplets, 1 do
		task.spawn(function()
			local startPoint, controlPoint, endPoint = GenerateQuadraticPoints(EndPos)

			local Droplet = script.Droplet_:Clone()
			Droplet.Position = startPoint
			Droplet.Parent = Folder


			local NumVal = Instance.new("NumberValue")
			NumVal.Value = 0
			NumVal.Parent = Folder

			local Connection
			Connection = NumVal.Changed:Connect(function()
				Droplet.CFrame = CFrame.new(quadraticBezier(NumVal.Value, startPoint, controlPoint, endPoint))
			end)

			local BezierTween = TweenService:Create(NumVal, TweenInfo.new(DropletProjectileTimeToArrive, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { Value = 1 }):Play()
			task.wait(DropletProjectileTimeToArrive)

			if Connection then
				Connection:Disconnect()
			end

			EmitParticles(Droplet)
			Debris:AddItem(Folder, 1)
			TweenService:Create(Droplet, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Transparency = 1 }):Play()
		end)	
	end
end

function module.DragonCurve(Enemy,Character,x)
	
	local function GenerateCubicPoints()
		local startPoint = Character.PrimaryPart.Position 
		startPoint = Vector3.new(startPoint.X, RaycastDown(startPoint) -1.75 ,startPoint.Z)

		local controlPoint1 = Vector3.new(startPoint.X + math.random(-Point1Spread, Point1Spread), startPoint.Y + Point1Height, startPoint.Z + math.random(-Point1Spread, Point1Spread))
		local controlPoint2 = Vector3.new(controlPoint1.X + math.random(-Point2Spread, Point2Spread), controlPoint1.Y + math.random(-Point2HeightSpread, Point2HeightSpread), controlPoint1.Z + math.random(-Point2Spread, Point2Spread))
		local endPoint = Enemy.Position
		return startPoint, controlPoint1, controlPoint2, endPoint
	end
	
	local startPoint, controlPoint1, controlPoint2, endPoint = GenerateCubicPoints()

	local Folder = Instance.new("Folder")
	Folder.Parent = workspace.Effects

	local part = script.Test:Clone()
	part.Position = startPoint
	part.Parent = Folder

	StartEffect(startPoint,Folder)
	ParticleToggle(part,true)

	local NumVal = Instance.new("NumberValue")
	NumVal.Value = 0
	NumVal.Parent = Folder
	
	task.delay(.4,function()
		
		if x == 1 then
			local burst = script.Explosion:Clone()
			burst:SetPrimaryPartCFrame(Enemy.CFrame * CFrame.new(0,-5,0))
			burst.Parent = workspace.Effects	
			game.Debris:AddItem(burst,5)

			local dur = .25
			task.wait(.15)
			vfx_custom.Particle(burst.Sparkle,.1)
			task.wait(.1)
			vfx_custom.EmitAttr(burst.vfx)
			vfx_custom.EmitAttr(burst.Blast)
			vfx_custom.Beam(burst.Wind_,dur,.15,.15,1.25)
		end

	end)
	
	
	local Connection
	Connection = NumVal.Changed:Connect(function()
		part.CFrame = CFrame.new(cubicBezier(NumVal.Value, startPoint, controlPoint1, controlPoint2, endPoint))

		local currentLocation = part.Position
		local nextLocation = cubicBezier(NumVal.Value + 0.1, startPoint, controlPoint1, controlPoint2, endPoint)

		part.CFrame = CFrame.lookAt(currentLocation, nextLocation)
	end)

	local BezierTween = TweenService:Create(NumVal, TweenInfo.new(ProjectileTimeToArrive, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { Value = 1 }):Play()
	task.wait(ProjectileTimeToArrive)
	
	
	if Connection then
		Connection:Disconnect()
	end

	SpawnDroplets(endPoint,Folder)
	ParticleToggle(part,false)
	EmitParticles(part)
	Debris:AddItem(Folder, 1)
	TweenService:Create(part, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), { Transparency = 1 }):Play()

	
end

return module
