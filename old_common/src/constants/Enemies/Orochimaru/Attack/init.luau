local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.25, -- seconds
	Duration = .25,
	TurnTime = .7,
	StunTime = 5,
	AttackRange = 35,
	AttackSize = 15,
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	local effectsfolder = workspace.Effects

	--SoundWrapper:PlaySound(sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)




	local ExplosionImpact1 = script.Move2:FindFirstChild("FireballImpact"):Clone()
	ExplosionImpact1.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	ExplosionImpact1.Parent = effectsfolder
	debris.AddItem(ExplosionImpact1,5.25)
	ExplosionImpact1.Anchored = true


	task.wait(0.5)




	local Katon = script.Move2:FindFirstChild("Katon"):Clone()
	Katon.part.CFrame = unit.Head.CFrame
	Katon.Parent = effectsfolder
	debris.AddItem(Katon,5.25)
	emit.enablevfx(Katon,true)
	emit.emitvfx(Katon)
	Katon.part.Anchored = true

	spawn(function()
		local maxSize = .35 -- Defina o tamanho máximo desejado
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
	task.wait()

	local shoottween = tween_service:Create(Katon.part, TweenInfo.new(0.75, Enum.EasingStyle.Sine), {CFrame = ExplosionImpact1.CFrame}):Play()

	task.wait(0.75)

	emit.enablevfx(Katon,false)


	emit.emitvfx(ExplosionImpact1)

	task.wait(0.85)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
