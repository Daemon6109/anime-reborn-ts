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
	HitDelay = 2.3, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .135, -- delay between hits in a multi-hit move
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
	local TargetPoint = pos.CFrame
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move1"], rt, Replicated.SoundGroups.UnitSFX)
	
	local PainAsura = script.Move1:FindFirstChild("PainAsura"):Clone()
	PainAsura.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(-5,0,1.5)
	debris.AddItem(PainAsura,6)

	local asurapainmoves = script.Move1:FindFirstChild("asurapainmoves"):Clone()
	asurapainmoves.jump.CFrame = rt.CFrame * CFrame.new(-5,-1.4,1.5)
	debris.AddItem(asurapainmoves,6)
	asurapainmoves.Parent = effectsfolder
	PainAsura.Parent = effectsfolder



	AnimModule.PlayAnim(script.Asurapain, PainAsura, 1, "", {Weight = 2, Fade = .15})


	task.wait(0.001)

	PainAsura.HumanoidRootPart.CFrame = CFrame.new(PainAsura.HumanoidRootPart.Position, TargetPoint.Position)

	emit.emitvfx(asurapainmoves)

	asurapainmoves.jump.CFrame = rt.CFrame * CFrame.new(-5,-1.4,1.5)

	task.wait(0.850)

	PainAsura.weapon.number.Transparency = 0

	task.wait(0.1)


	PainAsura.weapon.number2.Transparency = 0


	task.wait(0.1)

	PainAsura.weapon.numberthree.Transparency = 0

	task.wait(0.1)

	emit.enablevfx(PainAsura.weapon.number4,true)

	PainAsura.weapon.number4.Transparency = 0

	task.wait(0.3)

	task.spawn(function()

		for i = 1,3 do
			local aa = script.Move1:FindFirstChild("missil"):Clone()
			aa.CFrame = PainAsura.HumanoidRootPart.CFrame * CFrame.new(0,1,-1)
			aa.Parent = effectsfolder
			debris.AddItem(aa,4)

			local rocketpos = aa.Position
			local enemypos = TargetPoint.Position + Vector3.new(math.random(-3,3),0,math.random(-3,3))

			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 30

			local LookAt = CFrame.new(rocketpos,enemypos)

			local Time = math.random(-25,25)/100
			local Time2 = math.random(44,66)/200
			task.spawn(function()

				for i = 1,Step do
					aa.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45 * Time),math.sin(math.rad((i * (180/Step))))* (15 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end
				--print("booom")

				local explosion = script.Move1:FindFirstChild("explosion"):Clone()
				explosion.CFrame = aa.CFrame
				explosion.Parent = effectsfolder
				debris.AddItem(explosion,3)

				explosion.Orientation = Vector3.new()

				emit.emitvfx(explosion)

				emit.enablevfx(aa,false)



			end)
			task.wait(.05)
		end

	end)


	emit.enablevfx(PainAsura.weapon.number4,false)


	task.wait(0.7)

	PainAsura:Destroy()


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
