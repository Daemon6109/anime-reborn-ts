local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	back.CFrame = CFrame.new(back.Position, pos.Position)
	
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})

	local p = script.Move1:FindFirstChild("purpleexp"):Clone()
	p.a.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	p.slash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	p.Parent = workspace.Effects
	debris.AddItem(p,4)

	local grdash1 = script.Move1:FindFirstChild("grdash1"):Clone()
	grdash1.CFrame = rt.CFrame 
	grdash1.Parent = workspace.Effects
	debris.AddItem(grdash1,4)

	SoundWrapper:PlaySound(script["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	task.spawn(function()
		for i=0,6,1 do
			task.wait(.1)
			emit.bezier(unit.Humanoid.Model["Kaido Weapon1"].CFrame,ColorSequence.new(Color3.fromRGB(115, 34, 255)),0.00000000005,.5,"Mid",true,5,.5,2.6)
			emit.bezier(unit.Humanoid.Model["Kaido Weapon1"].CFrame,ColorSequence.new(Color3.fromRGB(255, 20, 20)),0.00000000005,.5,"Mid",true,5,.5,2.6)
		end
	end)
	SoundWrapper:PlaySound(script["startup"], rt, Replicated.SoundGroups.UnitSFX)
	wait(0.1)

	SoundWrapper:PlaySound(script["body-collapse01"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(grdash1)

	emit.enablevfx(unit.Humanoid.Model["Kaido Weapon1"],true)

	local shoottween = tween_service:Create(unit.Humanoid.Model["Kaido Weapon1"].PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Range = 16}):Play()
	SoundWrapper:PlaySound(script["abyssattack1"], rt, Replicated.SoundGroups.UnitSFX)
	unit.Humanoid.Model["Kaido Weapon"].Transparency = 1

	task.wait(.65)

	SoundWrapper:PlaySound(script["swoosh-long2"], rt, Replicated.SoundGroups.UnitSFX)
	local shoottween = tween_service:Create(unit.Humanoid.Model["Kaido Weapon1"].PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Range = 0}):Play()
	
	emit.emitvfx(p)
	emit.enablevfx(unit.Humanoid.Model["Kaido Weapon1"],false)
	
	wait(0.15)

	SoundWrapper:PlaySound(script["magic-cast-heavy14"], rt, Replicated.SoundGroups.UnitSFX)



	wait(0.1)

	emit.emitvfx(grdash1)
	
	task.wait(1.45)
	
	unit.Humanoid.Model["Kaido Weapon"].Transparency = 0
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
