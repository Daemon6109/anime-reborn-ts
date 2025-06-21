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
	HitDelay = 1, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .22, -- delay between hits in a multi-hit move
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
	local back = unit.back

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["mov2"], rt, Replicated.SoundGroups.UnitSFX)
	

	local move1 = script.Move2:FindFirstChild("move1"):Clone()
	move1.Parent = effectsfolder
	debris.AddItem(move1,5)
	move1.jump.CFrame = rt.CFrame * CFrame.new( 0 , -1.25 , 0 )


	emit.emitvfx(move1)


	wait(0.18)

	unit.sword.Weapon01.Transparency = 0
	unit.sword.Weapon02.Transparency = 0
	unit.sword.Weapon03.Transparency = 0


	wait(1.22)
	
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

	debris.AddItem(Highlight, .7)
	debris.AddItem(CoatHighlight, .7)

	Highlight.Enabled = true

	local shoottween = tween_service:Create(Highlight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{FillTransparency = 0}):Play()

	wait(0.05)

	for i ,v in ipairs(unit.Neon1:GetDescendants()) do
		if v.Name == "a" then
			tween_service:Create(v,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency = 0}):Play()
		end
	end

	emit.enablevfx(unit.Torso.aura,true)


	emit.emitvfx(unit.Emit)


	tween_service:Create(CoatHighlight,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FillTransparency = 0}):Play()

	spawn(function()

		for i = 1,8 do
			local kiblast = script.Move2:FindFirstChild("Kiblast"):Clone()
			kiblast.CFrame = rt.CFrame * CFrame.new(math.random(-1,1),math.random(-1,1),math.random(-7,-6))

			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,2)

			local rocketpos = kiblast.Position
			local enemypos = back.Position + Vector3.new(math.random(-0.5,0.5),math.random(-1,1),math.random(-0.5,0.5))

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

	Highlight.Enabled = true

	local shoottween = tween_service:Create(Highlight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{FillTransparency = 0}):Play()

	unit.sword.Weapon01.Transparency = 1
	unit.sword.Weapon02.Transparency = 1
	unit.sword.Weapon03.Transparency = 1

	wait(0.2)

	tween_service:Create(CoatHighlight,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FillTransparency = 1}):Play()

	for i ,v in ipairs(unit.Neon1:GetDescendants()) do
		if v.Name == "a" then
			tween_service:Create(v,TweenInfo.new(.175,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency = 1}):Play()
		end
	end

	Highlight.Enabled = false



	emit.enablevfx(unit.Torso.aura,false)


	emit.emitvfx(unit.Emit)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
