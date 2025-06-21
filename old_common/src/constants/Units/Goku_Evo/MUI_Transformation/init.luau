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

function module:Effect(unit : Model)
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local rt = unit.PrimaryPart
	local startpos = rt.CFrame

    SoundWrapper:PlaySound(script.MUI, rt)    

    local CameraRig = script.CameraRig:Clone()
    CameraRig:PivotTo(rt.CFrame * CFrame.new(0, -1.5, 0))
    CameraRig.Parent = workspace.CurrentCamera
    VFXModule.Debris(CameraRig, 10)
		
	AnimModule.PlayAnim(script.CameraCutscene, CameraRig, 1, "", {Weight = 2, Fade = .15})
    AnimModule.PlayAnim(script.Cutscene, unit, 1, "", {Weight = 2, Fade = .15})
	
	local connection
    local Camera = workspace.CurrentCamera
    local CameraCF, CameraFOV = Camera.CFrame, Camera.FieldOfView
	Camera.CameraType = Enum.CameraType.Scriptable
	
	task.delay(7.4, function()
		connection:Disconnect()
		Camera.CameraType = Enum.CameraType.Custom
		Camera.CFrame = CameraCF
		Camera.FieldOfView = CameraFOV
	end)
    
    local elapsed = 0
    local frame = 0
    connection = RunService.RenderStepped:Connect(function(deltatime)
        elapsed += deltatime
        frame += (60 * deltatime)
        Camera.CFrame = CameraRig.CamPart.CFrame
        if script.FOV:FindFirstChild(tostring(frame)) then
            Camera.FieldOfView = script.FOV:FindFirstChild(tostring(frame))
        end
    end)

    task.wait(3.2)
    local Aura = script.Aura:Clone()
    Aura.CFrame = rt.CFrame * CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90))
    Aura.Parent = rt
    VFXModule.Debris(Aura, 12)
    VFXModule.EffectToggle(Aura, true)
    
    task.wait(4)
    connection:Disconnect()
    Camera.CameraType = Enum.CameraType.Custom
    Camera.CFrame = CameraCF
    Camera.FieldOfView = CameraFOV

    task.wait(3)
    VFXModule.EffectToggle(Aura, false)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
