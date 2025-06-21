local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local VFXModule = require(Replicated.Libs.VFXModule)

module.config = {
	HitDelay = .35, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .085, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1, "Hand", {Weight = 2, Fade = .15})
    
    local p0, p3 = rt.Position + Vector3.new(-.5, -1, -1), pos.Position

    local Distance = (p3 - p0).Magnitude
    local PartCount = math.ceil((Distance/30) * 20)
    if PartCount > 30 then PartCount = 30 end

    for _ = 1, 6 do
        SoundWrapper:PlaySound(script.Flash, rt)
        local RootsTable = {}
        local p1 = p0:Lerp(p3, .4) + Vector3.new(Rand:NextInteger(-24, 24), Rand:NextInteger(-1, 12), Rand:NextInteger(-12, 12))
        local p2 = p0:Lerp(p3, .8) + Vector3.new(Rand:NextInteger(-12, 12), Rand:NextInteger(-2, 6), Rand:NextInteger(-8, 8))

        task.spawn(function()
            for i = 1, PartCount do
                local Root = script.String:Clone()
                local Magnitude = (VFXModule.ReturnCubicBezier((i + 1)/ PartCount, p0, p1, p2, p3) - VFXModule.ReturnCubicBezier(i / PartCount, p0, p1, p2, p3)).Magnitude
                Root.CFrame = CFrame.lookAt(VFXModule.ReturnCubicBezier(i / PartCount, p0, p1, p2, p3), VFXModule.ReturnCubicBezier((i + 1) / PartCount, p0, p1, p2, p3)) * CFrame.new(0, 0, -(Magnitude/2 - .1))
                Root.Parent = workspace.Effects
                VFXModule.Debris(Root, 4)
                TweenService:Create(Root, TweenInfo.new(.125, Enum.EasingStyle.Quad), {Size = Vector3.new(Root.Size.X * Rand:NextNumber(.7, 1.75), Root.Size.Y * Rand:NextNumber(.7, 1.75), Magnitude + .2)}):Play()
                Root.Size = Vector3.zero
                RootsTable[i] = Root

                TweenService:Create(Root.Invert, TweenInfo.new(.125), {Size = Root.Invert.Size}):Play()
                Root.Invert.Size = Vector3.zero

                if i % 4 == 0 then
                    SoundWrapper:PlaySound(script.Air, rt, nil, nil, nil, nil, .75)
                end
    
                task.wait(.025)
            end

            task.wait(.2)
            local ReversedRoots = {}

            for i = #RootsTable, 1, -1 do
                table.insert(ReversedRoots, RootsTable[i])
            end

            for i, v in ipairs(ReversedRoots) do
                if i % 4 == 0 then
                    SoundWrapper:PlaySound(script.Air2, rt, nil, nil, nil, nil, .5)
                end

                VFXModule.EffectToggle(v, false)
                TweenService:Create(v, TweenInfo.new(.25, Enum.EasingStyle.Quad), {Size = Vector3.new(0, 0, v.Size.Z)}):Play()
                TweenService:Create(v.Invert, TweenInfo.new(.25, Enum.EasingStyle.Quad), {Size = Vector3.new(0, 0, v.Invert.Size.Z)}):Play()
                task.wait(.1)
            end
        end)


        task.wait(.075)
    end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
