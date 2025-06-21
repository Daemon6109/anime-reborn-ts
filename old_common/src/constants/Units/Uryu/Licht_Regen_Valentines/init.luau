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
	HitDelay = 1.3, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local anim = AnimModule.PlayAnim(script.Anim2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move2charge"], rt, Replicated.SoundGroups.UnitSFX)

	local a = tween_service:Create(rt,TweenInfo.new(.25,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = rt.CFrame + Vector3.new(0,6,0)}):Play()


	task.wait(.25)
	local Charge = script.Charge:Clone()
	Charge.Position = rt.Position + Vector3.new(0,-1.3,0)
	debris.AddItem(Charge,6)
	Charge.Parent = effectsfolder
	emit.enablevfx(Charge,true)
	emit.emitvfx(Charge.Attachment)

	local a = tween_service:Create(Charge,TweenInfo.new(.75,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Orientation = Charge.Orientation + Charge.Orientation + Vector3.new(0,180,0)}):Play()
	rt.CFrame = CFrame.new(rt.Position, pos.Position)
	Charge.CFrame = CFrame.new(Charge.Position, pos.Position)

	
	task.spawn(function()
		for i=0,7,1 do
			wait(.1)
			emit.bezier(unit.bow.CFrame,ColorSequence.new(Color3.fromRGB(34, 122, 255)),0.0005,1,"Mid",true,5,.7,1.8)
		end
	end)
	
	task.wait(.75)
	emit.enablevfx(Charge,false)
	emit.enablevfx(unit.bow,true)

	SoundWrapper:PlaySound(script["move2shot"], rt, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(unit.Torso,true)
	
	AnimModule.ChangeAnimSpeed(anim,1.35)
	
	spawn(function()
		task.wait(.15)

		for i = 1,7 do
			
			local enemypos = pos.Position + Vector3.new(math.random(-3,3),-1.2,math.random(-3,3))

			task.spawn(function()
				local fronttrail = script.Uptrail:Clone()
				fronttrail.Parent = effectsfolder
				fronttrail.CFrame = unit.bow.CFrame
				debris.AddItem(fronttrail,3.5)
				emit.enablevfx(fronttrail,true)
				
				local info = TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
				local tween = tween_service:Create(fronttrail,info,{Orientation = fronttrail.Orientation + Vector3.new(0,0,360)})
				tween:Play()
				
				task.wait(0.025)

				task.spawn(function()

					local kp = fronttrail.Position

					local magnitude = (kp-enemypos).magnitude
					local Step = 22

					local LookAt = CFrame.new(kp,enemypos)

					local Time = math.random(-15,15)/100
					local Time2 = math.random(-15,15)/100

					for i = 0,Step do
						fronttrail.CFrame = LookAt * CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45  * Time),math.sin(math.rad((i * (180/Step)))) * (15 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end
				end)
			end)
			
			local Arrow = script.arrow:Clone()
			Arrow.Parent = effectsfolder
			Arrow.CFrame = unit.bow.CFrame
			debris.AddItem(Arrow,3.5)
			emit.enablevfx(Arrow,true)

			task.wait(0.025)

			task.spawn(function()

				local kp = Arrow.Position

				local magnitude = (kp-enemypos).magnitude 
				local Step = 20

				local LookAt = CFrame.new(kp,enemypos)

				local Time = math.random(-15,15)/100
				local Time2 = math.random(-15,15)/100

				for i = 0,Step do
					Arrow.CFrame = LookAt * CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45  * Time),math.sin(math.rad((i * (180/Step)))) * (15 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end
					
				local Impact = script["Lichtregen impact"]:Clone()
				Impact.Position = Arrow.Position 
				debris.AddItem(Impact,3)
				Impact.Parent = effectsfolder
				emit.emitvfx(Impact)	
					
				Arrow:Destroy()	

			end)

			task.wait(0.15)
		end
	end)
	task.wait(1.4)
	emit.enablevfx(unit.bow,false)

	emit.enablevfx(unit.Torso,false)
	AnimModule.ChangeAnimSpeed(anim,1)

	local a = tween_service:Create(rt,TweenInfo.new(.45,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame =startpos}):Play()




end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
