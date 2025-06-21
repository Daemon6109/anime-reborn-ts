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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		task.wait(1)
		SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	end)	
	task.wait(.2)

	emit.emitvfx(unit.Torso.jump)

	task.wait(.85)
	
	emit.emitvfx(unit["M1911 .45"])

	local bullet = script.Bullet:Clone()
	bullet.CFrame = unit["M1911 .45"].Slide.Shot.WorldCFrame
	bullet.Parent = effectsfolder
	debris.AddItem(bullet,3)
	emit.enablevfx(bullet,true)
	
	local TweenComplete = tween_service:Create(bullet,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position =pos.Position})
	TweenComplete:Play()
	
	task.wait(.2)
	
	emit.enablevfx(bullet,false)
	bullet.Transparency = 1
	
	local impact = script.Kiritsugumipcat:Clone()
	impact.CFrame = bullet.CFrame
	impact.Parent = effectsfolder
	debris.AddItem(impact,3)
	emit.emitvfx(impact)
	
	
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
