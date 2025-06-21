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
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .45, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local a = script.Move3:FindFirstChild("a"):Clone()
	a.aa.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	a.Parent = effectsfolder
	debris.AddItem(a,6)

	emit.emitvfx(a)


	wait(1.1)

	spawn(function()

		local slash = script.Move3:FindFirstChild("slash"):Clone()
		slash.Parent = effectsfolder
		slash.Part.CFrame = rt.CFrame * CFrame.new(0,1,.5)
		debris.AddItem(slash,4)

		tween_service:Create(slash.Part, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,1.5,-15)}):Play()
		wait(.375)

		emit.emitvfx(slash.Part)

		tween_service:Create(slash.Part.aa, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()
		tween_service:Create(slash.Part.bb, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()
		tween_service:Create(slash.Part.cc, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()
		tween_service:Create(slash.Part.dd, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()

		emit.enablevfx(slash,false)

	end)

	wait(0.4)


	spawn(function()

		local slash = script.Move3:FindFirstChild("slash1"):Clone()
		slash.Parent = effectsfolder
		slash.Part.CFrame = rt.CFrame * CFrame.new(0,1,0.5)
		debris.AddItem(slash,4)

		tween_service:Create(slash.Part, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,1.5,-15)}):Play()
		wait(.5)


		emit.emitvfx(slash.move21.Emithere)
		emit.emitvfx(slash.move21.Emithere)

		tween_service:Create(slash.Part.aa, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()
		tween_service:Create(slash.Part.bb, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()
		tween_service:Create(slash.Part.cc, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()
		tween_service:Create(slash.Part.dd, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0,Width1 = 0}):Play()

		emit.enablevfx(slash,false)

	end)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
