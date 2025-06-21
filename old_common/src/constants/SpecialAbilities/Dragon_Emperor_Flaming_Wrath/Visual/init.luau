local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.1, -- seconds
	HitCount = 20, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .075, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	back.CFrame = CFrame.new(back.Position, pos.Position)
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.JumpAnim, unit, 1, "", {Weight = 2, Fade = .15})
	
	SoundWrapper:PlaySound(script["Bum"], rt, Replicated.SoundGroups.UnitSFX)


	local grdash1 = script.Move6:FindFirstChild("grdash1"):Clone()
	grdash1.CFrame = rt.CFrame * CFrame.new(0,-1.8,0)
	grdash1.Parent = workspace.Effects
	debris.AddItem(grdash1,12)

	wait(0.4)

	emit.emitvfx(grdash1)


	wait(0.25)
	emit.enablevfx(unit,false)


	for i, v in pairs(unit.Humanoid.Model:GetChildren()) do
		if v:IsA("MeshPart") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
		end
	end
	for i, v in pairs(unit.Humanoid.Model:GetChildren()) do
		if v:IsA("Part") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
		end
	end
	for i, v in pairs(unit.Humanoid.Model:GetChildren()) do
		if v:IsA("SpecialMesh") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
		end
	end


	unit.Humanoid.Model.torso1["Torso LP"].Transparency = 1
	unit.Humanoid.Model.hair["Kaido Hair"].Transparency = 1
	unit.Humanoid.Model.cloak["Kaido Cloak"].Transparency = 1

	for i,v in pairs(humanoid:GetPlayingAnimationTracks()) do
		if v == "idle" then
			v:Stop()
		end
	end

	local Kaidodragon = script.Move6:FindFirstChild("KaidoDragon"):Clone()
	Kaidodragon.RootPart.CFrame = rt.CFrame * CFrame.new(0,2,0)
	Kaidodragon.Parent = workspace.Effects
	debris.AddItem(Kaidodragon,11)

	local TransformationVfx = script.Move6:FindFirstChild("TransformationVfx"):Clone()
	TransformationVfx.CFrame = rt.CFrame * CFrame.new(0,-2,0)
	TransformationVfx.Parent = workspace.Effects
	debris.AddItem(TransformationVfx,5)


	local destransform = script.Move6:FindFirstChild("destransform"):Clone()
	destransform.Parent = workspace.Effects
	debris.AddItem(destransform,7)
	destransform.CFrame = Kaidodragon.Head.CFrame * CFrame.new(0,8,0)
	emit.emitvfx(TransformationVfx)

	local animation = Kaidodragon.AnimationController:LoadAnimation(AnimModule.GetAnim(script.DragonAtk)):Play()

	wait(.4)


	local FireBall = script.Move6:FindFirstChild("Model"):Clone()
	FireBall.Parent = workspace.Effects
	debris.AddItem(FireBall,5)

	local light = script.Move6:FindFirstChild("light"):Clone()
	light.Parent = workspace.Effects
	debris.AddItem(light,5)


	local lightnings1 = script.Move6:FindFirstChild("lightnings1"):Clone()
	lightnings1.Parent = workspace.Effects
	debris.AddItem(lightnings1,5)


	local part = script.Move6:FindFirstChild("part"):Clone()
	part.Parent = workspace.Effects
	debris.AddItem(part,5)


	wait(0.5)

	part.CFrame = Kaidodragon.Head.CFrame * CFrame.new(0,10,0)
	FireBall.FireBall.CFrame = Kaidodragon.Head.CFrame * CFrame.new(0,11,-1)
	light.CFrame = Kaidodragon.Head.CFrame * CFrame.new(0,10,0)
	lightnings1.CFrame = Kaidodragon.Head.CFrame * CFrame.new(0,10,0)


	emit.emitvfx(part)
	emit.enablevfx(part,true)

	wait(0.1)

	emit.enablevfx(part,false)

	emit.enablevfx(FireBall,true)
	spawn(function()
		local maxSize = 2
		-- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.25 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Função de interpolação cúbica
			FireBall:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)




	emit.emitvfx(lightnings1,true)

	spawn(function()
		for i = 1,30 do
			task.wait(0.05)
			emit.emitvfx(light)
		end
	end)

	wait(0.05)

	spawn(function()
		for i = 1,75 do

			local emitlightning = script.Move6:FindFirstChild("exp"):Clone()
			emitlightning.CFrame = rt.CFrame * CFrame.new(math.random(-14,14),math.random(-2,-2),math.random(-14,14))
			emitlightning.Parent = workspace.Effects
			debris.AddItem(emitlightning,2.5)



			task.wait(0.015)


			local shoottween = tween_service:Create(emitlightning.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Range = 8}):Play()
			emit.emitvfx(emitlightning)
			local shoottween = tween_service:Create(emitlightning.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0.1),{Range = 0}):Play()


		end

	end)

	wait(1.9)

	emit.enablevfx(lightnings1,false)



	emit.enablevfx(FireBall,false)


	for i, v in pairs(Kaidodragon:GetChildren()) do
		if v:IsA("MeshPart") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
		end
	end
	for i, v in pairs(Kaidodragon:GetChildren()) do
		if v:IsA("Part") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
		end
	end

	emit.emitvfx(destransform)

	AnimModule.PlayAnim(script.Destransformation, unit, 1, "", {Weight = 2, Fade = .15})

	wait(0.1)




	for i, v in pairs(unit.Humanoid.Model:GetChildren()) do
		if v:IsA("MeshPart") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 0}):Play()
		end
	end
	for i, v in pairs(unit.Humanoid.Model:GetChildren()) do
		if v:IsA("Part") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 0}):Play()
		end
	end
	for i, v in pairs(unit.Humanoid.Model:GetChildren()) do
		if v:IsA("SpecialMesh") then
			local shoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Transparency = 0}):Play()
		end
	end

	unit.Humanoid.Model.torso1["Torso LP"].Transparency = 0
	unit.Humanoid.Model.hair["Kaido Hair"].Transparency = 0
	unit.Humanoid.Model.cloak["Kaido Cloak"].Transparency = 0
	unit.Humanoid.Model["Kaido Weapon1"].Transparency = 1

	task.wait(0.25)

	emit.emitvfx(grdash1)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
