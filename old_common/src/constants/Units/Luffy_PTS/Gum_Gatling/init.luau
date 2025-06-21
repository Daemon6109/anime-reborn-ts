local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .2, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}


local function flipbook(ImageTable,Object,Time,Delete)
	local frameTime = Time/#ImageTable
	local t = 0

	local Connection; Connection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
		t = math.min(t+deltaTime, Time)

		local currentFrame = math.floor(t/frameTime)

		Object.TextureID = ImageTable[currentFrame] or ImageTable[1]
		if (t == Time) then
			Connection:Disconnect()
			if Delete then
				Object:Destroy()
			end
		end
	end)
end


local Bezier = require(script.Bezier)


function Bezier:CreateCFrameTween(object: Instance | {[any]: any}, propertyTable: {any}, bezierTweenInfo: TweenInfo, RelativeToLength: boolean?): Tween

	-- check if there are enough points to calculate a cframe within the Bezier
	if #self.Points <= 1 then
		error("Bezier:CreateVector3Tween() only works if there are at least 2 BezierPoints in the Bezier!")
	end

	-- check if the object given is a valid object
	if typeof(object) ~= "Instance" and typeof(object) ~= "table" then
		error("Bezier:CreateCFrameTween() requires an Instance or a table as the first argument!")
	end

	-- check if the bezierTweenInfo given is a TweenInfo object
	if not (typeof(bezierTweenInfo) == "TweenInfo") then
		error("Bezier:CreateCFrameTween() requires a TweenInfo object as the third argument!")
	end

	-- check if the object given has the CFrame properties given
	local success, foundProperties = pcall(function()
		local foundProperties = true
		for _, propertyName in pairs(propertyTable) do
			if typeof(object[propertyName]) ~= "CFrame" and typeof(object[propertyName]) ~= "nil" then
				foundProperties = false
				break
			end
		end
		return foundProperties
	end)

	-- check if the properties were found
	if success and foundProperties then
		local tweenService = game:GetService("TweenService")
		local numValue = Instance.new("NumberValue")
		local tween = tweenService:Create(numValue, bezierTweenInfo, {Value = 1})
		local numValueChangedConnection
		tween.Changed:Connect(function(prop)
			if prop == "PlaybackState" then
				local playbackState = tween.PlaybackState
				if playbackState == Enum.PlaybackState.Playing then
					numValueChangedConnection = numValue.Changed:Connect(function(t)
						for _, propName in pairs(propertyTable) do
							local position = RelativeToLength and self:CalculatePositionRelativeToLength(t) or self:CalculatePositionAt(t)
							local derivative = RelativeToLength and self:CalculateDerivativeRelativeToLength(t) or self:CalculateDerivativeAt(t)
							object[propName] = CFrame.new(position, position + derivative)
						end
					end)
				else
					if numValueChangedConnection then
						numValueChangedConnection:Disconnect()
						numValueChangedConnection = nil
					end
				end
			end
		end)
		return tween
	else
		error("Bezier:CreateCFrameTween() requires a matching property table with CFrame or nil property names for the object as the second argument!")
	end
end


function module.luffyBarrage(Character,Arm) -- Change the variables according to what u need

	local StartPos
	local MidPos
	local EndPos
	local RotVal

	if Arm == "Left" then
		StartPos = CFrame.new(Random.new():NextNumber(-.5,-1), Random.new():NextNumber(-.3, .15), Random.new():NextNumber(0.15, .25))
		MidPos = CFrame.new(Random.new():NextNumber(-1.15, 1), Random.new():NextNumber(-.3, .6), Random.new():NextNumber(-.5, -1.4))
		EndPos = CFrame.new(Random.new():NextNumber(-2, 1), Random.new():NextNumber(-1, .5), Random.new():NextNumber(-3.5, -2.5))
		RotVal = CFrame.new(0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0):Inverse()
	elseif Arm == "Right" then
		StartPos = CFrame.new(Random.new():NextNumber(.5, 1.25),Random.new():NextNumber(.25, -.45),Random.new():NextNumber(0.14, .4))
		MidPos = CFrame.new(Random.new():NextNumber(-1, 1), Random.new():NextNumber(-.8, 1), Random.new():NextNumber(-.75, -1.6))
		EndPos = CFrame.new(Random.new():NextNumber(1.7, -.6), Random.new():NextNumber(-.3, .25), Random.new():NextNumber(-3, -2.5))
		RotVal = CFrame.new(0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0):Inverse()*CFrame.Angles(math.rad(0),math.rad(0),math.rad(180))  --CFrame.new(0, 0, 0, 0, 0, -1, 1, 0, 0, 0, 1, 0):Inverse()--CFrame.new(0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 1, 0)
	end

	local NewArm = script.GomuArms:Clone()
	NewArm.Anchored = false
	NewArm.Color = Color3.new(0.917647, 0.721569, 0.572549) 

	local Weld  = Instance.new("Motor6D")
	Weld.Name = "ArmWeld"
	Weld.Part0 = Character.HumanoidRootPart
	Weld.Part1 = NewArm
	Weld.C0 = StartPos
	Weld.C1 = RotVal
	Weld.Parent = NewArm
	NewArm.Parent = workspace

	local Time = 0.25

	coroutine.wrap(function()
		local sfx = script.Sounds.Swoosh:Clone()
		sfx.Parent = NewArm
		sfx:Play()
	end)

	local Bezier = Bezier.new(StartPos.Position, MidPos.Position, EndPos.Position)
	local Connection
	local SizeConnection

	local armYTargetSize = Random.new():NextNumber(8.5 * .75, 13.25 * .75)

	local Tween = Bezier:CreateCFrameTween(Weld, {"C0"}, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), false)
	Tween:Play()
	local Size = tween_service:Create(NewArm, TweenInfo.new(Time/1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = Vector3.new(2, armYTargetSize, 2)})
	Size:Play()

	task.delay((Time/1.5) * 0.8, function()
		tween_service:Create(NewArm, TweenInfo.new((Time/1.5) * 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = Vector3.new(1, armYTargetSize, 1)}):Play()
	end)


	SizeConnection = Size.Completed:Connect(function()
		tween_service:Create(NewArm, TweenInfo.new(Time/3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = Vector3.new(0, 0, 0)}):Play()
	end) 

	Connection = Tween.Completed:Connect(function()
		NewArm:Destroy()
		Connection:Disconnect()
		SizeConnection:Disconnect()
	end)
	--tw:Create(Weld,TweenInfo.new(i/10),{C0 = CFrame.new(Bezier,Weld.C0 * EndPos)*CFrame.Angles(math.rad(0),math.rad(-90),math.rad(90))}):Play()
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


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Gatling, unit, 1, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		task.wait(.1)
		SoundWrapper:PlaySound(script["GatlingSFX"], rt, Replicated.SoundGroups.UnitSFX)
	end)

	delay(.01,function()
		local arm = "Right"

		for i=1,24 do
			delay(.01,function()
				module.luffyBarrage(unit,arm)
				arm = arm == "Right" and "Left" or "Right"
			end)

			wait(.0001)
		end
	end)

	local par = script.GatlingA:Clone()
	par.CFrame = rt.CFrame * CFrame.new(0,1.5,-8) * CFrame.Angles(math.rad(90),0,0)
	par.Parent = workspace
	debris.AddItem(par,5)
	
	task.spawn(function()
		emit.enablevfx(par,true)
		task.wait(1)
		emit.enablevfx(par,false)
	end)
	
	tween_service:Create(par.PointLight,TweenInfo.new(.35),{Brightness = 1;Range = 15}):Play()
	delay(1.15,function()
		tween_service:Create(par.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()			
	end)

	for i = 1,24 do

		delay(.005,function()
			local model = script.Gun:Clone()
			model:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(math.rad(-3,3),math.random(0,2),math.random(-2,2)) * CFrame.Angles(math.rad(90),0,0))
			model.Parent = workspace.Effects
			debris.AddItem(model,3)

			local rX = math.random(-10,10)
			local rY = math.random(-3,7)

			local start =  model:GetPrimaryPartCFrame()
			local finish = rt.CFrame * CFrame.new(rX,rY,-9)
			local middle = rt.CFrame * CFrame.new(rX,rY,-4.5) * CFrame.new(math.random(-5,5),math.random(0,5),0)


			local step = 15

			for i = 1,step do
				model:SetPrimaryPartCFrame( CFrame.new(quad(start.Position,middle.Position,finish.Position,i/step)))
				model:SetPrimaryPartCFrame(CFrame.lookAt(model:GetPrimaryPartCFrame().Position,finish.Position) * CFrame.Angles(math.rad(90),0,0))  

				game:GetService('RunService').Heartbeat:Wait()
			end

			for i,v in pairs(model:GetChildren()) do
				tween_service:Create(v,TweenInfo.new(.35),{Size = Vector3.new(0,0,0)}):Play()
			end
		end)

		wait(.01)

	end	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
