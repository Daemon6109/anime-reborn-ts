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
	HitDelay = 2, -- seconds
	HitCount = 14, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .08, -- delay between hits in a multi-hit move
	CustomDelay = {
		[1] = .7,
		[2] = .65,
	},
	EndingDelay = .6,
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
	
	AnimModule.PlayAnim(script.attk1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1"], rt, Replicated.SoundGroups.UnitSFX)
	

	local summonPart = Instance.new("Part")
	summonPart.Anchored = true
	summonPart.Parent = workspace.Effects
	summonPart.CFrame = rt.CFrame
	summonPart.CanTouch = false
	summonPart.CanCollide = false
	summonPart.Transparency = 1
	summonPart.CFrame = rt.CFrame 
	summonPart.CFrame = CFrame.new(summonPart.Position, pos.Position)
	debris.AddItem(summonPart,10)


	local a =  script.attack3:FindFirstChild("a"):Clone()
	a.Parent = workspace.CurrentCamera
	a.jump.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	debris.AddItem(a,7)
	emit.emitvfx(a)

	wait(0.8)


	local shoottween = tween_service:Create(rt,TweenInfo.new(0.5,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = rt.CFrame * CFrame.new(0,6,0)}):Play()

	wait(0.85)

	spawn(function()
		for i = 1,1 do

			local kiblast = script.attack1:FindFirstChild("KiBlast"):Clone()
			kiblast.CFrame = unit.positionn.CFrame
			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,4)

			emit.emitvfx(unit.positionn)


			local rocketpos = kiblast.Position
			local enemypos = pos.Position + Vector3.new(math.random(-5,5),math.random(-1,-1),math.random(-5,5))
			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 22
			local LookAt = CFrame.new(rocketpos,enemypos)
			local Time = math.random(-15,-15)/100
			local Time2 = math.random(-15,-15)/200
			for i = 1,Step do
				kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
				game:GetService("RunService").Heartbeat:Wait()
			end

			local Exp1 = script.attack1:FindFirstChild("Exp1"):Clone()
			Exp1.CFrame = kiblast.CFrame
			Exp1.Parent = effectsfolder
			debris.AddItem(Exp1,4)
			Exp1.Orientation = Vector3.new()
			emit.emitvfx(Exp1)

			emit.enablevfx(kiblast,false)
			kiblast.Transparency = 1


		end
	end)

	wait(0.55)

	spawn(function()
		for i = 1,1 do

			local kiblast = script.attack1:FindFirstChild("KiBlast"):Clone()
			kiblast.CFrame = unit.positionn.CFrame
			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,4)

			emit.emitvfx(unit.positionn)

			local rocketpos = kiblast.Position
			local enemypos = pos.Position + Vector3.new(math.random(-5,5),math.random(-1,-1),math.random(-5,5))
			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 22
			local LookAt = CFrame.new(rocketpos,enemypos)
			local Time = math.random(15,15)/100
			local Time2 = math.random(15,15)/200
			for i = 1,Step do
				kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
				game:GetService("RunService").Heartbeat:Wait()
			end

			local Exp1 = script.attack1:FindFirstChild("Exp1"):Clone()
			Exp1.CFrame = kiblast.CFrame
			Exp1.Parent = effectsfolder
			debris.AddItem(Exp1,4)
			Exp1.Orientation = Vector3.new()
			emit.emitvfx(Exp1)

			emit.enablevfx(kiblast,false)
			kiblast.Transparency = 1

		end
	end)

	wait(0.45)

	spawn(function()
		for i = 1,12 do
			task.wait(.075)
			spawn(function()

				local kiblast = script.attack1:FindFirstChild("KiBlast"):Clone()
				kiblast.CFrame = unit.positionn.CFrame
				kiblast.Parent = effectsfolder
				debris.AddItem(kiblast,4)

				emit.emitvfx(unit.positionn)

				local rocketpos = kiblast.Position
				local enemypos = pos.Position + Vector3.new(math.random(-5,5),math.random(-1,-1),math.random(-5,5))
				local magnitude = (rocketpos-enemypos).magnitude
				local Step = 15
				local LookAt = CFrame.new(rocketpos,enemypos)
				local Time = math.random(-55,55)/100
				local Time2 = math.random(-55,55)/200
				spawn(function()
					for i = 1,Step do
						kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					end

					local blastexp = script.attack1:FindFirstChild("blastexp"):Clone()
					blastexp.CFrame = kiblast.CFrame
					blastexp.Parent = effectsfolder
					debris.AddItem(blastexp,4)
					blastexp.Orientation = Vector3.new()
					emit.emitvfx(blastexp)

					emit.enablevfx(kiblast,false)
					kiblast.Transparency = 1
				end)

			end)
		end

	end)

	wait(2)


	local shoottween = tween_service:Create(rt,TweenInfo.new(0.7,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = summonPart.CFrame}):Play()



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
