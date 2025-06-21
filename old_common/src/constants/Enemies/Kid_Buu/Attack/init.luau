local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1, -- seconds
	Duration = .25,
	TurnTime = .7,
	StunTime = 5,
	AttackRange = 35,
	AttackSize = 15,
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Throw, unit, 1, "", {Weight = 2, Fade = .15})

	local effectsfolder = workspace.Effects

	task.wait(.35)

	local orbsend = script.KiblastSend:Clone() -- vfx
	orbsend.Parent = workspace.Effects
	orbsend.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * .5)
	emit.emitvfx(orbsend)
	debris.AddItem(orbsend,5.25)
	orbsend.Anchored = true

	local orb = script.Kiblast:Clone() -- vfx
	orb.Parent = workspace.Effects
	orb.CFrame = unit["Left Arm"].CFrame + (unit["Left Arm"].CFrame.LookVector * .5)
	emit.enablevfx(orb,true)
	orb.Anchored = true

	local info = TweenInfo.new(.45,Enum.EasingStyle.Sine,Enum.EasingDirection.In)
	local tween = tween_service:Create(orb,info,{Position = pos.Position}) -- tween for the orb
	tween:Play()
	debris.AddItem(orb,3.25)
	
	
	task.wait(.45)
	local imp = script.KiblastExplosion:Clone() -- vfx
	imp.Parent = workspace.Effects
	imp.Position = pos.Position
	emit.emitvfx(imp)
	debris.AddItem(imp,3.25)
	imp.Anchored = true

	
	emit.emitvfx(orb)
	emit.enablevfx(orb,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
