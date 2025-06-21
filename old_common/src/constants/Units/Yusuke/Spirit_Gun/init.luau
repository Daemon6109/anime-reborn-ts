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
	HitDelay = .9, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	local animation = humanoid:LoadAnimation(AnimModule.GetAnim(script.firstattack))
	animation:AdjustSpeed(.8)
	animation:Play()
	

	local sound = SoundWrapper:PlaySound(script:FindFirstChild("1"), rt, game.ReplicatedStorage.SoundGroups.UnitSFX, {Volume = 1, PlayOnRemove = true}, false)
	sound:Destroy()

	
	local charge = script.YusukeCharge:Clone() -- vfx
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + (rt.CFrame.LookVector * 1) + Vector3.new(0,.2,0)
	emit.enablevfx(charge,true)
	debris.AddItem(charge,3)


	task.spawn(function()
		for i=0,5,1 do
			emit.bezier(charge.CFrame,ColorSequence.new(Color3.fromRGB(57, 120, 255)),0.00000000005,.5,"Mid",true,5,.5,2.6)
			task.wait(.1)
		end
	end)
	
	task.wait(.6)
	
	local shot = script.Spiritgun:Clone() -- vfx
	shot.Parent = workspace.Effects
	shot.CFrame = rt.CFrame + (rt.CFrame.LookVector * 0.2) + Vector3.new(0,.2,0)
	debris.AddItem(shot,2)

	shot.End.WorldCFrame = pos.CFrame
	
	emit.emitvfx(shot)
	
	emit.emitvfx(unit.Torso.jump)
	
	emit.enablevfx(charge,false)

	task.wait(.6)
	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
