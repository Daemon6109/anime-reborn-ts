local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local rocksmodule = require(Replicated.Libs.RocksModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end
module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local SavedDirection = rt.CFrame.LookVector

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script:FindFirstChild("2"), rt, Replicated.SoundGroups.UnitSFX)

	local clone = unit:Clone()
	debris.AddItem(clone,2.5)

	clone.Parent = workspace.Effects
	for i, v in pairs(clone:GetDescendants()) do
		task.spawn(function()
			if v:IsA("BasePart") then
				v.CanCollide = false 
				task.wait(.6)
				v.Transparency = 1
			end
			task.wait(1)
			clone:Destroy()
		end)        
	end	

	clone.Torso.Smoke:Emit(15)

	local newanim = AnimModule.PlayAnim(script["secondattack(Clone)"], clone, .8, "", {Weight = 2, Fade = .15})


	clone.HumanoidRootPart.CFrame = clone.HumanoidRootPart.CFrame + (clone.HumanoidRootPart.CFrame.RightVector * 1) 
	clone.HumanoidRootPart.CFrame = clone.HumanoidRootPart.CFrame + (clone.HumanoidRootPart.CFrame.LookVector * -.5)
	emit.enablevfx(unit["Right Arm"].Rasengan,true)

	task.wait(.4)

	clone.Torso.Smoke:Emit(15)


	task.wait(.4)

	AnimModule.ChangeAnimSpeed(newanim,1.25)	
	
	local PointA = rt.CFrame 
	local PointB = rt.CFrame + (rt.CFrame.LookVector * 7 + Vector3.new(0,5,0))
	local PointC = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	task.spawn(function()
		for i=0,1,.075 do
			rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)
			local Part = rt
			Part.CFrame = CFrame.new(Bezier(i,PointA.Position,PointB.Position,PointC.Position))
			task.wait(0.000001)
		end		


		local rasenganipact = script.rasenganimpact:Clone() -- vfx
		rasenganipact.Parent = workspace.Effects
		rasenganipact.Position =  rt.Position + (rt.CFrame.LookVector * 1 + Vector3.new(0,-1,0))
		emit.emitvfx(rasenganipact)
		emit.enablevfx(unit["Right Arm"].Rasengan,false)
		debris.AddItem(rasenganipact,2.5)

		rocksmodule.Ground(pos.Position + Vector3.new(0,-1,0),7.5, Vector3.new(.75, .75, .75), nil, 7, false, 1.4)



	end)




	task.wait(.93)


	unit.Torso.tp:Emit(25) -- teleporting the unit back
	task.wait(.12)
	rt.CFrame = startpos
	task.wait(.03)
	unit.Torso.tp:Emit(25)		

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
