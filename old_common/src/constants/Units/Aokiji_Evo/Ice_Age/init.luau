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
	HitDelay = 1.4, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.2, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.enablevfx(unit["Right Leg"].Aokojicharge,true)
	emit.emitvfx(unit["Right Leg"].Aokojicharge)
	
	task.wait(.2)
	
	task.spawn(function()
		for i=0,4,1 do
			task.wait(.06)
			emit.bezier(unit["Right Leg"].Aokojicharge.WorldCFrame,ColorSequence.new(Color3.fromRGB(34, 152, 255)),0.00000000005,.5,"Long",true,5,.5,1.6)
		end
	end)
	
	task.wait(.93)
	
	
	
	local Impact = script["Ice age"]:Clone()
	Impact.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * .3) + Vector3.new(0,-1.5,0)
	Impact.Parent = effectsfolder
	debris.AddItem(Impact,3)
	emit.emitvfx(Impact)
	
	local Ice = script["Retopo_Cube_002"]:Clone()
	Ice.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * .3) + Vector3.new(0,-1.5,0)
	Ice.ice2.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * .3) + Vector3.new(0,-1.5,0)
	
	local oldsize = Ice.Size
	Ice.Size = Vector3.new(0,0,0)
	local TweenComplete = tween_service:Create(Ice,TweenInfo.new(.25,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = oldsize})
	TweenComplete:Play()
	
	local oldsize = Ice.ice2.Size
	Ice.ice2.Size = Vector3.new(0,0,0)
	local TweenComplete = tween_service:Create(Ice.ice2,TweenInfo.new(.13,Enum.EasingStyle.Quart,Enum.EasingDirection.In,0),{Size = oldsize})
	TweenComplete:Play()
	
	Ice.Parent = effectsfolder
	debris.AddItem(Ice,3)
	emit.emitvfx(Ice)
	emit.enablevfx(Ice,true)
	
	emit.enablevfx(unit["Right Leg"].Aokojicharge,false)
	emit.emitvfx(unit["Right Leg"].Aokojicharge)
	
	task.wait(1)
	emit.emitvfx(Impact)
	emit.emitvfx(Ice)
	emit.enablevfx(Ice,false)
	task.wait(.1)	
		
	Ice.Transparency = 1
	Ice.ice2.Transparency = 1

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
