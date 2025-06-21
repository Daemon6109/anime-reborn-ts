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
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}



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
	local SavedDirection = rt.CFrame.LookVector


		
	local charge = script["Atk2 Charge"]:Clone() 
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1.3,0)
	emit.enablevfx(charge,true)
	debris.AddItem(charge,2.5)

	local newanim = AnimModule.PlayAnim(script.atk2, unit, 1, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		SoundWrapper:PlaySound(script["Atk1"], rt, Replicated.SoundGroups.UnitSFX)

	end)
	
	emit.trailonoff(unit.Zenit,true)

	
	task.wait(.7)
	
	emit.enablevfx(charge,false)

	
	local dash = script["Atk2 Whoosh"]:Clone() 
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.4)
	emit.emitvfx(dash)
	debris.AddItem(dash,3)
	emit.emitbeam(dash.beamemits,.3,0.35,.35)

	
	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = rt.CFrame + (rt.CFrame.LookVector * 18)
	wait(.03)
	unit.Torso.tp:Emit(15)

	emit.emitvfx(unit.Torso.jump)
	
	AnimModule.ChangeAnimSpeed(newanim,.75)

	task.wait(.7)
	
	emit.trailonoff(unit.Zenit,false)
	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	unit.Torso.tp:Emit(15)
	AnimModule.ChangeAnimSpeed(newanim,1)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
