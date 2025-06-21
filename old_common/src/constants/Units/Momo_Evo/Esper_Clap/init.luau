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
	HitDelay = 2.125, -- seconds
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


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local animm = AnimModule.PlayAnim(script.Animation2, unit, 1.45, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local charge = script:FindFirstChild("handAppear"):Clone()
	charge.Parent = effectsfolder
	charge.CFrame =  CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 9.2) + (rt.CFrame.RightVector * 0.9) + Vector3.new(0,-1,0)
	debris.AddItem(charge,4)
	emit.enablevfx(charge,true)
	emit.emitvfx(charge)

	local charge2 = script:FindFirstChild("handAppear"):Clone()
	charge2.Parent = effectsfolder
	charge2.CFrame =  CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 9.2) + (rt.CFrame.RightVector * -0.9) + Vector3.new(0,-1,0)
	debris.AddItem(charge2,4)
	emit.enablevfx(charge2,true)
	emit.emitvfx(charge2)

	local hand = script:FindFirstChild("Blue Arm [ Anime Reborn ]"):Clone()
	hand.Parent = effectsfolder
	hand.PrimaryPart.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 5) + (rt.CFrame.RightVector * -0.5) + Vector3.new(0,-2.5,0)
	debris.AddItem(hand,4)
	
	emit.enablevfx(hand,true)

	local hand2 = script:FindFirstChild("Blue Arm [ Anime Reborn ]"):Clone()
	hand2.Parent = effectsfolder
	hand2.PrimaryPart.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * 5) + (rt.CFrame.RightVector * 0.5)+ Vector3.new(0,-2.5,0)
	debris.AddItem(hand2,4)

	emit.enablevfx(hand2,true)

	local animController = hand.AnimationController
	local LoadAnim = animController:LoadAnimation(AnimModule.GetAnim(script.Handanim))
	LoadAnim:Play()

	local animController = hand2.AnimationController
	local LoadAnim2 = animController:LoadAnimation(AnimModule.GetAnim(script.Handanim2))
	LoadAnim2:Play()


	task.wait(1.65)
	emit.enablevfx(charge,false)
	emit.enablevfx(charge2,false)
	
	emit.emitvfx(charge)
	emit.emitvfx(charge2)

	
	hand.Plane.Transparency = 1
	hand2.Plane.Transparency = 1
	
	emit.emitvfx(hand)
	emit.enablevfx(hand,false)
	emit.emitvfx(hand2)
	emit.enablevfx(hand2,false)
	
	local hit = script:FindFirstChild("Clap"):Clone()
	hit.Parent = effectsfolder
	hit.Position = pos.Position + Vector3.new(0,-1,0)
	debris.AddItem(hit,4)
	emit.emitvfx(hit)
	
end
	


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
