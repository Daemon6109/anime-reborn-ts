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
	HitDelay = 1.4, -- seconds
	HitCount = 12, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .085, -- delay between hits in a multi-hit move
}

local Rand = Random.new()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

    AnimModule.PlayAnim(script.Anim, unit, 1, "", {Weight = 2, Fade = .15})

    local GroundHit = script.GroundHit:Clone()
	GroundHit.CFrame = CFrame.new(rt.Position) * CFrame.new(0, -1, 0)
    GroundHit.Parent = workspace.Effects
    VFXModule.Emit(GroundHit)
    VFXModule.EffectToggle(GroundHit, true)
    VFXModule.Debris(GroundHit, 5)

    SoundWrapper:PlaySound(script.Dragon, rt)

    task.spawn(function()
		for i=0, 35,1 do
			task.wait(.03)
			emit.bezier(GroundHit.CFrame * CFrame.new(Rand:NextInteger(-17, 17), Rand:NextInteger(2, 16), Rand:NextInteger(-17, 17)) ,ColorSequence.new(Color3.fromRGB(103, 69, 255)),0.00000000005,.5,"Long",true, 5, 0, 5)
		end
	end)

    task.wait(.5)

    for i = 1, 12 do
		local EndPosition = GroundHit.Position + Vector3.new(Rand:NextInteger(-15, 15), 0, Rand:NextInteger(-15, 15))

        local FloorPart = script.FujitoraFloorPart:Clone()
        FloorPart.Position = EndPosition
		FloorPart.Parent = workspace.Effects
		task.spawn(function()
			VFXModule.Debris(FloorPart, 3)
		end)
        task.spawn(function()
            local MeteorModel = script.MeteorModel:Clone()
            local Meteor = MeteorModel.Meteor
			MeteorModel:PivotTo(CFrame.new(EndPosition + Vector3.new(Rand:NextInteger(-15, 15), Rand:NextInteger(38, 54), Rand:NextInteger(-15, 15))))
            MeteorModel.Parent = workspace.Effects
            VFXModule.Debris(MeteorModel, 4)
    
            MeteorModel:ScaleTo(.1)
            VFXModule.EffectToggle(MeteorModel, true)
            -- VFXModule.EffectToggle(Meteor.Crust, false)
    
            for _, v in pairs(Meteor:GetChildren()) do
                if v:IsA("ParticleEmitter") then
                    v.Enabled = false
                end
            end
    
            local NumberValue = Instance.new("NumberValue")
			NumberValue.Value = .1
    
            TweenService:Create(NumberValue, TweenInfo.new(1), {Value = 0.5}):Play()
    
            task.delay(.5, function()
                VFXModule.EffectToggle(MeteorModel, true)
            end)
    
            local SizeConnection
            SizeConnection = RunService.RenderStepped:Connect(function(deltaTime)
                if NumberValue.Value < 0.5 then
                    MeteorModel:ScaleTo(NumberValue.Value)
                else
                    SizeConnection:Disconnect()
                end
            end)
    
            task.wait(1)
            VFXModule.EffectToggle(Meteor.Crust, true)   
            TweenService:Create(Meteor, TweenInfo.new(.45, Enum.EasingStyle.Quad), {CFrame = FloorPart.CFrame}):Play()
            SoundWrapper:PlaySound(script.Blast, rt)
    
            task.wait(.45)
            SoundWrapper:PlaySound(script.Burst, rt)
            SoundWrapper:PlaySound(script.Impact, rt)

            VFXModule.Emit(FloorPart)
            VFXModule.GroundExpandV2(FloorPart.CFrame, 5, 6, {baseDestroyWait = 1.5, expandTime = .2})
            VFXModule.EffectToggle(MeteorModel, false)
            VFXModule.EffectToggle(FloorPart, false)
            TweenService:Create(Meteor, TweenInfo.new(.5), {Transparency = 1}):Play()
            TweenService:Create(Meteor.Crust, TweenInfo.new(.5), {Transparency = 1}):Play()
        end)

        task.wait(.2)
    end

    VFXModule.EffectToggle(GroundHit, false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
