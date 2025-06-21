local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})

	local sounds = script.Parent.SFXs
	local effectsfolder = workspace.Effects

	SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)


	local Ground = script.Move2:FindFirstChild("grdash"):Clone()
	Ground.CFrame = rt.CFrame * CFrame.new(0,-.8,0)
	Ground.Parent = effectsfolder
	debris.AddItem(Ground,4.25)

	local ExplosionImpact1 = script.Move2:FindFirstChild("ExplosionImpact1"):Clone()
	ExplosionImpact1.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	ExplosionImpact1.Parent = effectsfolder
	debris.AddItem(ExplosionImpact1,5.25)

	local grdash1 = script.Move2:FindFirstChild("grdash1"):Clone()
	grdash1.CFrame = rt.CFrame * CFrame.new(0,-.8,0)
	grdash1.Parent = effectsfolder
	debris.AddItem(grdash1,5.25)

	local Part = script.Move2:FindFirstChild("Part"):Clone()
	Part.Parent = effectsfolder
	debris.AddItem(Part,5.25)

	wait(0.36)

	SoundWrapper:PlaySound(sounds["magic-cast-a10"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(Ground)

	wait(0.2)

	spawn(function()
		for i = 1,8 do
			task.wait(0.1)
			emit.emitvfx(unit["Right Arm"])
			SoundWrapper:PlaySound(sounds["swoosh-short2"], rt, Replicated.SoundGroups.UnitSFX)
		end

	end)

	wait(0.9)



	emit.emitvfx(Part)

	Part.CFrame = unit.Head.CFrame
	Part.CFrame = CFrame.new(Part.Position, pos.Position)

	local Katon = script.Move2:FindFirstChild("Katon"):Clone()
	Katon.part.CFrame = unit.Head.CFrame
	Katon.Parent = effectsfolder
	debris.AddItem(Katon,4.25)

	spawn(function()
		local maxSize = .65 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.05 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.05 * maxSize -- Função de interpolação cúbica
			Katon:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)
	tween_service:Create(Katon.FireBall.PointLight,TweenInfo.new(.25),{Range = 20}):Play()
	wait()



	local shoottween = tween_service:Create(Katon.part, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame = ExplosionImpact1.CFrame}):Play()

	SoundWrapper:PlaySound(sounds["fire-ignite2"], Katon.part, Replicated.SoundGroups.UnitSFX)

	wait(0.5)

	emit.enablevfx(Katon,false)

	tween_service:Create(Katon.FireBall.PointLight,TweenInfo.new(.25),{Range = 0}):Play()

	SoundWrapper:PlaySound(sounds["magic-cast-heavy04"], ExplosionImpact1, Replicated.SoundGroups.UnitSFX)

	local trail1 = script.Move2.Trail:Clone()
	trail1.Parent = workspace
	trail1.Position = ExplosionImpact1.Position
	debris.AddItem(trail1,4)

	tween_service:Create(trail1,TweenInfo.new(1),{Position = trail1.Position + Vector3.new(0,8.5,0)}):Play()
	tween_service:Create(trail1,TweenInfo.new(1),{Orientation = Vector3.new(0,600,0)}):Play()

	emit.emitvfx(ExplosionImpact1)

	emit.enablevfx(Katon,false)



	emit.emitvfx(grdash1)


	wait(0.85)



	emit.enablevfx(trail1,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
