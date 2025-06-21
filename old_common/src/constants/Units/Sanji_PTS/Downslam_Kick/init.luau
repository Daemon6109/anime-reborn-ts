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
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
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

	AnimModule.PlayAnim(script.firstattack, unit, 1.3, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.1)
	
	emit.enablevfx(unit.Torso.SpinWind,true)
	for i=0,5,1 do
		wait(.05)
		emit.bezier(unit["Left Leg"].CFrame,ColorSequence.new(Color3.fromRGB(255, 255, 255)),0.00000000005)
	end
	task.wait(.17)
	
	emit.enablevfx(unit.Torso.SpinWind,false)
	emit.emitvfx(unit.Torso.SpinWind)

	
	local Impact = script.Sanjiatk1:Clone() -- vfx
	Impact.Parent = workspace.Effects
	Impact.CFrame = rt.CFrame + (rt.CFrame.LookVector * .9) + (rt.CFrame.RightVector * .5) + Vector3.new(0,-1.4,0)
	emit.emitvfx(Impact)

	debris.AddItem(Impact,3)

	task.wait(.4)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
