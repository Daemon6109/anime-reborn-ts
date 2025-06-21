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
	HitDelay = 1.15, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
	EndingDelay = .25
}
function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

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
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.atk1, unit, 1.3, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Atk1"], rt, Replicated.SoundGroups.UnitSFX)

	emit.trailonoff(unit,true)


	local SavedDirection = rt.CFrame.LookVector
	
	emit.emitvfx(unit.Torso.jump)
	task.wait(.2)


	local info = TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -2.6) }) -- tween to go to the pos
	tween:Play()

	task.wait(0.4)

	local slash = script.Inosukeatk1:Clone() -- vfx
	slash.Parent = workspace.Effects
	slash.CFrame = rt.CFrame + (rt.CFrame.LookVector *1.5)
	emit.emitvfx(slash)
	debris.AddItem(slash,2.2)

	task.wait(.4)
	
	emit.trailonoff(unit,false)

	unit.Torso.tp:Emit(15)
	task.wait(.3)
	rt.CFrame = startpos -- teleporting the unit bac
	task.wait(.03)
	unit.Torso.tp:Emit(15)	

	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
