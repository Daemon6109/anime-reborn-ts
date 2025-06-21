local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Atk1"], rt, Replicated.SoundGroups.UnitSFX)


	local disparo = script:FindFirstChild("disparo"):Clone()
	disparo.CFrame = rt.CFrame * CFrame.new(0.3,0,-1)
	disparo.Parent = workspace.Effects
	debris.AddItem(disparo,5)

	local fr = script:FindFirstChild("FireBall"):Clone()
	fr.CFrame = unit["Right Arm"].Part1.CFrame
	fr.Parent = workspace.Effects
	debris.AddItem(fr,5)

	local aim = script:FindFirstChild("aim"):Clone()
	aim.CFrame = pos.CFrame
	aim.Parent = workspace.Effects
	debris.AddItem(aim,5)

	local part1 = unit["Right Arm"].Part1 
	local part2 = fr 

	local weld = Instance.new("Weld")
	weld.Part0 = part1
	weld.Part1 = part2
	weld.Parent = part1
	debris.AddItem(weld,2)


	local exp = script:FindFirstChild("ExplosionImpact"):Clone()  -- EXPLOSION
	debris.AddItem(exp,5)


	wait(0.3)


	emit.emitvfx(unit["Right Arm"].tt)


	wait(0.15)
	emit.enablevfx(aim,true)


	emit.enablevfx(fr,true)


	local shoottween = tween_service:Create(fr.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 9}):Play()
	wait(0.6)
	
	
	fr.Anchored = true

	task.wait(0.010)

	local rocketpos = fr.Position
	local enemypos = pos.Position

	local magnitude = (rocketpos-enemypos).magnitude
	local Step = 20

	local LookAt = CFrame.new(rocketpos,enemypos)

	local Time = math.random(-0,0)/100
	local Time2 = math.random(15,15)/200
	spawn(function()

		for i = 1,Step do
			fr.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45 * Time),math.sin(math.rad((i * (180/Step))))* (15 * Time2),-(magnitude/Step) * (i))
			game:GetService("RunService").Heartbeat:Wait()
		end

		local shoottween = tween_service:Create(fr.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

		emit.enablevfx(fr,false)

		exp.Parent = workspace.Effects

		exp.CFrame = pos.CFrame * CFrame.new(0,-1.35,0) -- EXPLOSION TARGET

 	
		emit.emitvfx(exp)

		emit.enablevfx(aim,false)

	end)



	emit.emitvfx(disparo)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
