local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	print(rt.CFrame.Position)

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})

	local move = script.Move1Effect:FindFirstChild("move"):Clone()
	move.CFrame = rt.CFrame * CFrame.new(0,-0.5,0)
	move.Parent = workspace.Effects
	debris.AddItem(move,5)

	local moveD = script.Move1Effect:FindFirstChild("moveD"):Clone()
	moveD.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	moveD.Parent = workspace.Effects
	debris.AddItem(moveD,5)

	SoundWrapper:PlaySound(script["Move1"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.2)


	emit.emitvfx(moveD)

	wait(0.1)



	wait(0.2)


	emit.emitvfx(move)

	wait(0.3)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
