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
	HitDelay = 3.36, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .0, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.4, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move3"], rt, Replicated.SoundGroups.UnitSFX)


	local move3 = script.Move3:FindFirstChild("move3"):Clone()
	move3.jump.CFrame = rt.CFrame * CFrame.new(0,-1.45,0)
	debris.AddItem(move3,6)
	move3.Parent = effectsfolder

	emit.emitvfx(move3)


	local instance111 = Instance.new("Part")
	instance111.Anchored = true
	instance111.Size = Vector3.new()
	instance111.CanCollide = false
	instance111.Transparency = 1

	debris.AddItem(instance111,8)

	instance111.CFrame = pos.CFrame * CFrame.new(0,8.5,0)

	local Model = script.Move3:FindFirstChild("Model"):Clone()
	Model.Lava.CFrame = instance111.CFrame

	debris.AddItem(Model,9.5)
	
	task.spawn(function()
		for i=0,10,1 do
			wait(.1)
			emit.bezier(instance111.CFrame,ColorSequence.new(Color3.fromRGB(118, 39, 255)),0.0005,1,"Mid",true,5,.7,1.8)
			emit.bezier(instance111.CFrame,ColorSequence.new(Color3.fromRGB(0, 0, 0)),0.0005,1,"Mid",true,0,0,1.8)
		end
	end)
	

	wait(0.5)



	local rocksFolder = script.Move3:FindFirstChild("Rocks")

	local Shinrapush = script.Move3:FindFirstChild("Shinrapush"):Clone()
	Shinrapush.CFrame = instance111.CFrame
	Shinrapush.Parent = effectsfolder
	debris.AddItem(Shinrapush,9.5)

	emit.emitvfx(Shinrapush)



	emit.enablevfx(Shinrapush,true)

	emit.enablevfx(Model,true)


	spawn(function()



		wait(1.2)


		spawn(function()

			Model.Parent = effectsfolder
			local maxSize = 1 -- Defina o tamanho máximo desejado
			local step = 0.01
			local duration = .2 -- Defina a duração total do crescimento em segundos

			local numSteps = maxSize / step
			local interval = duration / numSteps
			
			task.spawn(function()
				for i = 1,5,0 do
					Model:ScaleTo(Model:GetScale() + 1)
					task.wait(.2)
				end
			end)
			
			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^.2 * maxSize -- Função de interpolação cúbica
				Model:ScaleTo(smoothScale)
				task.wait(interval)
			end
			
			
			
		end)
		
		task.spawn(function()
			
			local float = tween_service:Create(Model.Rock, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = Model.Rock.CFrame + Vector3.new(0,4,0)}):Play()	
			task.wait(.5)
			local float2 = tween_service:Create(Model.Rock, TweenInfo.new(.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true, 0), {CFrame = Model.Rock.CFrame + Vector3.new(0,-8,0)}):Play()
			
			
			
			
		end)
		
		local float = tween_service:Create(Model.Rock, TweenInfo.new(3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Orientation = Model.Rock.Orientation + Vector3.new(170,190,111)}):Play()

		wait(0.225)
	
		local PainAsura = script.Move3:FindFirstChild("PainAsura"):Clone()
		PainAsura.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(-5,0,1.5)
		debris.AddItem(PainAsura,6)

		local asurapainmoves = script.Move3:FindFirstChild("asurapainmoves"):Clone()
		asurapainmoves.jump.CFrame = rt.CFrame * CFrame.new(-5,-1.4,1.5)
		debris.AddItem(asurapainmoves,6)
		asurapainmoves.Parent = effectsfolder
		PainAsura.Parent = effectsfolder 

		emit.emitvfx(asurapainmoves)

		AnimModule.PlayAnim(script.Asurapain, PainAsura, 1.35, "", {Weight = 2, Fade = .15})

		task.wait(0.001)

		PainAsura.HumanoidRootPart.CFrame = CFrame.new(PainAsura.HumanoidRootPart.Position, pos.Position)
		asurapainmoves.jump.CFrame = CFrame.new(asurapainmoves.jump.Position, pos.Position)


		wait(0.45)

		PainAsura.weapon.number.Transparency = 0

		wait(0.05)


		PainAsura.weapon.number2.Transparency = 0


		wait(0.05)

		PainAsura.weapon.numberthree.Transparency = 0

		wait(0.05)

		emit.enablevfx(PainAsura.weapon.number4,true)

		PainAsura.weapon.number4.Transparency = 0

		wait(0.15)

		local missil = script.Move3:FindFirstChild("missil"):Clone()
		missil.CFrame = PainAsura.weapon.number4.CFrame
		debris.AddItem(missil,3)
		missil.Parent = effectsfolder
		missil.Parent = effectsfolder

		local shoottween = tween_service:Create(missil, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = Model.Rock.CFrame}):Play()


		emit.enablevfx(PainAsura.weapon.number4,false)

		wait(0.35)

		Model.Rock.emit.emit.Rocks.Parent = instance111
		
		emit.emitvfx(instance111)
		emit.emitvfx(Model)

		local shoottween = tween_service:Create(Model.Rock, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Size = Vector3.new()}):Play()
		local shoottween = tween_service:Create(Model.Lava, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Size = Vector3.new()}):Play()
	
		emit.enablevfx(Model,false)	


		emit.enablevfx(Shinrapush,false)

		emit.emitvfx(Shinrapush)

		tween_service:Create(Model.Rock.PointLight,TweenInfo.new(.2),{Range = 16}):Play()

		wait(0.175 / 2)

		missil:Destroy()

		wait(0.075)

		tween_service:Create(Model.Rock.PointLight,TweenInfo.new(.2),{Range = 0}):Play()

		PainAsura:Destroy()




	end)

	spawn(function()
		task.wait(.15)
	
		for i = 1,20 do
			local rockIndex = math.random(1, #rocksFolder:GetChildren())
			local selectedRock = rocksFolder:GetChildren()[rockIndex]:Clone()
			selectedRock.Parent = effectsfolder
			selectedRock.CFrame = pos.CFrame * CFrame.new(math.random(-8, 8), math.random(-5, -5), math.random(-8, 8))
			debris.AddItem(selectedRock,3.5)

			local toprock = script.Move3:FindFirstChild("toprock"):Clone()
			toprock.CFrame = selectedRock.CFrame * CFrame.new(0,4,0)
			toprock.Parent = effectsfolder
			debris.AddItem(toprock,2.5)

			task.wait(0.025)

			spawn(function()
				emit.emitvfx(toprock)

				local rotateTween = tween_service:Create(selectedRock, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Rotation = Vector3.new(math.random(-366, 366), math.random(-366, 366), math.random(-366, 366))})

				local kp = selectedRock.Position
				local enemypos = instance111.Position

				local magnitude = (kp-enemypos).magnitude
				local Step = 35

				local LookAt = CFrame.new(kp,enemypos)

				local Time = math.random(-15,15)/100
				local Time2 = math.random(-15,15)/100


				spawn(function()
					
					task.spawn(function()
						task.wait(.5)
						emit.emitvfx(selectedRock.EMIT)
					end)
					
					for i = 0,Step do
						selectedRock.CFrame = LookAt * CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45  * Time),math.sin(math.rad((i * (180/Step)))) * (15 * Time2),-(magnitude/Step) * (i))
						game:GetService("RunService").Heartbeat:Wait()
					

					end

				end)

				rotateTween:Play()


				wait(.5)

				emit.enablevfx(selectedRock,false)


				local growTween = tween_service:Create(selectedRock, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Size = Vector3.new(0,0,0)})
				growTween:Play()


			end)


			task.wait(0.035)
		end
	end)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
