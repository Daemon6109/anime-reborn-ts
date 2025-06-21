local emit = {}

local tween_service = game:GetService("TweenService")


function emit.emitvfx(part)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("ParticleEmitter") then
				local emitCount = v:GetAttribute("EmitCount")
				v:Emit(emitCount)
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

function emit.emitbeam(part,time1,midtiem,time2)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("Beam") then
				print(v)
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


function emit.bezier(PointA,Colorcode,Waittime) 

	local part = script.traill:Clone()
	part.Parent = workspace.Camera
	part:FindFirstChild("1").ja.Color = Colorcode


	local PointB = PointA + Vector3.new(math.random(-2,2),math.random(-2,2),math.random(-2,2))
	local PointC = PointA + Vector3.new(math.random(-4,4),math.random(-4,4),math.random(-4,4))



	task.spawn(function()
		for i=0,1,.1 do
			part.CFrame = CFrame.new(Bezier(i,PointC.Position,PointB.Position,PointA.Position))
			wait(Waittime)
			--wait(0.0000000005)
		end
	end)	
end


return emit
