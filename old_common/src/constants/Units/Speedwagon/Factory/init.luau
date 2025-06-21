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
	HitDelay = .6, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end
local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	if unit:HasTag("Building") then
		repeat task.wait() until not unit:HasTag("Building")
	end

	unit:AddTag("Building")
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	task.delay(3, function()
		rt.CFrame = startpos
		--rt.CFrame = CFrame.lookAt(rt.Position,rt.Position + (rt.CFrame.RightVector * 5))
		unit:RemoveTag("Building")
	end)
	
	SoundWrapper:PlaySound(script["Buildingdissapear"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	local oldbuilding = unit:FindFirstChild("FirstBuilding")
	print(oldbuilding)
	
	
	
	local bottompart = script.BottompartDissapear:Clone()
	bottompart.Parent = unit
	
	bottompart.Position = oldbuilding.PrimaryPart.Position + Vector3.new(0,-1.3,0)
	
	emit.enablevfx(bottompart,true)
	task.wait(.1)
	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(oldbuilding.PrimaryPart,info,{CFrame = oldbuilding.PrimaryPart.CFrame + Vector3.new(0,-3,0)}) -- making the building go down
	tween:Play()

	task.wait(1.15)
	emit.enablevfx(bottompart,false)
	task.wait(.25)
	oldbuilding:Destroy()
	SoundWrapper:PlaySound(script["Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.spawn(function()
		--local anim2 = AnimModule.PlayAnim(script.Buildinganimation, unit, 1, "", {Weight = 2, Fade = .15})
		local anim3 = humanoid:LoadAnimation(AnimModule.GetAnim(script.Buildinganimation))
		anim3:Play()

		task.wait(1.4)
		--AnimModule.StopAnim(unit,anim2)
		

		anim3:Stop()
	end)
		
	unit.Hammer.Out.Transparency = 0
	unit.Hammer.Part.Transparency = 0
	local mainpart = script.Building:Clone()
	local buildingpart = mainpart.BuildingPart
	mainpart.Parent = unit	
	mainpart.PrimaryPart.CFrame = (rt.CFrame + (rt.CFrame.RightVector * -4) + Vector3.new(0,-2.8,0)) *  CFrame.Angles(0,0,0)
	mainpart.Caution.CFrame = (rt.CFrame + (rt.CFrame.RightVector * -4) + Vector3.new(0,-0.4,0)) *  CFrame.Angles(0,0,0)
	local POSPOS = buildingpart.CFrame	

	local smokepart = script.Smokepart:Clone()
	smokepart.Parent = unit
	smokepart.CFrame = POSPOS
	emit.enablevfx(smokepart,true)

	local bottompart = script.Bottompart:Clone()
	bottompart.Parent = unit
	bottompart.CFrame = POSPOS + Vector3.new(0,1.5,0)
	emit.enablevfx(bottompart,true)

	emit.enablevfx(mainpart.Caution,true)

	mainpart["Finish(Building)"].CFrame =rt.CFrame + (rt.CFrame.RightVector * -4) + Vector3.new(0,-1.4,0)

	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(buildingpart,info,{Position = buildingpart.Position + Vector3.new(0,4.5,0)}) -- making the unit go to the pos + -0.5 studs down
	tween:Play()

	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(smokepart,info,{Position = smokepart.Position + Vector3.new(0,5,0)}) -- making the unit go to the pos + -0.5 studs down
	tween:Play()


	for i, v in pairs(mainpart.Caution:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1

				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				task.wait(1.2)


				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0}) --tweens for the beams to dissapear smoothly
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()

			end
		end)
	end	


	task.spawn(function()
		for i=0,5,1 do
			local parts = {mainpart.Area1, mainpart.Area2, mainpart.Area3,mainpart.Area4}
			local var = parts[math.random(#parts)]

			local Part = var		
			rt.CFrame = var.CFrame * CFrame.new(math.random(-Part.Size.X/2, Part.Size.X/2),3.5,math.random(-Part.Size.Z/2, Part.Size.Z/2))
			rt.CFrame = CFrame.lookAt(rt.Position, POSPOS.Position + Vector3.new(0,2,0))
			task.wait(.2)

		end
	

		rt.CFrame = startpos
		--rt.CFrame = CFrame.lookAt(rt.Position,rt.Position + (rt.CFrame.RightVector * 5) )
		local Emit = script["Finish(Unit)"]:Clone()
		Emit.Parent = unit
		Emit.Position = rt.Position + Vector3.new(0,-.75,0)
		emit.emitvfx(Emit)
		
		mainpart.Parent = unit

		unit.Hammer.Out.Transparency = 1
		unit.Hammer.Part.Transparency = 1

	end)


	task.wait(1.4)
	
	local highlight = Instance.new("Highlight")
	highlight.Parent = mainpart
	highlight.FillColor = Color3.fromRGB(235, 210, 150)
	highlight.FillTransparency = 0.9
	highlight.OutlineColor = Color3.fromRGB(235, 210, 150)
	highlight.OutlineTransparency = 0
	highlight.Enabled = true
	
	local info = TweenInfo.new(.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(mainpart.Highlight,info,{FillTransparency = .1}) -- making the part flash orange
	tween:Play()
	task.wait(.1)
	local info = TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(mainpart.Highlight,info,{FillTransparency = 1}) -- making the part flash orange
	tween:Play()
	task.wait(.24)
	highlight:Destroy()


	emit.enablevfx(bottompart,false)
	emit.enablevfx(smokepart,false)
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
