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
	HitDelay = 2.6, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
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
	
	AnimModule.PlayAnim(script.attk2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2"], rt, Replicated.SoundGroups.UnitSFX)
	

	task.wait(0.5)

	local kamehameha =  script.attack2:FindFirstChild("KamehamehaGohan"):Clone()
	kamehameha.Parent = effectsfolder
	kamehameha.CFrame = rt.CFrame * CFrame.new(0,0,-1.5)

	debris.AddItem(kamehameha,5)

	local kamehameha1 =  script.attack2:FindFirstChild("slash"):Clone()
	kamehameha1.Parent = effectsfolder
	kamehameha1.CFrame = rt.CFrame * CFrame.new(0,0,-20)

	debris.AddItem(kamehameha1,5)


	for i,v in pairs(unit["Left Arm"].Begin:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end
	task.wait(1.8)
	for i,v in pairs(kamehameha:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end
	for i,v in pairs(kamehameha1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = true
		end
	end

	task.wait(0.1)
	for i,v in pairs(kamehameha:GetDescendants()) do
		if v:IsA("Beam") then
			v.Enabled = true
		end
	end
	task.wait(1.1)
	for i,v in pairs(kamehameha1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
	for i,v in pairs(unit["Left Arm"].Begin:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
	for i,v in pairs(kamehameha:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end
	end
	for i,v in pairs(kamehameha:GetDescendants()) do
		if v:IsA("Beam") then
			v.Enabled = false
		end
	end
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
