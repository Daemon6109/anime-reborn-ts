local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local SoundWrapper = require(game.ReplicatedStorage.Libs.SoundWrapper)

local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(game.ReplicatedStorage.Libs.emit)

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


module.config = {
	HitDelay = .9, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .55, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	local animation = humanoid:LoadAnimation(AnimModule.GetAnim(script.firstattack))
	animation:Play()

	local sound = SoundWrapper:PlaySound(script:FindFirstChild("1"), rt, game.ReplicatedStorage.SoundGroups.UnitSFX, {Volume = 1, PlayOnRemove = true}, false)
	sound:Destroy()	
	emit.enablevfx(unit["Right Arm"].Actiation,true)

	task.spawn(function()
		for i=0,10,1 do
			wait(.1)
			emit.bezier(unit["Right Arm"].RightGripAttachment.WorldCFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.0005,1,"Mid",true,0,0,1)
			emit.bezier(unit["Left Arm"].LeftGripAttachment.WorldCFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.0005,1,"Mid",true,0,0,1)
		end
	end)


	task.wait(.3)


	local recoil = script.recoil2:Clone() 
	recoil.Parent = workspace.Effects
	recoil.CFrame = rt.CFrame
	emit.emitvfx(recoil)
	debris.AddItem(recoil,2.5)

	local vortex = script.Vortex:Clone()  
	vortex.Parent = workspace.Effects
	vortex.CFrame = rt.CFrame + (rt.CFrame.LookVector * .05) + (pos.CFrame.RightVector * 1)
	emit.enablevfx(vortex,true)
	debris.AddItem(vortex,1.9)

	task.wait(1)
	emit.enablevfx(unit["Right Arm"].Actiation,false)

	emit.enablevfx(vortex,false)
		


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
