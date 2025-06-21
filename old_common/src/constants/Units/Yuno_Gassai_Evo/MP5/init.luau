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
	HitDelay = .5, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script:WaitForChild("Anim"), unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3"], rt, Replicated.SoundGroups.UnitSFX)
	
	unit["Right Arm"].MP5.Transparency = 0

	
	for i, v in pairs(unit["Right Arm"].MP5:GetDescendants()) do
		v.Transparency = 0
	end


	task.wait(.25)

	local FlashMP5 = script.FlashMP5:Clone()
	FlashMP5.Parent = effectsfolder
	FlashMP5.CFrame = rt.CFrame * CFrame.new(1.2,0,-1)


	for i,v in pairs(FlashMP5:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true

		end

	end
	task.wait(2.5)
	for i,v in pairs(FlashMP5:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false

		end

	end
	unit["Right Arm"].MP5.Transparency = 1


	for i, v in pairs(unit["Right Arm"].MP5:GetDescendants()) do
		v.Transparency = 1
	end
	
	game.Debris:AddItem(FlashMP5,6)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
