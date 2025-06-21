local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .5, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	
	print("play")
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local back = unit.back
	back.CFrame = CFrame.new(back.Position, pos.Position)

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation4, unit, 1.5, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["Atk3"], rt, Replicated.SoundGroups.UnitSFX)

	
	--.CFrame = rt.CFrame + Vector3.new(0,-10,0)
	
	local hits = script:FindFirstChild("hits"):Clone()
	hits.ground.CFrame = startpos * CFrame.new(0,-1,0)
	hits.Parent = effectsfolder
	debris.AddItem(hits,6.5)

	local tp1 = script:FindFirstChild("tp1"):Clone()
	tp1.CFrame = startpos
	tp1.Parent = effectsfolder
	debris.AddItem(tp1,5)

	wait(0.4)

	local emitters = hits:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("ParticleEmitter") then
			emitters[i].Enabled = true
		end
	end
	
	

	spawn(function()
		for i = 1,14 do
			wait(0.1)
			SoundWrapper:PlaySound(script["hit_punch_h"], rt, Replicated.SoundGroups.UnitSFX)
		end
	end)

	wait(3.2/2)
	local aa = script:FindFirstChild("aa"):Clone()
	aa.CFrame = startpos * CFrame.new(0,-1,0)
	aa.Parent = effectsfolder
	debris.AddItem(aa,3.5)
	wait(0.1)

	--Sound(sounds:FindFirstChild("Jump Swish 1 (SFX)"),rt,1.5)

	emit.emitvfx(aa)
	local emitters = hits:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("ParticleEmitter") then
			emitters[i].Enabled = false
		end
	end
	
	rt.CFrame = startpos
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
