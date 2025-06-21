local emit = {}

local tween_service = game:GetService("TweenService")


function emit.emitvfx(part)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("ParticleEmitter") then
				local emitCount = v:GetAttribute("EmitCount")
				local emitDelay = v:GetAttribute("EmitDelay")
				local EmitDuration = v:GetAttribute("EmitDuration")

				task.wait(emitDelay)
				

				v:Emit(emitCount)
				
				if EmitDuration ~= nil then
					v.Enabled = true
					task.wait(EmitDuration)
					v.Enabled = false
					
				end
				
			
			end
		end)	
	end	
end

function emit.enablevfx(part,yes)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("ParticleEmitter") then
				v.Enabled = yes
			elseif v:IsA("Beam") then
				v.Enabled = yes
			elseif v:IsA("Trail") then
				v.Enabled = yes
			elseif v:IsA("PointLight") then
				v.Enabled = yes
			end
		end)	
	end	
end

function emit.trailonoff(part,yes)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("Trail") then
				v.Enabled = yes
			end	
		end)	
	end	
end

function emit.emitbeam(part,time1,midtiem,time2)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("Beam") then
				v.Enabled = true
				
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1
				

				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(time1,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(time1,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()
				
				task.wait(midtiem)
				
				
				local TweenComplete = tween_service:Create(v,TweenInfo.new(time2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(time2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Width1 = 0})
				TweenComplete:Play()
				
			end
		end)	
	end	
end

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end


function emit.bezier(PointA,Colorcode,Waittime,Speedmultiplier,ShortorLong,changeemission,brightnesss,lightem,DistanceMultiplier) 
	
	local function move(part)	
		if changeemission == true then
			part:FindFirstChild("1").ja.Brightness = brightnesss
			part:FindFirstChild("1").ja.LightEmission = lightem
		end
		
		
		if DistanceMultiplier == nil then
			
			local PointB = PointA + Vector3.new(math.random(-2,2),math.random(-2,2),math.random(-2,2))
			local PointC = PointA + Vector3.new(math.random(-4,4),math.random(-4,4),math.random(-4,4))
			
			task.spawn(function()
				if Speedmultiplier == nil then
					for i=0,1,.1 do
						part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))

						wait(Waittime)
					end
				else
					for i=0,1,.1 do
						part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))
						wait((Waittime * Speedmultiplier))
					end
				end

			end)
		else
			local anwser = math.random((-2 * DistanceMultiplier),(2 * DistanceMultiplier))
			local anwser1 = math.random((-2 * DistanceMultiplier),(2 * DistanceMultiplier))
			local anwser2 = math.random((-2 * DistanceMultiplier),(2 * DistanceMultiplier))

			local PointB = PointA + Vector3.new(anwser,anwser1,anwser2)

			local anwser3 = math.random((-4 * DistanceMultiplier),(4 * DistanceMultiplier))
			local anwser4 = math.random((-4 * DistanceMultiplier),(4 * DistanceMultiplier))
			local anwser5 = math.random((-4 * DistanceMultiplier),(4 * DistanceMultiplier))
			local PointC = PointA + Vector3.new(anwser3,anwser4,anwser5)

			task.spawn(function()
				for i=0,1,.1 do
					part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))
					wait((Waittime * Speedmultiplier))
				end
			end)
		end
	end
	
	if ShortorLong == nil then
		local part = script:FindFirstChild("Long"):Clone()
		part.Parent = workspace.Camera
		move(part)
		
		for i, v in pairs(part:GetDescendants()) do
			task.spawn(function()
				if v:IsA("Trail") then
					v.Color = Colorcode
					if Speedmultiplier == nil then
						v.Lifetime = v.Lifetime
					else
						v.Lifetime = Speedmultiplier / 100 + 0.15 
					end
				
				end	
			end)	
		end	
		task.spawn(function()
			task.wait(2.5)
			part:Destroy()
		end)
	else
		local part = script:FindFirstChild(ShortorLong):Clone()
		part.Parent = workspace.Camera
		move(part)
		for i, v in pairs(part:GetDescendants()) do
			task.spawn(function()
				if v:IsA("Trail") then
					v.Color = Colorcode
					
					if Speedmultiplier ~= nil then
						v.Lifetime = v.Lifetime
					else
						v.Lifetime = Speedmultiplier / 100 + 0.15 
					end
					
				
				end	
			
			end)	
		end	
		task.spawn(function()
			task.wait(2.5)
			part:Destroy()
		end)
	end
end


function emit.Rain(PointA,Colorcode,Waittime,Speedmultiplier,ShortorLong,changeemission,brightnesss,lightem,DistanceMultiplier,Top1,Top2,Top3,Top4,pluslifetime) 

	local function move(part)	
		if changeemission == true then
			part:FindFirstChild("1").ja.Brightness = brightnesss
			part:FindFirstChild("1").ja.LightEmission = lightem
		end


		if DistanceMultiplier == nil then
						
			local PointC = PointA + Vector3.new(math.random(-4,4),math.random(Top1,Top2),math.random(-4,4))
			local PointB = PointA + Vector3.new(math.random(-2,2),math.random(-2,2),math.random(-2,2))

			task.spawn(function()
				if Speedmultiplier == nil then
					for i=0,1,.1 do
						part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))

						wait(Waittime)
					end
				else
					for i=0,1,.1 do
						part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))
						wait((Waittime * Speedmultiplier))
					end
				end

			end)
		else
			local anwser = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))
			local anwser1 = math.random((Top1 * DistanceMultiplier),(Top2 * DistanceMultiplier))
			local anwser2 = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))

			local PointB = PointA + Vector3.new(anwser,anwser1,anwser2)

			local anwser3 = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))
			local anwser4 = math.random((Top3 * DistanceMultiplier),(Top4 * DistanceMultiplier))
			local anwser5 = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))
			local PointC = PointA + Vector3.new(anwser3,anwser4,anwser5)

			task.spawn(function()
				for i=0,1,.1 do
					part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))
					wait((Waittime * Speedmultiplier))
				end
			end)
		end
	end

	if ShortorLong == nil then
		local part = script:FindFirstChild("Long"):Clone()
		part.Parent = workspace.Camera
		move(part)

		for i, v in pairs(part:GetDescendants()) do
			task.spawn(function()
				if v:IsA("Trail") then
					v.Color = Colorcode
					v.Lifetime = Speedmultiplier / 100 + 0.15 + pluslifetime
				end	
			end)	
		end	
		task.spawn(function()
			task.wait(2.5)
			part:Destroy()
		end)
	else
		local part = script:FindFirstChild(ShortorLong):Clone()
		part.Parent = workspace.Camera
		move(part)
		for i, v in pairs(part:GetDescendants()) do
			task.spawn(function()
				if v:IsA("Trail") then
					v.Color = Colorcode
					v.Lifetime = Speedmultiplier / 100 + 0.15 + pluslifetime
				end	
			end)	
		end	
		task.spawn(function()
			task.wait(2.5)
			part:Destroy()
		end)
	end
end
function emit.Scatter(PointA,Colorcode,Waittime,Speedmultiplier,ShortorLong,changeemission,brightnesss,lightem,DistanceMultiplier,Top1,Top2,Top3,Top4,pluslifetime,abctime) 

	local function move(part)	
		if changeemission == true then
			for i, v in pairs(part:GetDescendants()) do
				task.spawn(function()
					if v:IsA("Trail") then
						v.Brightness = brightnesss
						v.LightEmission = lightem
					end	
				end)	
			end	
		end


		if DistanceMultiplier == nil then

			local PointC = PointA + Vector3.new(math.random(-4,4),math.random(Top1,Top2),math.random(-4,4))
			local PointB = PointA + Vector3.new(math.random(-2,2),math.random(-2,2),math.random(-2,2))

			task.spawn(function()
				if Speedmultiplier == nil then
					for i=0,1,.1 do
						part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))

						wait(Waittime)
					end
				else
					for i=0,1,.1 do
						part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))
						wait((Waittime * Speedmultiplier))
					end
				end

			end)
		else
			local anwser = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))
			local anwser1 = math.random(Top1,Top2)
			local anwser2 = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))

			local PointB = PointA + Vector3.new(anwser,anwser1,anwser2)

			local anwser3 = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))
			local anwser4 = math.random(Top3,Top4)
			local anwser5 = math.random((-5 * DistanceMultiplier),(5 * DistanceMultiplier))
			local PointC = PointA + Vector3.new(anwser3,anwser4,anwser5)

			task.spawn(function()
				for i=0,1,abctime do
					if i >= .9 then
						for i, v in pairs(part:GetDescendants()) do
							task.spawn(function()
								if v:IsA("Trail") then
									v.Enabled = false
								end	
							end)	
						end	
					end
					part.CFrame = CFrame.new(Bezier(i,PointA.Position,PointB.Position,PointC.Position))
					wait((Waittime * Speedmultiplier))
				end
				task.spawn(function()
					task.wait(2.5)
					part:Destroy()
				end)
			end) 
		end
	end

	if ShortorLong == nil then
		local part = script:FindFirstChild("Long"):Clone()
		part.Parent = workspace.Camera
		move(part)

		for i, v in pairs(part:GetDescendants()) do
			task.spawn(function()
				if v:IsA("Trail") then
					v.Color = Colorcode
					v.Lifetime = Speedmultiplier / 100 + 0.15 + pluslifetime
				end	
			end)	
		end	
		task.spawn(function()
			task.wait(2.5)
			part:Destroy()
		end)
	else
		local part = script:FindFirstChild(ShortorLong):Clone()
		part.Parent = workspace.Camera
		for i, v in pairs(part:GetDescendants()) do
			task.spawn(function()
				if v:IsA("Trail") then
					v.Color = Colorcode
					v.Lifetime = Speedmultiplier / 100 + 0.15 + pluslifetime
				end	
			end)	
		end	
		move(part)
		task.spawn(function()
			task.wait(2.5)
			part:Destroy()
		end)

	end
end
function emit.Trailgoup(trailpart,rotationspeed,endposit,timee,repeatcount)
	
	local info = TweenInfo.new(timee,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local tween = tween_service:Create(trailpart,info,{Position = endposit})
	tween:Play()
	local info = TweenInfo.new(rotationspeed,Enum.EasingStyle.Linear,Enum.EasingDirection.In,repeatcount)
	local tween = tween_service:Create(trailpart,info,{Orientation = trailpart.Orientation + Vector3.new(0,180,0)})
	tween:Play()
	task.wait(timee + .6)
	trailpart:Destroy()
	
end


return emit

