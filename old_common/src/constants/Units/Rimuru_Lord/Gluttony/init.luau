local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	
	local effectsfolder = workspace.Effects
		
	local winds1 = script.winds1:Clone()    
	winds1.CFrame = rt.CFrame * CFrame.new(0,-1.3,0)
	winds1.Parent = workspace.Effects
	debris.AddItem(winds1,4)

	local ex = script.ExplosionImpact:Clone()    
	ex.CFrame = rt.CFrame * CFrame.new(0,-1.2,0)
	ex.Parent = effectsfolder
	debris.AddItem(ex,4)

	local move33 = script.fmove3:Clone()    
	move33.CFrame = rt.CFrame * CFrame.new(0,-1.2,0)
	move33.Parent = effectsfolder
	debris.AddItem(move33,5)

	SoundWrapper:PlaySound(script["earthpass1"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.4)

	SoundWrapper:PlaySound(script["magic-cast-heavy03"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(unit["Right Arm"].emit)

	emit.enablevfx(unit["Right Arm"].Attachment,true)

	wait(0.35)

	SoundWrapper:PlaySound(script["fire-ignite1"], rt, Replicated.SoundGroups.UnitSFX)

	SoundWrapper:PlaySound(script["magic-charge04"], rt, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(winds1,true)

	local move3 = script.move3:Clone()
	move3.RootPart.CFrame = rt.CFrame * CFrame.new(0.5,0,-1)
	move3.Parent = effectsfolder
	debris.AddItem(move3,4)

	spawn(function()
		local maxSize = 1 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.4 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.4 * maxSize -- Função de interpolação cúbica
			move3:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	wait(2.25)

	emit.enablevfx(unit["Right Arm"].Attachment,false)
	emit.enablevfx(winds1,false)

	emit.enablevfx(move3,false)


	spawn(function()

		for _, v in ipairs(move3.beam.Part10:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part9:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(0.05)

		for _, v in ipairs(move3.beam.Part8:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part7:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.Part1.Attachment1:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end


		for _, v in ipairs(move3.beam.Part6:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part5:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part4:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part3:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part2:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end

		wait(.05)

		for _, v in ipairs(move3.beam.Part1:GetDescendants()) do
			if v:IsA("Beam") then
				tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
			end
		end
	end)

	wait(0.15)

	emit.emitvfx(move33)

	emit.emitvfx(ex)

	SoundWrapper:PlaySound(script["magic-charge04"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(unit["Right Arm"].emit)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
