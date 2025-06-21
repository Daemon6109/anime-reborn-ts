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
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .55, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})


	SoundWrapper:PlaySound(script["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	local model = script.Move1:FindFirstChild("Model"):Clone()
	model.rootpart.CFrame = rt.CFrame * CFrame.new(0,0,0)
	model.Parent = workspace.Effects
	debris.AddItem(model,4)


	local a = script.Move1:FindFirstChild("a"):Clone()
	a.CFrame = rt.CFrame * CFrame.new(0,-0.6,0)
	a.Parent = workspace.Effects
	debris.AddItem(a,4)

	local aab = script.Move1:FindFirstChild("aab"):Clone()
	aab.GroundsEffects3.CFrame = rt.CFrame * CFrame.new(0,-0.7,0)
	aab.Parent = workspace.Effects
	debris.AddItem(aab,4)



	emit.enablevfx(unit["Left Arm"].Attachment,true)
	emit.enablevfx(unit["Right Arm"].Attachment,true)
	local Transparencyshoottween = tween_service:Create(unit.Handle,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
	local Transparencyshoottween = tween_service:Create(unit.Head.Fkhead1.face,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()


	emit.emitvfx(unit.Head.Attachment)

	wait(0.6)

	SoundWrapper:PlaySound(script["magic-cast-a01"], rt, Replicated.SoundGroups.UnitSFX)


	emit.emitvfx(a)


	emit.emitvfx(model)

	emit.emitvfx(aab)

	wait(0.5)

	SoundWrapper:PlaySound(script["magic-cast-a01"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(a)

	emit.emitvfx(aab)

	wait(0.5)

	SoundWrapper:PlaySound(script["magic-cast-a01"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(aab)

	emit.emitvfx(a)

	wait(0.2)


	emit.enablevfx(unit["Left Arm"].Attachment,false)
	emit.enablevfx(unit["Right Arm"].Attachment,false)
	local Transparencyshoottween = tween_service:Create(unit.Handle,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()
	local Transparencyshoottween = tween_service:Create(unit.Head.Fkhead1.face,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()

	emit.emitvfx(unit.Head.Attachment)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
