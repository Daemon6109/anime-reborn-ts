local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local rocksmodule = require(Replicated.Libs.RocksModule)


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

module.config = {
	HitDelay = 2, -- seconds
	HitCount = 16, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	local newanim=AnimModule.PlayAnim(script.fourthattack, unit, 1, "", {Weight = 2, Fade = .15})


	SoundWrapper:PlaySound(script["4"], rt, Replicated.SoundGroups.UnitSFX)
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)


	task.wait(.45)


	local info = TweenInfo.new(.75,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = rt.CFrame + Vector3.new(0,7,0)}) -- making the unit float
	tween:Play()

	AnimModule.ChangeAnimSpeed(newanim,1)

	emit.emitvfx(unit.Torso.jump)

	task.wait(.45)

	local rage = script["RageAtBroly(atk4)"]:Clone() -- vfx
	rage.Parent = workspace.Effects
	rage.CFrame =  unit.Torso.CFrame + Vector3.new(0,1,0)
	emit.enablevfx(rage,true)
	debris.AddItem(rage,5)

	local rotpart = Instance.new("Part")
	rotpart.Transparency = 1
	rotpart.CanCollide = false
	rotpart.Anchored = true
	rotpart.Position = rt.Position + Vector3.new(0,8,0)
	rotpart.Orientation = Vector3.new(0,0,0)	

	local function projcetiles()
		task.spawn(function()

			rotpart.Orientation = rotpart.Orientation + Vector3.new(0,math.random(-180,180),0)

			local PointA = rotpart.CFrame + Vector3.new(0,6,0)
			local PointB = rotpart.CFrame + (rotpart.CFrame.LookVector * math.random(2,8) + Vector3.new(0,math.random(18,20),0))
			local PointC = rotpart.CFrame + (rotpart.CFrame.LookVector * math.random(5,22)) + Vector3.new(0,-17,0)

			local prjectile = script["saiyanrageprojectile(atk4)"]:Clone()
			prjectile.Parent = workspace.Effects
			prjectile.CFrame = rotpart.CFrame
			emit.enablevfx(prjectile,true)
			debris.AddItem(prjectile,3)

			task.spawn(function()
				for d=0,1,.02 do
					local Part = prjectile
					Part.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))

					task.wait(0.00005)
				end						

				SoundWrapper:PlaySound(script["4projecitle"], prjectile, Replicated.SoundGroups.UnitSFX)

				local impacct = script["saiyanrageimpact(atk4)"]:Clone()
				impacct.Parent =  workspace.Effects
				impacct.Position = prjectile.Position
				emit.emitvfx(impacct)
				emit.enablevfx(prjectile,false)
				debris.AddItem(impacct,1)

				rocksmodule.Ground(impacct.Position + Vector3.new(0,-6.5,0),6, Vector3.new(1, 1, 1), nil, 5, false, .85)
				task.wait(1)

			end)

		end)
	end

	for i=0,16,1 do
		task.wait(.17)
		projcetiles()
	end
	emit.enablevfx(rage,false)

	task.wait(.1)
	local info = TweenInfo.new(.7,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = rt.CFrame + Vector3.new(0,-7,0)}) -- making the unit float
	tween:Play()


	wait(1.5)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
