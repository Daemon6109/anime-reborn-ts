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
	HitDelay = 1, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.3, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.1)

	emit.emitvfx(unit.Torso.jump)
	
	task.wait(.35)

	for i=0,6,1 do
		task.wait(.1)
		task.spawn(function()

			local Iceshard = script.IceProjectiel:Clone() 
			Iceshard.Parent = workspace.Effects
			Iceshard.Position = pos.Position + Vector3.new(math.random(-5,5),13,math.random(-5,5))
			emit.enablevfx(Iceshard,true)
			emit.emitvfx(Iceshard)
			debris.AddItem(Iceshard,3)	
			
			local start = script.DragonSigil:Clone() 
			start.Parent = workspace.Effects
			start.Position = Iceshard.Position
			emit.emitvfx(start)
			debris.AddItem(start,3)	


			task.wait(.2)


			local TweenComplete = tween_service:Create(Iceshard,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position = Iceshard.Position + Vector3.new(0,-14,0)})
			TweenComplete:Play()

			task.wait(.2)
			emit.enablevfx(Iceshard,false)

			Iceshard.Transparency = 1
			local imp = script.Explosion:Clone()
			imp.Parent = effectsfolder
			imp.Position = Iceshard.Position
			debris.AddItem(imp, 4)
			emit.emitvfx(imp)
		end)
	end
	

	
	
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
