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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.emitvfx(unit.Torso.TP)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * -1.5)
	task.wait(.05)
	emit.emitvfx(unit.Torso.TP)

	emit.enablevfx(unit["Left Arm"].Aokojicharge,true)
	emit.emitvfx(unit["Left Arm"].Aokojicharge)
	
	task.spawn(function()
		for i=0,4,1 do
			task.wait(.06)
			emit.bezier(unit["Left Arm"].Aokojicharge.WorldCFrame,ColorSequence.new(Color3.fromRGB(34, 152, 255)),0.00000000005,.5,"Long",true,5,.5,1.6)
		end
	end)	
	
	task.wait(.65)
	
	local Impactgrnd = script["Suffocation"]:Clone()
	Impactgrnd.Parent = effectsfolder
	Impactgrnd.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5)+ (rt.CFrame.RightVector * -.5) + Vector3.new(0,-1.3,0)
	debris.AddItem(Impactgrnd,6)
	emit.emitvfx(Impactgrnd)
	
	emit.enablevfx(unit["Left Arm"].Aokojicharge,false)
	task.wait(.9)

	emit.emitvfx(unit.Torso.TP)
	rt.CFrame = startpos
	task.wait(.05)
	emit.emitvfx(unit.Torso.TP)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
