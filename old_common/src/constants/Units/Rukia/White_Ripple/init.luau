local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.6, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .6, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	local SavedDirection = rt.CFrame.LookVector
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local back = unit.back

	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	back.CFrame = CFrame.new(back.Position, pos.Position)
	

	local Move3 = script.Move3:FindFirstChild("Move3"):Clone()
	Move3.Parent = workspace.Effects
	debris.AddItem(Move3,6)

	local trail1 = script.Move3.Trail:Clone()
	trail1.Parent = workspace.Effects

	debris.AddItem(trail1,6)


	local p = script.Move3.Part:Clone()
	p.Parent = workspace.Effects
	debris.AddItem(p,5)

	local aa = script.Move3.aa:Clone()
	aa.Parent = workspace.Effects
	aa.CFrame = rt.CFrame * CFrame.new(0,-1.3,0)
	debris.AddItem(aa,5)

	local bb = script.Move3.bb:Clone()
	bb.Parent = workspace.Effects
	bb.CFrame = rt.CFrame * CFrame.new(0,0,-2)
	debris.AddItem(bb,5)

	local dash = script.Move3.dash:Clone()
	dash.Parent = workspace.Effects
	dash.CFrame = rt.CFrame * CFrame.new(0,0,-1)
	debris.AddItem(dash,6)

	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.5)




	emit.emitvfx(bb)

	wait(0.6)


	wait(0.1)




	emit.emitvfx(aa)

	tween_service:Create(rt, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = pos.CFrame + (rt.CFrame.LookVector * 2)}):Play()

	emit.emitvfx(dash)



	wait(0.2)



	p.CFrame = pos.CFrame

	emit.emitvfx(p)


	wait(0.25)

	trail1.Position = pos.Position + Vector3.new(0,-1,0)

	wait()

	local emitters = trail1:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("Trail") then
			emitters[i].Enabled = true
		end
	end

	emit.enablevfx(trail1,true)

	tween_service:Create(trail1,TweenInfo.new(.8),{Position = trail1.Position + Vector3.new(0,10.5,0)}):Play()
	tween_service:Create(trail1,TweenInfo.new(.8),{Orientation = Vector3.new(0,600,0)}):Play()

	Move3.rootpart.CFrame = pos.CFrame * CFrame.new(0,-1,0)


	emit.emitvfx(Move3)



	wait(1)



	emit.enablevfx(trail1,false)

	rt.CFrame = back.CFrame

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
