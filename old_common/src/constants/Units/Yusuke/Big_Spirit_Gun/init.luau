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
	HitDelay = 1.65, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Secondatack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)

	local charge = script.YusukeChargeBig:Clone() -- vfx
	debris.AddItem(charge,3)
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + (rt.CFrame.LookVector * 1.3) + Vector3.new(0,.2,0)
	emit.enablevfx(charge,true)

	for i=0,5,1 do
		task.wait(.1)
		emit.bezier(charge.CFrame,ColorSequence.new(Color3.fromRGB(57, 120, 255)),0.00000000005,.5,"Mid",true,5,.5,2.6)
	end

	local bigball = script.YusukeBall:Clone() -- vfx
	debris.AddItem(bigball,3)
	bigball.Parent = workspace.Effects
	bigball.CFrame = rt.CFrame + (rt.CFrame.LookVector * 2.5) + Vector3.new(0,.2,0)
	emit.emitvfx(charge.Emit)
	emit.enablevfx(bigball,true)
	emit.emitvfx(bigball.B)
	

	emit.enablevfx(charge,false)
	
	
	task.wait(.23)
	emit.emitvfx(bigball.B.Emit)

	emit.emitvfx(unit.Torso.jump)

	local info = TweenInfo.new(.4,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(bigball,info,{Position = pos.Position}) -- tween to go to the pos
	tween:Play()
	
	task.wait(.15)
	
	local send = script.SpiritgunBigSend:Clone() -- 
	debris.AddItem(send,2)
	send.Parent = workspace.Effects
	send.CFrame = rt.CFrame + (rt.CFrame.LookVector * 4.3) + Vector3.new(0,.2,0)
	emit.emitvfx(send)


	task.wait(.255)
	emit.enablevfx(bigball,false)

	emit.emitvfx(bigball.Start)
	emit.emitvfx(bigball.Impacted)


	task.wait(.6)





end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
