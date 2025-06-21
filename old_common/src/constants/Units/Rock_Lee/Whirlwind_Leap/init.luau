local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local sfx = script.Parent.SFXs


module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .75, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back
	back.CFrame = CFrame.new(back.Position, pos.Position)
	back.CFrame = CFrame.new(back.Position, pos.Position)

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	SoundWrapper:PlaySound(script["Atk1"], rt, Replicated.SoundGroups.UnitSFX)

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})


	local tpskill = script:FindFirstChild("tpskill"):Clone()
	tpskill.Parent = effectsfolder
	tpskill.HumanoidRootPart.CFrame = rt.CFrame
	debris.AddItem(tpskill,2)

	local smokeimpact = script:FindFirstChild("smokeimpact"):Clone()
	smokeimpact.Parent = effectsfolder
	debris.AddItem(smokeimpact,6)

	local a = script:FindFirstChild("smokeimpact1"):Clone()
	a.Parent = effectsfolder
	debris.AddItem(a,6)

	local explosionfire = script:FindFirstChild("explosionfire"):Clone()
	explosionfire.Parent = effectsfolder
	debris.AddItem(explosionfire,6)

	local dash1 = script:FindFirstChild("dash1"):Clone()
	dash1.Parent = effectsfolder
	debris.AddItem(dash1,6)

	local p = script:FindFirstChild("Part"):Clone()
	p.Parent = effectsfolder
	debris.AddItem(p,6)
	p.CFrame = rt.CFrame
	local partAA = rt
	local partBB = p

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = partAA
	weld.Part1 = partBB
	weld.Parent = unit.HumanoidRootPart
	debris.AddItem(weld,5)

	wait()
	emit.emitvfx(tpskill)
	

	rt.CFrame = pos.CFrame
	wait(.01)

	smokeimpact.CFrame = pos.CFrame * CFrame.new(0,-.75,0)
	a.CFrame = pos.CFrame * CFrame.new(0,-.75,0)
	emit.emitvfx(tpskill)
	wait(.2)
	dash1.CFrame = pos.CFrame * CFrame.new(0,6,0)
	local emitters = p:GetDescendants()
	for i = 1, #emitters do	
		if emitters[i]:IsA("ParticleEmitter") then
			emitters[i].Enabled = true
		end
	end

	tween_service:Create(rt, TweenInfo.new(.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = pos.CFrame * CFrame.new(0,6,0)}):Play()
	emit.emitvfx(smokeimpact)
	

	wait(.2)
	spawn(function()
		for i = 1,3 do
			wait(0.15)
			SoundWrapper:PlaySound(sfx["Flame Licks 3 (SFX)"], rt, Replicated.SoundGroups.UnitSFX)
		end
	end)
	a.tt.ParticleEmitter:Emit(3)
	wait(.6)
	emit.emitvfx(dash1)

	explosionfire.CFrame = pos.CFrame * CFrame.new(0,-.75,0)

	tween_service:Create(rt, TweenInfo.new(.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = pos.CFrame}):Play()
	wait(.175)



	local emitters = p:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("ParticleEmitter") then
			emitters[i].Enabled = false
		end
	end

	emit.emitvfx(explosionfire)

	wait(.4)
	emit.emitvfx(tpskill)
	rt.CFrame = back.CFrame

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
