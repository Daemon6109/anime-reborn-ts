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
	HitDelay = 2.25, -- seconds
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
	
	local aninm= AnimModule.PlayAnim(script.Animation3, unit, 1.2, "", {Weight = 2, Fade = .5})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.15)

	local charge = script:FindFirstChild("handAppear"):Clone()
	charge.Parent = effectsfolder
	charge.CFrame =  CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -12)+ Vector3.new(0,-1,0)
	debris.AddItem(charge,4)
	emit.enablevfx(charge,true)
	emit.emitvfx(charge)

	local hand = script:FindFirstChild("Blue Arm [ Anime Reborn ]"):Clone()
	hand.Parent = effectsfolder
	hand.PrimaryPart.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -15.4) + Vector3.new(0,-.4,0)
	debris.AddItem(hand,4)
	
	emit.enablevfx(hand,true)
	
	local animController = hand.AnimationController
	local LoadAnim = animController:LoadAnimation(AnimModule.GetAnim(script.Handanim))
	LoadAnim:Play()

	task.wait(1.75)

	local smash = script:FindFirstChild("Smash"):Clone()
	smash.Parent = effectsfolder
	smash.Position = pos.Position + Vector3.new(0,-1,0)
	debris.AddItem(smash,4)
	emit.emitvfx(smash)
	
	task.wait(.3)
	emit.enablevfx(charge,false)
	emit.emitvfx(charge)

	emit.emitvfx(hand)
	emit.enablevfx(hand,false)

	local dissapear = script:FindFirstChild("ArmDisappear"):Clone()
	dissapear.Parent = effectsfolder
	dissapear.CFrame =  CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -3)
	debris.AddItem(dissapear,4)
	emit.emitvfx(dissapear)
	hand.Plane.Transparency = 1
		
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
