local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(script.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local spr = require(game.ReplicatedStorage.Libs.emit.spr)
local rocksmodule = require(game.ReplicatedStorage.Libs.RocksModule)

module.config = {
	HitDelay = 2.05, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame


	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.attk4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4"], rt, Replicated.SoundGroups.UnitSFX)
	


	local atk4 = script:FindFirstChild("attack4"):Clone()
	atk4.root.CFrame = rt.CFrame * CFrame.new(0,0.3,-1.2)
	atk4.Parent = effectsfolder
	debris.AddItem(atk4,5)


	emit.emitvfx(atk4)
	
	task.wait(1.85)
		
	emit.enablevfx(atk4.end1,true)

	wait(.55)

	for i, v in pairs(atk4.end1.End:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.25,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
