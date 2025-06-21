local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.3, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
	CustomDelay = {
		[3] = .85,
	},
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local SavedDirection = rt.CFrame.LookVector	
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	SoundWrapper:PlaySound(script["move2"], rt, Replicated.SoundGroups.UnitSFX)

	local slowdownn = AnimModule.PlayAnim(script.SecondAttack, unit, 1, "", {Weight = 2, Fade = .15})

	local effectsfolder = workspace.Effects
	
	task.wait(0.1)
	
	local function theattack(thepos)
		
		local phone = script.Phone:Clone() 
		phone.Parent = workspace.Effects
		phone.CFrame = thepos
		emit.emitvfx(phone.Emit)
		debris.AddItem(phone,3)

		local TweenComplete = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0),{Orientation = phone.Orientation + Vector3.new(0,110,88)})
		TweenComplete:Play()
		local TweenCompletepo = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position = phone.Position + Vector3.new(0,-.65,0)})
		TweenCompletepo:Play()
				
				
				
		task.wait(.3)	
		local rtclon = unit:WaitForChild("HumanoidRootPart")

		local unitclone = unit:Clone()
		local rtclon = unitclone:WaitForChild("HumanoidRootPart")
		unitclone.Parent = effectsfolder
		rtclon.CFrame = thepos
		debris.AddItem(unitclone,2.5)
		AnimModule.PlayAnim(script.SecondAttack, unitclone, 1, "", {Weight = 2, Fade = .15})
		
		
		for _, part in pairs(unitclone:GetChildren()) do
			if part:IsA("MeshPart") and part.Name ~= "HumanoidRootPart" then
				coroutine.wrap(function()
					if part.Name == "HumanoidRootPart" then
						part.Transparency = 1
					else
						part.Transparency = 0
					end
				end)()
			end
		end
		
		emit.emitvfx(unitclone.Torso)
		
		
		
		rtclon.CFrame = CFrame.lookAt(rtclon.Position, pos.Position)
		
		local SavedDirectionofclone = rtclon.CFrame.LookVector	

		
		local charge = script["Okarun move charge"]:Clone() 
		charge.Parent = workspace.Effects
		charge.Position = rtclon.Position + Vector3.new(0,-1.3,0)
		emit.enablevfx(charge,true)
		debris.AddItem(charge,2.5)

		task.wait(.5)
		emit.enablevfx(charge,false)


		local TweenComplete = tween_service:Create(phone,TweenInfo.new(.45,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Transparency = 1})
		TweenComplete:Play()

		local TweenComplete = tween_service:Create(rtclon,TweenInfo.new(.35,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirectionofclone)})
		TweenComplete:Play()

		local dash = script["A tk2 Dash"]:Clone() 
		dash.Parent = workspace.Effects
		
		local dashb = script["Atk2 Bottom"]:Clone() 
		dashb.Parent = workspace.Effects
		
		dash.CFrame = rtclon.CFrame + (rtclon.CFrame.LookVector * 1.4)
		dashb.CFrame = rtclon.CFrame + (rtclon.CFrame.LookVector * 6)
		dash.Sideparts.CFrame = rtclon.CFrame + (rtclon.CFrame.LookVector * 6) + (rtclon.CFrame.RightVector * 2.5)
		dash.Sideparts2.CFrame = rtclon.CFrame + (rtclon.CFrame.LookVector * 6) + (rtclon.CFrame.RightVector * -2.5)


		emit.emitvfx(dash)
		emit.emitvfx(dashb)

		debris.AddItem(dash,3)
		debris.AddItem(dashb,3)
		
		task.wait(.15)
		
		emit.emitbeam(dash.beamemits,.3,0.5,.35)
		
		
		task.wait(.25)
		
		phone.CFrame = rtclon.CFrame
		task.wait(0.1)
		emit.emitvfx(phone)
		unitclone:Destroy()
		

	end
	
	task.spawn(function()
		theattack(CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.RightVector * 15))

	end)
	task.spawn(function()
		theattack(CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.RightVector * -15))

	end)
	task.spawn(function()
		theattack(CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 15))

	end)
	
	
	emit.emitvfx(unit.Torso)
	
	for _, part in pairs(unit.okarunb:GetChildren()) do
		if part:IsA("Part") or part:IsA("MeshPart") then
			coroutine.wrap(function()
				if part.Name == "HumanoidRootPart" then
					part.Transparency = 1
				else
					part.Transparency = 1
				end
			end)()
		end
	end
	
	task.wait(.85)
	
	local impact1 = script["Atk2 Impact"]:Clone() 
	impact1.Parent = workspace.Effects	
	impact1.Position = pos.Position + Vector3.new(0,-.5,0)
	emit.emitvfx(impact1)
	debris.AddItem(impact1,2)
	
	local phone = script.Phone:Clone() 
	phone.Parent = workspace.Effects
	phone.CFrame = pos.CFrame + Vector3.new(0,12,0)
	emit.emitvfx(phone.Emit)
	debris.AddItem(phone,3)
	
	local TweenComplete = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0),{Orientation = phone.Orientation + Vector3.new(0,110,88)})
	TweenComplete:Play()
	local TweenCompletepo = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position = phone.Position + Vector3.new(0,-.65,0)})
	TweenCompletepo:Play()
	AnimModule.ChangeAnimSpeed(slowdownn,0.7)

	task.wait(.4)
	
	AnimModule.ChangeAnimSpeed(slowdownn,1)

	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,12,0)
	task.wait(0.05)
	unit.Torso.tp:Emit(15)
	emit.emitvfx(phone.Tp)
	
	for _, part in pairs(unit.okarunb:GetChildren()) do
		if part:IsA("Part") or part:IsA("MeshPart") then
			coroutine.wrap(function()
				if part.Name == "HumanoidRootPart" then
					part.Transparency = 1
				else
					part.Transparency = 0
				end
			end)()
		end
	end
	
	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = rt.CFrame + Vector3.new(0,-12.3,0)})
	TweenCompletepo:Play()
	
	local downspiral = script.Okarunpartdashfront:Clone() 
	downspiral.Parent = workspace.Effects
	downspiral.Position = rt.Position + Vector3.new(0,-1,0)
	emit.enablevfx(downspiral,true)
	debris.AddItem(downspiral,3)
	
	local TweenCompletepo = tween_service:Create(downspiral,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position = rt.Position + Vector3.new(0,-13,0)})
	TweenCompletepo:Play()
	local TweenComplete = tween_service:Create(phone,TweenInfo.new(.45,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Transparency = 1})
	TweenComplete:Play()
	task.wait(.4)

	local impact2 = script["Atk2 ImpactDropkick"]:Clone() 
	impact2.Parent = workspace.Effects	
	impact2.Position = pos.Position + Vector3.new(0,-.5,0)
	emit.emitvfx(impact2)
	debris.AddItem(impact2,3)
	
	local impact3 = script["Atk2bottomDropkick"]:Clone() 
	impact3.Parent = workspace.Effects	
	impact3.Position = pos.Position + Vector3.new(0,-1,0)
	emit.emitvfx(impact3)
	debris.AddItem(impact3,3)
	
	emit.enablevfx(downspiral,false)
	
	
	local trailpartup = script.uptrailatk2:Clone()
	trailpartup.Parent = effectsfolder
	trailpartup.Position = pos.Position + Vector3.new(0,0,0)		
	local info = TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local tween = tween_service:Create(trailpartup,info,{Orientation = trailpartup.Orientation + Vector3.new(0,300,0)})
	tween:Play()
	local info = TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local tween = tween_service:Create(trailpartup,info,{Position = trailpartup.Position + Vector3.new(0,8,0)})
	tween:Play()
	
	--rocksmodule.Ground(pos.Position + Vector3.new(0,1.5,0),16, Vector3.new(1.1, 1.1, 1.1), nil, 25, false, 1.1) -- ground crack module
	
	task.wait(.5)
	emit.trailonoff(trailpartup,false)

	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	emit.emitvfx(unit.Torso)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
