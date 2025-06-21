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
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	local TargetPos = pos.Position
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.4, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1SFX"], rt, Replicated.SoundGroups.UnitSFX, {PlaybackSpeed = 1.4})


	local ar = script.Move1:FindFirstChild("air"):Clone()
	ar.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	ar.Orientation = Vector3.new()
	ar.Parent = effectsfolder
	debris.AddItem(ar,6)

	local Dash = script.Move1:FindFirstChild("Dash"):Clone()
	Dash.CFrame = rt.CFrame * CFrame.new(0,5,0)
	Dash.Parent = effectsfolder
	debris.AddItem(ar,6)

	emit.emitvfx(Dash)
	emit.emitvfx(ar)

	Dash.CFrame = CFrame.new(Dash.Position, pos.Position)

	task.wait(1.2)

	for i = 1,4 do
		local kiblast = script.Move1:FindFirstChild("Kiblast"):Clone()
		kiblast.CFrame = rt.CFrame * CFrame.new(0,5,0)
		kiblast.Parent = effectsfolder
		debris.AddItem(kiblast,4)


		local rocketpos = kiblast.Position
		local enemypos = TargetPos + Vector3.new(math.random(-3,3),math.random(0,0),math.random(-3,3))
		local magnitude = (rocketpos-enemypos).magnitude
		local Step = 17
		local LookAt = CFrame.new(rocketpos,enemypos)
		local Time = math.random(-35,35)/100
		local Time2 = math.random(-35,35)/200
		task.spawn(function()
			for i = 1,Step do
				kiblast.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
				game:GetService("RunService").Heartbeat:Wait()
			end

			emit.enablevfx(kiblast,false)
			kiblast.Orientation = Vector3.new()
			kiblast.Transparency = 1

			local ExplosionImpact12 = script.Move1:FindFirstChild("ExplosionImpact12"):Clone()
			ExplosionImpact12.CFrame = kiblast.CFrame * CFrame.new(0,-1,0)
			ExplosionImpact12.Parent = effectsfolder
			ExplosionImpact12.Orientation = Vector3.new()

			debris.AddItem(ExplosionImpact12,4)

			emit.emitvfx(ExplosionImpact12)

			local a = tween_service:Create(ExplosionImpact12.PointLight,TweenInfo.new(.1,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 10}):Play()


			spawn(function()
				task.wait(0.35)


				local a = tween_service:Create(ExplosionImpact12.PointLight,TweenInfo.new(.5,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 0}):Play()

			end)


		end)
		task.wait(0.15)
	end



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
