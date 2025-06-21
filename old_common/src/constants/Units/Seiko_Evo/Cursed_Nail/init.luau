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
	HitDelay = .7, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local animm = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local Length = (rt.Position - pos.Position).magnitude - 1
	local back = rt.CFrame

	unit["Left Arm"].Nail3.Transparency = 0
		

	task.wait(.25)


	local Nail2 = script.Nail:Clone() 
	Nail2.Parent = workspace.Effects
	Nail2.CFrame = unit["Left Arm"].Nail3.CFrame
	unit["Left Arm"].Nail3.Transparency = 1
	debris.AddItem(Nail2,3)
	emit.enablevfx(Nail2,true)

	local PointA = Nail2.CFrame 
	local PointB = rt.CFrame + (rt.CFrame.LookVector * .3)+ (rt.CFrame.RightVector * -.1) + Vector3.new(0,3.5,0)
	local PointC = rt.CFrame + (rt.CFrame.LookVector * .5)+ (rt.CFrame.RightVector * .35) + Vector3.new(0,.3,0)


	local TweenComplete = tween_service:Create(Nail2,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Orientation =Vector3.new(math.random(0,360),math.random(0,360),math.random(0,360))})
	TweenComplete:Play()

	task.spawn(function()
		for d=0,1,.075 do
			Nail2.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))
			wait(0.005)
			
			
		end						
	
		local send = script.NailSend:Clone()
		send.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1.3)+ (rt.CFrame.RightVector * .5) + Vector3.new(0,.5,0)
		send.Parent = effectsfolder
		debris.AddItem(send,3)
		emit.emitvfx(send)

		local TweenComplete = tween_service:Create(Nail2,TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position =pos.Position})
		TweenComplete:Play()
		
		task.wait(.25)

		local Impact = script.NailImpact:Clone()
		Impact.Position = Nail2.Position
		Impact.Parent = effectsfolder
		debris.AddItem(Impact,3)
		emit.emitvfx(Impact)
		emit.enablevfx(Nail2,false)

	end)
	AnimModule.ChangeAnimSpeed(animm,3)

	task.wait(.2)
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2p2, unit, 1.2, "", {Weight = 2.2, Fade = .4})
	task.wait(.16)
	emit.emitvfx(unit.Bat)
	emit.emitvfx(unit.Torso.jump)
	
	
	AnimModule.ChangeAnimSpeed(ANIMM,11)
	
	task.wait(1)

end
	


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
