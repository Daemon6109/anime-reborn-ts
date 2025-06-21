local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .455, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local SavedDirection = rt.CFrame.LookVector

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)
	
	local SavedDirection = rt.CFrame.LookVector

	unit.Torso.tp:Emit(25) -- teleporting the above the enemy back
	wait(.12)
	rt.CFrame = pos.CFrame + Vector3.new(0,10,0) + (rt.CFrame.LookVector * -4 )
	local info = TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)  }) 
	tween:Play()
	unit.Torso.tp:Emit(25)		
	

	
	wait(.35)
	local impact = script.AirSlash:Clone() -- vfx
	impact.Parent = workspace.Effects
	impact.Position =  pos.Position + (rt.CFrame.LookVector * 1 + Vector3.new(0,-1,0)) 
	debris.AddItem(impact,2)

	emit.emitvfx(impact) -- emitting the vfx with my module

	wait(.35)	
	emit.trailonoff(unit,false)
	unit.Torso.tp:Emit(25)
	wait(.12)
	rt.CFrame = startpos -- teleporting the unit bac
	wait(.03)
	unit.Torso.tp:Emit(25)	
	emit.trailonoff(unit,true)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
