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
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .18, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})


	emit.enablevfx(unit["Left Arm"].Attachment,true)
	emit.enablevfx(unit["Right Arm"].Attachment,true)
	local Transparencyshoottween = tween_service:Create(unit.Handle,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Transparency = 0}):Play()
	local Transparencyshoottween = tween_service:Create(unit.Head.Fkhead1.face,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Transparency = 1}):Play()


	emit.emitvfx(unit.Head.Attachment)


	local model = script.Move2:FindFirstChild("Model"):Clone()
	model.Part.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	model.Parent = workspace.Effects
	debris.AddItem(model,4)

	local ExplosionImpact12 = script.Move2:FindFirstChild("ExplosionImpact12"):Clone()
	ExplosionImpact12.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	ExplosionImpact12.Parent = workspace.Effects
	debris.AddItem(ExplosionImpact12,4)

	SoundWrapper:PlaySound(script["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.65)

	SoundWrapper:PlaySound(script["magic-charge22"], rt, Replicated.SoundGroups.UnitSFX)


	spawn(function()
		local maxSize = .75*2
		-- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.25 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Função de interpolação cúbica
			model:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	spawn(function()
		for i = 1,18 do
			task.wait(0.05)

			SoundWrapper:PlaySound(script["swoosh-long1"], rt, Replicated.SoundGroups.UnitSFX)

		end
	end)

	task.wait(.85)

	SoundWrapper:PlaySound(script["magic-charge22"], rt, Replicated.SoundGroups.UnitSFX)
	emit.emitvfx(ExplosionImpact12)

	emit.enablevfx(model,false)

	for i, v in pairs(model.Room:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end

	local Transparencyshoottween = tween_service:Create(model.Part,TweenInfo.new(0.4,Enum.EasingStyle.Elastic, Enum.EasingDirection.Out,0,false,0),{Size = Vector3.new(0,0,0)}):Play()

	wait(0.2)

	SoundWrapper:PlaySound(script["cape2"], rt, Replicated.SoundGroups.UnitSFX)

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
