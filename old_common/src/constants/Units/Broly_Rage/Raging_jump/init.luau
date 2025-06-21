local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local rocksmodule = require(Replicated.Libs.RocksModule)

module.config = {
	HitDelay = 1.35, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
	EndingDelay = 0.7
}
function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	local SavedDirection = rt.CFrame.LookVector

	local newanim=AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script:FindFirstChild("1"), rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.2)

	AnimModule.ChangeAnimSpeed(newanim,1.2)

	emit.emitvfx(unit.Torso.jump)

	local PointA = rt.CFrame 
	local PointB = rt.CFrame + (rt.CFrame.LookVector * 7 + Vector3.new(0,25,0))
	local PointC = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,-.5,0)

	for i=0,1,.03 do
		rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
		local Part = rt
		Part.CFrame = CFrame.new(Bezier(i,PointA.Position,PointB.Position,PointC.Position))
		task.wait(0.00000005)
	end		

	local jumpipact = script["saiyanjump(atk1)"]:Clone() -- vfx
	jumpipact.Parent = workspace.Effects
	jumpipact.Position =  rt.Position + Vector3.new(0,-1,0)
	emit.emitvfx(jumpipact)
	debris.AddItem(jumpipact,3)

	task.wait(0.1)
	
	unit.Torso.tp:Emit(25) -- teleporting the unit back
	task.wait(.1)
	rt.CFrame = startpos
	task.wait(.03)
	unit.Torso.tp:Emit(25)
	
	for i=0,3,1 do
		task.spawn(function()
			emit.Scatter(jumpipact.CFrame + Vector3.new(math.random(-4,4),0,math.random(-4,4)),ColorSequence.new(Color3.fromRGB(39, 255, 39)),0.000005,.4,"Mid",true,9,.7,2,-2,4,4,9,.1,math.random(50,60) / 1000)
			emit.Scatter(jumpipact.CFrame + Vector3.new(math.random(-4,4),0,math.random(-4,4)),ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.000005,.4,"Mid",true,0,.0,2,-2,4,4,9,.1,math.random(50,60) / 1000)
		end)
	end	


	rocksmodule.Ground(jumpipact.Position + Vector3.new(0,-1,0),15, Vector3.new(1.25, 1.25, 1.25), nil, 7, false, 1.4)




end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
