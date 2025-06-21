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
	HitDelay = .45, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Jump, unit, 1.5, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
    rt.CFrame = CFrame.new(pos.Position) * DefaultCFrame.Rotation * CFrame.new(0, 12, 4)

    task.wait(.15)

    TweenService:Create(rt, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = pos.CFrame * rt.CFrame.Rotation}):Play()

    local Explosion = script.Explosion:Clone()
    Explosion.CFrame = rt.CFrame * CFrame.new(0, -1.5, 0)
    Explosion.Parent = workspace.Effects
    VFXModule.Debris(Explosion, 3)
    VFXModule.Emit(Explosion)
    VFXModule.GroundExpandV2(rt.CFrame, 2, 6, {baseDestroyWait = 2})

    for i = 1, 8 do
        local Afterimage = unit:Clone()
        Afterimage.PrimaryPart.CFrame =  CFrame.lookAt((pos.CFrame * CFrame.new(math.random(-12, 12), math.random(2.5, 5), math.random(-12, 12))).Position, pos.Position)
        Afterimage.Parent = workspace.CurrentCamera
        AnimModule.PlayAnim(script.Jump, Afterimage, 2, "", {Weight = 2, Fade = .15})
        VFXModule.Debris(Afterimage, 2)

        TweenService:Create(Afterimage.HumanoidRootPart, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = pos.CFrame * CFrame.new(math.random(-12, 12), -1, math.random(-12, 12)) * Afterimage.HumanoidRootPart.CFrame.Rotation}):Play()

        task.delay(.35, function()
            local Explosion = script.Explosion:Clone()
            Explosion.CFrame = Afterimage.HumanoidRootPart.CFrame * CFrame.new(0, -1.5, 0)
            Explosion.Parent = workspace.Effects
            VFXModule.Debris(Explosion, 3)
            VFXModule.Emit(Explosion)
            VFXModule.GroundExpandV2(Explosion.CFrame, 2, 6, {baseDestroyWait = 2})

            task.wait(.5)

            TweenService:Create(Afterimage.HumanoidRootPart, TweenInfo.new(.35, Enum.EasingStyle.Quad), {CFrame = Afterimage.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)}):Play()
        end)

        task.wait(.1)
    end


    task.wait(1)
    rt.CFrame = DefaultCFrame
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
