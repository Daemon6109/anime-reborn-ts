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
	HitDelay = 1.2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2"], rt, Replicated.SoundGroups.UnitSFX)
	
	unit["Left Arm"].Machete.Transparency = 0

	for i, v in pairs(unit["Left Arm"].Machete:GetDescendants()) do
		v.Transparency = 0
	end

	local goal = {}
	goal.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -2)
	local info = TweenInfo.new(1.3)
	local tween = game.TweenService:Create(rt,info,goal)
	tween:Play()
	task.delay(1.2,function()
		local Sound = script.Move2:Clone()
		Sound.Parent = rt
		--Sound:Play()
		game.Debris:AddItem(Sound,4)
	end)
	task.wait(1.1)

	local BloodEffect = script.BloodEffect:Clone()
	BloodEffect.Parent = effectsfolder
	BloodEffect.CFrame = rt.CFrame * CFrame.new(0,0,-3)


	for i,v in pairs(BloodEffect:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))

		end

	end
	game.Debris:AddItem(BloodEffect,6)

	local Slash = script.Slash:Clone()
	Slash.Parent = effectsfolder
	Slash.CFrame = rt.CFrame * CFrame.new(0,0,-3)


	for i,v in pairs(Slash:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))

		end

	end
	game.Debris:AddItem(Slash,6)
	
	
	task.wait(.5)
	
	unit["Left Arm"].Machete.Transparency = 1

	for i, v in pairs(unit["Left Arm"].Machete:GetDescendants()) do
		v.Transparency = 1
	end

	unit.Torso.tp:Emit(15)
	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	emit.emitvfx(unit.Torso)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
