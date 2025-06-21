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

local function GetXAndZPositions(Angle, Radius)
    local X = math.cos(Angle) * Radius
    local Z = math.sin(Angle) * Radius
    return X,Z
end

local function CreateFullCircle(Part, Number, Radius, Type)
    local AttachmentTable = {}
    local FullCircle = 2 * math.pi

    for i = 1, Number do
        local Attachment = Instance.new(Type)
        if Attachment:IsA('Part') then
			Attachment.Transparency = 1
			Attachment.Anchored = true
			Attachment.CanCollide = false
			Attachment.Size = Vector3.new(1, 1, 1)
		end
        Attachment.Parent = Part
        
        local Angle = i * (FullCircle/Number)
        local X, Z = GetXAndZPositions(Angle, Radius)

		local Position = ( Part.CFrame * CFrame.new(X, 0, Z) ).Position
        local LookAt = Part.Position

        if Attachment:IsA("Attachment") then
			Attachment.WorldCFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / 2, 0)
        else
            Attachment.CFrame = CFrame.lookAt(Position, LookAt) * CFrame.fromEulerAnglesXYZ(0, -math.pi / 2, 0)
        end
        
        table.insert(AttachmentTable, Attachment)
    end
    return AttachmentTable
end

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    task.wait(.35)

    local TargetPart = Instance.new("Part")
    TargetPart.Name = "TargetPart"
    TargetPart.CFrame = pos.CFrame * CFrame.new(0,30,0)
    TargetPart.CanCollide = false
    TargetPart.Anchored = true
    TargetPart.Transparency = 1
    TargetPart.Parent = workspace.CurrentCamera
    
    local TrailParts = CreateFullCircle(pos, 40, 30, "Part")
    local Attachments1 = CreateFullCircle(TargetPart, 40, 0.001, "Attachment")

    local CFrames = {}

    for i, v in pairs(TrailParts) do
        local IndexAttachment = Attachments1[i]
        local Info = TweenInfo.new(Rand:NextInteger(.35, .55), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        CFrames[v] = v.CFrame

        v.CFrame = TargetPart.CFrame
        TweenService:Create(v, Info, {CFrame = CFrames[v]}):Play()

        local Attachment0 = Instance.new("Attachment")
        Attachment0.Parent = v

        local Attachment1 = Instance.new("Attachment")
        Attachment1.Position = Vector3.new(.225, 0,0)
        Attachment1.Parent = v


        local Trail = script.BirdcageTrail:Clone()
        Trail.Trail.Attachment0 = Attachment0
        Trail.Trail.Attachment1 = Attachment1
        Trail.Parent = Attachment0


        local Beam = Instance.new("Beam")
        Beam.Attachment0 = IndexAttachment
        Beam.Attachment1 = Attachment0
        Beam.Width0 = 0
        Beam.Width1 = 0
        Beam.FaceCamera = true
        Beam.LightInfluence = 0 
        Beam.Brightness = 2
        Beam.Segments = 100
        Beam.Parent = Attachment0

        TweenService:Create(Beam, TweenInfo.new(.35), {Width0 = 0.1, Width1 = 0.1}):Play()

        TweenService:Create(Beam, TweenInfo.new(Rand:NextInteger(.35,.45), Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CurveSize0 = (45 * 4)/3}):Play()

        task.delay(.45, function()
            TweenService:Create(IndexAttachment, TweenInfo.new(.75, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Orientation = IndexAttachment.Orientation + Vector3.new(0,270,0)}):Play()

            task.wait(0.35)

            TweenService:Create(v, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = v.CFrame * CFrame.new(-17.5, 0, 0)}):Play()
            TweenService:Create(Beam, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CurveSize0 = ( (36 * 4 / 3) )}):Play()
            TweenService:Create(TargetPart, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {CFrame = TargetPart.CFrame * CFrame.new(0, 40, 0)}):Play()

            task.wait(0.2)
            TweenService:Create(Beam, TweenInfo.new(0.35), {Brightness = 15}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.35), {LightEmission = .5}):Play()
            TweenService:Create(TargetPart, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CFrame = TargetPart.CFrame * CFrame.new(0, 25, 0)}):Play()
            TweenService:Create(Beam, TweenInfo.new(0.85, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CurveSize0 = ( (4 * 4 / 3) )}):Play()

            task.wait(0.45)
            TweenService:Create(TargetPart, TweenInfo.new(.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CFrame = TargetPart.CFrame * CFrame.new(0, -85, 0) }):Play()
            TweenService:Create(Beam, TweenInfo.new(.5), {Width0 = 0, Width1 = 0}):Play()
            IndexAttachment.Orientation = Vector3.new(0, -250, 0)


    

        end)

        VFXModule.Debris(Beam, 5)
        VFXModule.Debris(IndexAttachment,8)
        VFXModule.Debris(v, 8)
    end

    task.wait(1.5)

    local Hit = script.Explosion:Clone()
    Hit.CFrame = pos.CFrame * CFrame.new(0, -1.5, 0)
    Hit.Parent = workspace.CurrentCamera
    VFXModule.Debris(Hit, 3)
    VFXModule.Emit(Hit)
    VFXModule.GroundExpandV2(pos.CFrame, 12, 12, {baseDestroyWait = 1.5, expandTime = .2})
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
