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
	HitDelay = 1.75, -- seconds
	HitCount = 13, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .13, -- delay between hits in a multi-hit move
	EndingDelay = .5
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local back = unit.back
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.6, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move3"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	local Highlight = Instance.new("Highlight")
	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 1
	Highlight.OutlineColor = Color3.new(1,1,1)
	Highlight.FillColor = Color3.fromRGB(255,247,155)

	local CoatHighlight = Instance.new("Highlight")
	CoatHighlight.FillTransparency = 1
	CoatHighlight.OutlineTransparency = 1
	CoatHighlight.OutlineColor = Color3.new(1,1,1)
	CoatHighlight.FillColor = Color3.fromRGB(255,234,152)

	Highlight.Parent = unit
	CoatHighlight.Parent = unit.Coat

	debris.AddItem(Highlight, 2)
	debris.AddItem(CoatHighlight, 2)
	
	wait(0.07)

	Highlight.Enabled = true

	local shoottween = tween_service:Create(Highlight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{FillTransparency = 0}):Play()

	wait(0.2)

	for i ,v in ipairs(unit.Neon1:GetDescendants()) do
		if v.Name == "a" then
			tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency = 0}):Play()
		end
	end

	emit.enablevfx(unit.Torso.aura,true)


	emit.emitvfx(unit.Emit)


	tween_service:Create(CoatHighlight,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FillTransparency = 0}):Play()

	spawn(function()

		for i = 1,5 do
			local kiblast = script.Move3:FindFirstChild("Kiblast"):Clone()
			kiblast.CFrame = back.CFrame * CFrame.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))

			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,2)

			local rocketpos = kiblast.Position
			local enemypos = back.Position + Vector3.new(math.random(-0.05,0.5),math.random(7,9),math.random(-0.5,0.5))

			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 15

			local LookAt = CFrame.new(rocketpos,enemypos)

			local Time = math.random(-15,15)/100
			local Time2 = math.random(35,35)/200
			spawn(function()

				for i = 1,Step do
					kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end



				kiblast.Specs2.Enabled = false

			end)


			task.wait(0.02)

		end
	end)


	wait(0.17)


	tween_service:Create(CoatHighlight,TweenInfo.new(.22,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FillTransparency = 1}):Play()

	for i ,v in ipairs(unit.Neon1:GetDescendants()) do
		if v.Name == "a" then
			tween_service:Create(v,TweenInfo.new(.22,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0),{Transparency = 1}):Play()
		end
	end

	emit.enablevfx(unit.Torso.aura,false)

	rt.CFrame = rt.CFrame * CFrame.new(0,8,0)

	emit.emitvfx(unit.Emit)

	wait(0.2)


	Highlight.Enabled = false


	emit.enablevfx(unit["Left Arm"].aura,true)

	emit.enablevfx(unit["Right Arm"].aura,true)


	wait(0.15)

	emit.enablevfx(unit["Left Arm"].aura,false)

	emit.enablevfx(unit["Right Arm"].aura,false)


	emit.enablevfx(unit["Left Arm"].aura1,true)

	emit.enablevfx(unit["Right Arm"].aura1,true)


	spawn(function()

		for i = 1,11 do

			spawn(function()

				local Part = Instance.new("Part")
				Part.CFrame = pos.CFrame * CFrame.new(math.random(-7,7),math.random(-1,-1),math.random(-7,7))
				Part.Transparency = 1
				Part.CanCollide = false
				Part.Size = Vector3.new()
				Part.Parent = effectsfolder

				local a = script.Move3:FindFirstChild("A"):Clone()
				a.CFrame = unit["Left Arm"].partcframe1.CFrame
				a.CFrame = CFrame.new(a.Position, Part.Position)
				a.Parent = effectsfolder
				debris.AddItem(a,2)

				local light1 = script.Move3:FindFirstChild("light1"):Clone()
				light1.CFrame = Part.CFrame
				light1.Orientation = Vector3.new()
				light1.Parent = effectsfolder
				debris.AddItem(light1,2.5)

				task.wait(0.0175)

				emit.emitvfx(a)

				task.wait(0.05)

				emit.emitvfx(light1)





			end)

			task.wait(0.1)
		end
	end)

	wait(0.075)

	spawn(function()

		for i = 1,11 do
			spawn(function()

				local Part = Instance.new("Part")
				Part.CFrame = pos.CFrame * CFrame.new(math.random(-4.5,4.5),math.random(-1,-1),math.random(-4.5,4.5))
				Part.Transparency = 1
				Part.CanCollide = false
				Part.Size = Vector3.new()
				Part.Parent = effectsfolder

				local a = script.Move3:FindFirstChild("A"):Clone()
				a.CFrame = unit["Right Arm"].partcframe1.CFrame
				a.CFrame = CFrame.new(a.Position, Part.Position)
				a.Parent = effectsfolder
				debris.AddItem(a,2)

				local light1 = script.Move3:FindFirstChild("light1"):Clone()
				light1.CFrame = Part.CFrame
				light1.Orientation = Vector3.new()
				light1.Parent = effectsfolder
				debris.AddItem(light1,2.5)

				task.wait(0.0175)

				emit.emitvfx(a)

				task.wait(0.05)

				emit.emitvfx(light1)

			end)



			task.wait(0.1)
		end
	end)


	wait(1.15)



	emit.enablevfx(unit["Left Arm"].aura1,false)

	emit.enablevfx(unit["Right Arm"].aura1,false)

	Highlight.Enabled = true

	local shoottween = tween_service:Create(Highlight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{FillTransparency = 0}):Play()



	tween_service:Create(CoatHighlight,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FillTransparency = 0}):Play()

	spawn(function()

		for i = 1,7 do
			local kiblast = script.Move3:FindFirstChild("Kiblast"):Clone()
			kiblast.CFrame = back.CFrame * CFrame.new(math.random(-1,1),math.random(7,9),math.random(-1,1))

			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,2)

			local rocketpos = kiblast.Position
			local enemypos = back.Position + Vector3.new(math.random(-0.05,0.5),math.random(-1,1),math.random(-0.5,0.5))

			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 15

			local LookAt = CFrame.new(rocketpos,enemypos)

			local Time = math.random(-15,15)/100
			local Time2 = math.random(35,35)/200
			spawn(function()

				for i = 1,Step do
					kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end
				kiblast.Specs2.Enabled = false
			end)


			task.wait(0.02)

		end

	end)


	emit.enablevfx(unit.Torso.aura,true)

	emit.enablevfx(unit.Torso.emit)

	wait(0.1)


	tween_service:Create(CoatHighlight,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FillTransparency = 1}):Play()

	for i ,v in ipairs(unit.Neon1:GetDescendants()) do
		if v.Name == "a" then
			tween_service:Create(v,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out,0.5),{Transparency = 1}):Play()
		end
	end

	emit.enablevfx(unit.Torso.aura,false)

	emit.emitvfx(unit.Emit)

	rt.CFrame = back.CFrame

	Highlight.Enabled = true

	local shoottween = tween_service:Create(Highlight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{FillTransparency = 1}):Play()

	wait(0.1)


	Highlight.Enabled = false
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
