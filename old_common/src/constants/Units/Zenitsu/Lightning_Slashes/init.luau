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
	HitDelay = 1, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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

	AnimModule.PlayAnim(script.atk1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Atk1"], rt, Replicated.SoundGroups.UnitSFX)

	emit.trailonoff(unit,true)


	local SavedDirection = rt.CFrame.LookVector

	task.wait(.44)

	local slash = script.Zenitsuatk1:Clone() -- vfx
	slash.Parent = workspace.Effects
	slash.CFrame = rt.CFrame 
	emit.enablevfx(slash,true)
	debris.AddItem(slash,3)
	
	task.spawn(function()
		for i=0,5,1 do
			slash.imp.CFrame = 	slash.imp.CFrame + Vector3.new(math.random(-2,2),math.random(-1,2),math.random(-2,2))
			slash.imp.Orientation = Vector3.new(math.random(-360,360),math.random(-360,360),math.random(-360,360))

			emit.emitvfx(slash.imp)
			task.wait(.15)
			slash.impBlue.CFrame = 	slash.impBlue.CFrame + Vector3.new(math.random(-2,2),math.random(-1,2),math.random(-2,2))
			slash.impBlue.Orientation = Vector3.new(math.random(-360,360),math.random(-360,360),math.random(-360,360))
			emit.emitvfx(slash.impBlue)
			task.wait(.15)
		end
	end)
	

	
	task.wait(1.6)
	
	emit.enablevfx(slash,false)

					
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
