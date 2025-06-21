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
	HitDelay = 1.5, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
	
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	local startpos = rt.CFrame
	local SavedDirection = rt.CFrame.LookVector
	
	SoundWrapper:PlaySound(script["move3"], rt, Replicated.SoundGroups.UnitSFX)

	
	local phone = script.Phone:Clone() 
	phone.Parent = workspace.Effects
	phone.CFrame = rt.CFrame + Vector3.new(0,10,0)
	emit.emitvfx(phone.Emit)
	debris.AddItem(phone,3)

	local TweenComplete = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0),{Orientation = phone.Orientation + Vector3.new(0,110,88)})
	TweenComplete:Play()
	local TweenCompletepo = tween_service:Create(phone,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Position = phone.Position + Vector3.new(0,-.65,0)})
	TweenCompletepo:Play()
	
	task.wait(.25)
	
	AnimModule.PlayAnim(script.ThirdAttack, unit, .96, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		for i=0,5,1 do
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.00000000005,.5,"Mid",false,5,.5,1.6)

			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 23, 27)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			task.wait(.014)
		end
	end)
	
	task.wait(.1)

																				
	rt.CFrame = rt.CFrame + Vector3.new(0,6,0)
	task.wait(0.05)
	unit.Torso.tp:Emit(15)
	emit.emitvfx(phone.Tp)

	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = rt.CFrame + Vector3.new(0,-6,0)})
	TweenCompletepo:Play()

	local TweenComplete = tween_service:Create(phone,TweenInfo.new(.45,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Transparency = 1})
	TweenComplete:Play()
	
	task.wait(.3)
	
	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.2)
	
	
	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)})
	TweenCompletepo:Play()

	

	local dash = script["Dashafterland"]:Clone() 
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.4)
	emit.emitvfx(dash)
	debris.AddItem(dash,3)
	emit.emitbeam(dash.beamemits,.3,0.5,.35)
	

	dash.Sideparts.CFrame = rt.CFrame + (rt.CFrame.LookVector * 6) + (rt.CFrame.RightVector * 2.5)
	dash.Sideparts2.CFrame = rt.CFrame + (rt.CFrame.LookVector * 6) + (rt.CFrame.RightVector * -2.5)


	emit.emitvfx(dash)

	debris.AddItem(dash,3)

	
	task.wait(.25)
	
	

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
	
	local Barrage = script["TpsBarrage"]:Clone() 
	Barrage.Parent = workspace.Effects	
	Barrage.Position = pos.Position + Vector3.new(0,1.5,0)
	emit.emitvfx(Barrage)
	debris.AddItem(Barrage,3)
	emit.enablevfx(Barrage,true)


	local Barrage2 = script["Mainpartbarrage"]:Clone() 
	Barrage2.Parent = workspace.Effects	
	Barrage2.Position = pos.Position + Vector3.new(0,1.5,0)
	emit.emitvfx(Barrage2)
	debris.AddItem(Barrage2,3)
	emit.enablevfx(Barrage2,true)

	


	task.wait(1.15)
	
	emit.enablevfx(Barrage,false)
	emit.enablevfx(Barrage2,false)
	emit.emitvfx(Barrage)
	emit.emitvfx(Barrage2)

	
	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	emit.emitvfx(unit.Torso)

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


	
	


	task.wait(2)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
