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
	HitDelay = 1.3, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
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
	
	rt.CFrame = CFrame.lookAt(rt.Position * Vector3.new(1,0,1), pos.Position * Vector3.new(1,0,1))
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	unit.Torso.tp:Emit(15)
	task.wait(.12)
	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + Vector3.new(0,13,0)
	task.wait(.03)
	unit.Torso.tp:Emit(15)

	rt.CFrame = CFrame.new(rt.Position, pos.Position)


	local Charge = script.Charge:Clone()
	Charge.Position = rt.Position + Vector3.new(0,-1.3,0)
	debris.AddItem(Charge,6)
	Charge.Parent = effectsfolder
	emit.enablevfx(Charge,true)
	emit.emitvfx(Charge.Attachment)

	local a = tween_service:Create(Charge,TweenInfo.new(.75,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Orientation = Charge.Orientation + Charge.Orientation + Vector3.new(0,180,0)}):Play()

	task.spawn(function()
		for i=0,7,1 do
			wait(.1)
			emit.bezier(unit.bow.CFrame,ColorSequence.new(Color3.fromRGB(34, 122, 255)),0.0005,1,"Mid",true,5,.7,1.8)
		end
	end)

	task.wait(.74)
	
	
	emit.emitvfx(Charge)
	emit.enablevfx(Charge,false)

	local Shot = script.Shot:Clone()
	Shot.Position = unit["Right Arm"].Position + Vector3.new(0,-.5,0)
	debris.AddItem(Shot,6)
	Shot.Parent = effectsfolder
	emit.emitvfx(Shot)	

	SoundWrapper:PlaySound(script["move1shot"], rt, Replicated.SoundGroups.UnitSFX)

	local Arrow = script.arrow:Clone()
	Arrow.CFrame = unit.bow.CFrame
	debris.AddItem(Arrow,3)
	Arrow.Parent = effectsfolder
	emit.enablevfx(Arrow,true)	
	local SavedDirection = rt.CFrame.LookVector

	local a = tween_service:Create(Arrow,TweenInfo.new(.2,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame =  CFrame.lookAt(pos.Position, pos.Position+SavedDirection)}):Play()

	
	task.wait(.2)

	local Impact = script.Explosion:Clone()
	Impact.Position = Arrow.Position + Vector3.new(0,-1,0)
	debris.AddItem(Impact,6)
	Impact.Parent = effectsfolder
	emit.emitvfx(Impact)	

	Arrow:Destroy()

	wait(.5)
	
	unit.Torso.tp:Emit(15)
	task.wait(.12)
	rt.CFrame = startpos
	task.wait(.03)
	unit.Torso.tp:Emit(15)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
