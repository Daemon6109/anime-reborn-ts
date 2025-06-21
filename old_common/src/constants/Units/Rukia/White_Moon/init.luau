local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.8, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})


	SoundWrapper:PlaySound(script["move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local ice = script.Move2:FindFirstChild("icespike"):Clone()
	ice.root.CFrame = rt.CFrame * CFrame.new(0,-1.5,-4)
	ice.Parent = workspace.Effects
	debris.AddItem(ice,5)

	local dash = script.Move2:FindFirstChild("dash"):Clone()
	dash.CFrame = rt.CFrame * CFrame.new(0,0,-1)
	dash.Parent = workspace.Effects
	debris.AddItem(dash,5)

	local Model = script.Move2:FindFirstChild("Model"):Clone()
	Model.rootpart.CFrame = rt.CFrame * CFrame.new(0,-1.5,-2.4)
	Model.Parent = workspace.Effects
	debris.AddItem(Model,5)


	wait(0.5)


	for _, v in ipairs(unit.swrd.beam:GetDescendants()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 1, Width1 = 1}):Play()
		end
	end

	local trail1 = script.Move2.Trail:Clone()
	trail1.Parent = workspace.Effects
	trail1.Position = rt.Position + Vector3.new(0,-1,0)
	debris.AddItem(trail1,4)

	tween_service:Create(trail1,TweenInfo.new(1),{Position = trail1.Position + Vector3.new(0,5.5,0)}):Play()
	tween_service:Create(trail1,TweenInfo.new(1),{Orientation = Vector3.new(0,600,0)}):Play()




	tween_service:Create(Model.rootpart.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 12}):Play()

	spawn(function()
		local maxSize = 1 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.3 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.3 * maxSize -- Função de interpolação cúbica
			Model:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	wait(0.8)

	emit.enablevfx(trail1,false)

	wait(0.45)




	for _, v in ipairs(unit.swrd.beam:GetDescendants()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		end
	end

	tween_service:Create(Model.rootpart.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 22}):Play()

	for _, v in ipairs(Model.beam:GetDescendants()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		end
	end



	emit.emitvfx(dash)

	emit.enablevfx(Model,false)

	wait(0.1)



	emit.emitvfx(ice)

	wait(0.25)



	wait(0.25)


	wait(0.75)

	tween_service:Create(Model.rootpart.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 0}):Play()



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
