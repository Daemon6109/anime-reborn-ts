local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = 2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    task.wait(.25)

    local RockSlam = script.RockSlam:Clone()
    RockSlam.CFrame = pos.CFrame * CFrame.new(0, -11, -3) * CFrame.Angles(math.rad(-90), 0, 0)
    RockSlam.Parent = workspace.Effects
    VFXModule.Debris(RockSlam, 5)

    TweenService:Create(RockSlam, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = RockSlam.CFrame * CFrame.new(0, 0, 12)}):Play()

    task.wait(1)

    local Launchup = script.LaunchUp:Clone()
    Launchup.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0) 
    Launchup.Parent = workspace.Effects
    VFXModule.Debris(Launchup, 3)
    VFXModule.Emit(Launchup)

    TweenService:Create(rt, TweenInfo.new(.35), {CFrame = rt.CFrame * CFrame.new(0, 15, 0)}):Play()

    task.wait(.35)
    TweenService:Create(rt, TweenInfo.new(.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(pos.Position) * rt.CFrame.Rotation * CFrame.new(0, 4, 5)}):Play()

    task.wait(.35)
    VFXModule.Emit(RockSlam)

    task.wait(1.5)
    TweenService:Create(RockSlam, TweenInfo.new(.5, Enum.EasingStyle.Quad), {CFrame = RockSlam.CFrame * CFrame.new(0, 0, -15)}):Play()
    rt.CFrame = DefaultCFrame


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
