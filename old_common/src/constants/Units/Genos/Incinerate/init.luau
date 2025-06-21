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
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Atk2"], rt, Replicated.SoundGroups.UnitSFX)
	
	local effectsfolder = workspace.Effects
	
	local FinalImpact = script:FindFirstChild("FinalImpact"):Clone()
	FinalImpact.RootPart.CFrame = rt.CFrame * CFrame.new(0,-0.4,-1.7)
	debris.AddItem(FinalImpact,5)

	local root1 = script:FindFirstChild("root1"):Clone()
	root1.CFrame = rt.CFrame * CFrame.new(0,-0.4,-1.7)
	root1.Parent = effectsfolder
	debris.AddItem(root1,5)

	local Part = script:FindFirstChild("Part"):Clone()
	Part.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	Part.Parent = effectsfolder
	debris.AddItem(Part,5)

	task.wait(0.2)

	unit["Left Arm"].Attachment.ParticleEmitter.Enabled = true

	emit.enablevfx(Part,true)

	task.wait(0.5)

	unit["Left Arm"].Attachment.ParticleEmitter.Enabled = false

	FinalImpact.Parent = effectsfolder

	emit.emitvfx(root1)

	local shoottween = tween_service:Create(FinalImpact.RootPart.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Range = 12}):Play()

	spawn(function()
		local maxSize = 1
		-- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.2 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.2 * maxSize -- Função de interpolação cúbica
			FinalImpact:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)



	task.wait(1.2)


	emit.enablevfx(Part,false)

	emit.enablevfx(FinalImpact,false)

	local shoottween = tween_service:Create(FinalImpact.RootPart.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

	for i, v in pairs(FinalImpact.RootPart.Beam:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
