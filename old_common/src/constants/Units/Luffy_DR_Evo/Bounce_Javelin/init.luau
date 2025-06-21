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
	HitDelay = 1.6, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
    local DefaultCFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 3, "", {Weight = 2, Fade = .15})

    task.wait(.75)

    local Startup = script.BounceJavelin:Clone()
    Startup.CFrame = rt.CFrame * CFrame.new(1.5, 1.35, -1) * CFrame.Angles(0, math.rad(90), 0)
    Startup.Parent = workspace.Effects
    VFXModule.Debris(Startup, 3)
    VFXModule.Emit(Startup)

    Startup.Bounce4.WorldPosition = pos.Position
    for i, v in pairs(Startup:GetDescendants()) do
        if string.match(v.Name, "Bounce") and v.Name ~= "Bounce4" then
            local name = string.reverse(v.Name)
            local index = string.sub(name, 1, 1)
            v.WorldPosition = Startup.Position:Lerp(pos.Position, 1/(4-index)) + Vector3.new(Rand:NextNumber(-36, 36), Rand:NextNumber(-3, 3), Rand:NextNumber(-6, 6))
        end
    end
    
    local ArmTable = {}

    for i = 1, 4 do
        SoundWrapper:PlaySound(script.Blast, rt)
        SoundWrapper:PlaySound(script.Dash, rt)

        local Arm = script.Arm:Clone()
        local Distance
        if i == 1 then
            Distance = (Startup["Bounce"..i].WorldPosition - Startup.Start.WorldPosition).Magnitude
            Arm.CFrame = CFrame.new(Startup.Start.WorldPosition, Startup["Bounce"..i].WorldPosition) * CFrame.Angles(math.rad(90), 0, 0)
            TweenService:Create(Arm, TweenInfo.new(.25, Enum.EasingStyle.Quad), {Size = Vector3.new(Arm.Size.X, Distance, Arm.Size.Z), CFrame = Arm.CFrame * CFrame.new(0, -Distance/2, 0)}):Play()
        else
            Distance = (Startup["Bounce"..i].WorldPosition - Startup["Bounce"..i - 1].WorldPosition).Magnitude
            Arm.CFrame = CFrame.new(Startup["Bounce"..i - 1].WorldPosition, Startup["Bounce"..i].WorldPosition) * CFrame.Angles(math.rad(90), 0, 0)
            TweenService:Create(Arm, TweenInfo.new(.25, Enum.EasingStyle.Quad), {Size = Vector3.new(Arm.Size.X, Distance, Arm.Size.Z), CFrame = Arm.CFrame * CFrame.new(0, -Distance/2, 0)}):Play()
        end
        Arm.Parent = workspace.Effects
        VFXModule.Debris(Arm, 2)
        VFXModule.Emit(Arm)
        table.insert(ArmTable, Arm)

        task.wait(.2)
    end

    VFXModule.Emit(Startup)
    for i = 1, #ArmTable do
        SoundWrapper:PlaySound(script.Blast2, rt)
        local Arm = ArmTable[#ArmTable - (i - 1)]
        local Distance
        if i == 1 then
            Distance = (Startup["Bounce"..i].WorldPosition - Startup.Start.WorldPosition).Magnitude
        else
            Distance = (Startup["Bounce"..i].WorldPosition - Startup["Bounce"..i - 1].WorldPosition).Magnitude
        end
        TweenService:Create(Arm, TweenInfo.new(.25, Enum.EasingStyle.Quad), {Size = Vector3.new(Arm.Size.X, 0, 0), CFrame = Arm.CFrame * CFrame.new(0, Distance/2, 0)}):Play()
        task.wait(.15)
    end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
