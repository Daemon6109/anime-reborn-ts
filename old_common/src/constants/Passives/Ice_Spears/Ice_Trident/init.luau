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
	HitDelay = 1.7, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module.Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	local Spear = script["Meshes/trident_Plane (1)"]:Clone()
	Spear.Position = pos.Position + Vector3.new(0,11,0)
	Spear.Parent = effectsfolder
	debris.AddItem(Spear,3)
	emit.emitvfx(Spear)
	emit.enablevfx(Spear,true)
	
	local oldsize = Spear.Size
	Spear.Size = Vector3.new(0,0,0)
	local TweenComplete = tween_service:Create(Spear,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = oldsize})
	TweenComplete:Play()
	
	
	task.wait(.25)	
	local TweenComplete = tween_service:Create(Spear,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position = pos.Position + Vector3.new(0,-1,0)})
	TweenComplete:Play()

	task.wait(.25)
	
		
	local ImpactLast = script.TridentHit:Clone()
	ImpactLast.Position = pos.Position + Vector3.new(0,-1.2,0)
	ImpactLast.Parent = effectsfolder
	debris.AddItem(ImpactLast,3)
	emit.emitvfx(ImpactLast)
	
	Spear.Transparency = 1
	emit.enablevfx(Spear,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
