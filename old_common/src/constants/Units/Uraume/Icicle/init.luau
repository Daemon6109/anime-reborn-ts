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





function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	task.wait(.5)
	
	emit.enablevfx(unit["Right Arm"].IceChargeParticle,true)
	emit.emitvfx(unit["Right Arm"].IceChargeParticle)
	
	task.wait(.85)
	
	local Iceshard = script.Icicle:Clone() 
	Iceshard.Parent = workspace.Effects
	Iceshard.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1) + Vector3.new(0,.25,0)+ (rt.CFrame.RightVector * .4)
	emit.enablevfx(Iceshard,true)
	emit.emitvfx(Iceshard)
	debris.AddItem(Iceshard,3)
	
	local Shoot = script.shootpart:Clone() 
	Shoot.Parent = workspace.Effects
	Shoot.CFrame = rt.CFrame + (rt.CFrame.LookVector * 0.5) + Vector3.new(0,.25,0)+ (rt.CFrame.RightVector * .4)
	emit.emitvfx(Shoot)
	debris.AddItem(Shoot,3)
	
	local TweenComplete = tween_service:Create(Iceshard,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)})
	TweenComplete:Play()
	
	task.wait(.25)
	emit.enablevfx(Iceshard,false)

	local explosion = script.iceexplosionpart:Clone() 
	explosion.Parent = workspace.Effects
	explosion.CFrame = pos.CFrame
	emit.emitvfx(explosion)
	debris.AddItem(explosion,3)
	Iceshard.Transparency = 1
	emit.enablevfx(unit["Right Arm"].IceChargeParticle,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
