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
	HitDelay = .75, -- seconds
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

	local start = AnimModule.PlayAnim(script.Start, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)
		task.spawn(function()
		for i=0,3,1 do
			wait(.1)
			emit.bezier(unit["Right Arm"].Pos.WorldCFrame,ColorSequence.new(Color3.fromRGB(70, 255, 42)),0.0005,1,"Short",false,0,0,1)
			emit.bezier(unit["Left Arm"].Pos.WorldCFrame,ColorSequence.new(Color3.fromRGB(70, 255, 42)),0.0005,1,"Short",false,0,0,1)
		end
	end)	
	emit.emitvfx(unit.Torso.jump)
	task.wait(.05)
	
	emit.emitvfx(unit["Right Arm"])
	emit.emitvfx(unit["Left Arm"])
	task.wait(.25)		
	AnimModule.StopAnim(unit,start)

	local Healing = script.SakuraHeal:Clone() 
	Healing.Parent = workspace.Effects
	Healing.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) + Vector3.new(0,-1.35,0)
	emit.enablevfx(Healing,true)
	emit.emitvfx(Healing)	
	debris.AddItem(Healing,2.5)

	local loopanim = AnimModule.PlayAnim(script.Loop, unit, 1, "", {Weight = 2.0, Fade = .15})
	
		
	task.wait(2)

	emit.enablevfx(Healing,false)
	emit.emitvfx(Healing)		
	
	AnimModule.PlayAnim(script.End, unit, 1, "", {Weight = 2.1, Fade = .15})
	
	task.wait(.3)
	emit.emitvfx(unit["Right Arm"])
	emit.emitvfx(unit["Left Arm"])
	

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
