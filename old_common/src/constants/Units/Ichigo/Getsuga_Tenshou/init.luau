local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)
	
	local SavedDirection = rt.CFrame.LookVector

	task.wait(.35)

	local getsuga = script.GetsugaTenshou:Clone() -- cloning the vfx from the scripts childeren
	getsuga.Parent = workspace.Effects
	getsuga.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 6.5 + Vector3.new(0,-1,0)) -- setting the getsuga tenshou to 13 studs infront the units rootpart and 1 stud down
	emit.emitvfx(getsuga)

	local slash = script.slashgetsuga:Clone() -- vfx
	slash.Parent = workspace.Effects
	slash.CFrame =  rt.CFrame + (rt.CFrame.LookVector * 2 + Vector3.new(0,-.3,0)) -- setting the getsuga tenshou to 2 studs infront the units rootpart and 0.3 studs down
	emit.emitvfx(slash)
	
	debris.AddItem(slash,2)
	debris.AddItem(getsuga,3)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
