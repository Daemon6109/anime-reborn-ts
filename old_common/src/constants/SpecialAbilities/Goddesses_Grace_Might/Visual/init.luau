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
	HitDelay = .6, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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
	local unit, rt, pos = table.unpack(Tab)
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	local anim = AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	AnimModule.ChangeAnimSpeed(anim,.8)
	
	local charge = script.PowerdeCharge:Clone() -- vfx
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	emit.enablevfx(charge,true)	

	task.spawn(function()
		for i=0,7,1 do
			task.wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(15, 99, 255)),0.0005,.7,"Mid",true,6,.5,1.4)
		end
	end)

	task.wait(.65)
	SoundWrapper:PlaySound(script["Impact"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.emitvfx(unit.Torso.jump)	
	
	emit.emitvfx(charge)

	emit.enablevfx(charge,false)
	
	local Allies = _G.clientGUIServices.ClientUnitHandler:GetAllyUnitsInRange(unit)
	
	for i,v in pairs(Allies) do
		local Visual = v.VisualModelLink.Value
		if Visual:FindFirstChild("Torso") then
			local Powered = script.Powered:Clone() -- vfx
			Powered.Parent = workspace.Effects
			Powered.Position = Visual.Torso.Position	
			emit.emitvfx(Powered)
			debris.AddItem(Powered,2)
		end
	end

	debris.AddItem(charge,2)	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
