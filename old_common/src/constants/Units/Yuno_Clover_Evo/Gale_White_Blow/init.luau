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
	HitDelay = 1.4, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .175, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local a = script.Move2:FindFirstChild("a"):Clone()
	a.aa.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	a.Parent = effectsfolder
	debris.AddItem(a,6)


	emit.emitvfx(a)



	wait(0.5)

	local Highlight = Instance.new("Highlight")
	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 1
	Highlight.OutlineColor = Color3.fromRGB(96, 255, 149)
	Highlight.FillColor = Color3.fromRGB(96, 255, 149)
	Highlight.Parent = unit
	debris.AddItem(Highlight, 2)

	tween_service:Create(Highlight, TweenInfo.new(0.175, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {OutlineTransparency = 0}):Play()


	emit.enablevfx(unit["Left Arm"].Attachment)

	wait(0.75)




	tween_service:Create(Highlight, TweenInfo.new(0.175, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {OutlineTransparency = 1}):Play()

	local eemitslash = script.Move2:FindFirstChild("eemitslash"):Clone()
	eemitslash.CFrame = rt.CFrame * CFrame.new(0,-1,-1.75)
	eemitslash.Parent = effectsfolder
	debris.AddItem(eemitslash,6)

	local eemitslash1 = script.Move2:FindFirstChild("eemitslash1"):Clone()
	eemitslash1.CFrame = pos.CFrame * CFrame.new(0,-1,-0)
	eemitslash1.Parent = effectsfolder
	debris.AddItem(eemitslash1,6)

	local Model = script.Move2:FindFirstChild("Model"):Clone()
	Model.root.CFrame = rt.CFrame * CFrame.new(0,-1,-1.75)
	Model.Parent = effectsfolder
	debris.AddItem(Model,6)

	emit.emitvfx(eemitslash)


	spawn(function()

		local maxSize = 1.2 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = .25 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^.25 * maxSize -- Função de interpolação cúbica
			Model:ScaleTo(smoothScale)
			task.wait(interval)
		end

	end)

	local rocketpos = Model.root.Position
	local enemypos = pos.Position + Vector3.new(0, -1, 0)

	local magnitude = (rocketpos - enemypos).magnitude
	local Step = 60

	local Time = math.random(-66, 66) / 100
	local Time2 = math.random(0, 0) / 200
	local ZigZagAmplitude = 2.5
	local ZigZagFrequency = 0.1

	local direction = (enemypos - rocketpos).unit -- calcula a direção para enemypos

	spawn(function()
		for i = 1, Step do
			-- Atualiza a posição do Model.root usando a direção calculada
			Model.root.CFrame = Model.root.CFrame + direction * (magnitude / Step)
			game:GetService("RunService").Heartbeat:Wait()
		end
		Model.Part1.Attachment.a:Emit(1)
	end)



	wait(1)


	emit.emitvfx(eemitslash1)

	for _, v in ipairs(Model.beam:GetDescendants()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		end
	end


	emit.enablevfx(Model,false)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
