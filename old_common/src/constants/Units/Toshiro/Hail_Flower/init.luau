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
	HitDelay = 1.2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

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
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.3)
		
	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.2)
	
	local vfxstart = script.Bottom:Clone() 
	vfxstart.Parent = workspace.Effects
	vfxstart.CFrame = rt.CFrame +  (rt.CFrame.LookVector * 4) + Vector3.new(0,-.9,0)
	emit.emitvfx(vfxstart)
	debris.AddItem(vfxstart,3)	
	
	task.wait(.1)

	local ice = script.Icespiketoshiro:Clone() 
	ice.Parent = workspace.Effects
	ice.PrimaryPart.CFrame = rt.CFrame +  (rt.CFrame.LookVector * 7)
	emit.enablevfx(ice,true)
	debris.AddItem(ice,3)	
	
	task.wait(.7)	
	emit.enablevfx(ice,false)

	emit.emitvfx(ice)
	emit.emitvfx(vfxstart)
	
	ice.s1["ice spikes 2"].Transparency = 1
	ice.s2["ice spikes 2"].Transparency = 1
	ice.s3["ice spikes 2"].Transparency = 1
	

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
