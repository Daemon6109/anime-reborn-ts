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
	HitDelay = 1.46, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
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

	local Stand = script.Move2:FindFirstChild("stand"):Clone()
	Stand.Parent =effectsfolder
	Stand.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(0,0,2)
	local rtf = Stand:WaitForChild("HumanoidRootPart")
	local hrpcff = rtf.CFrame
	game.Debris:AddItem(Stand,1.75)


	local Emit1 = script.Move2.Emit1:Clone()
	Emit1.Parent = effectsfolder	
	local rotation = CFrame.Angles(math.rad(0), math.rad(90), math.rad(90))
	Emit1.CFrame = rtf.CFrame * rotation * CFrame.new(0,0,0)
	for _, particle in pairs(Emit1:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end

	game.Debris:AddItem(Emit1,2)


	local duration = 0.1
	local startTime = tick()

	while tick() - startTime < duration do	
		task.spawn(function()
			local effectObject = script.Move2:WaitForChild("Mesh"):Clone()

			effectObject.CFrame = rtf.CFrame * CFrame.new(0, 0, 0) 
			local targetPosition = CFrame.new(0, 0, 0)
			local targetRotation = CFrame.Angles(0, math.rad(0), 0) -- แปลงเป็นเรเดียน
			local targetSize = Vector3.new(10,10,10)

			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			local tween = tween_service:Create(effectObject, tweenInfo, {
				Size = targetSize,
				Transparency = 1,
				CFrame = effectObject.CFrame * targetPosition * targetRotation
			})

			tween.Completed:Once(function()
				if effectObject ~= nil and effectObject.Parent ~= nil then
					effectObject:Destroy()
				end
			end)

			effectObject.Parent = effectsfolder
			tween:Play()
		end)

		task.wait(0.1)
	end

	local EmitText = script.Move2.EmitText:Clone()
	EmitText.Parent = effectsfolder
	EmitText.CFrame = rt.CFrame * CFrame.new(0,0,0)
	for _, particle in pairs(EmitText:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end
	game.Debris:AddItem(EmitText,1)

	task.wait(0.2)


	AnimModule.PlayAnim(script.Animation2, Stand, 1, "", {Weight = 2, Fade = .15})


	local Info = TweenInfo.new(1)
	local Info2 = TweenInfo.new(0.01)
	tween_service:Create(rtf, Info, {CFrame =CFrame.lookAt(pos.Position, pos.Position+SavedDirection)}):Play()

	task.wait(0.8)

	local tt = script.Move2.flag:Clone()
	tt.Parent = effectsfolder	
	local rotation = CFrame.Angles(math.rad(90), math.rad(0), math.rad(90))
	tt.CFrame = pos.CFrame * rotation * CFrame.new(0,0,1.2)
	debris.AddItem(tt,2)
	game.Debris:AddItem(tt,3)

	local Explosion = script.Move2.Explosion:Clone()
	Explosion.Parent = effectsfolder
	local rotation = CFrame.Angles(math.rad(0), math.rad(90), math.rad(90))
	Explosion.CFrame = tt.CFrame * rotation * CFrame.new(0,0,0)
	for _, particle in pairs(Explosion:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end
	game.Debris:AddItem(Explosion,3)


	local duration = 0.1
	local startTime = tick()

	while tick() - startTime < duration do	
		task.spawn(function()
			local effectObject = script.Move2:WaitForChild("Mesh"):Clone()

			effectObject.CFrame = Explosion.CFrame * CFrame.new(0, 0, 0) 
			local targetPosition = CFrame.new(0, 0, 0)
			local targetRotation = CFrame.Angles(0, math.rad(0), 0) -- แปลงเป็นเรเดียน
			local targetSize = Vector3.new(20,20,20)

			local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
			local tween = tween_service:Create(effectObject, tweenInfo, {
				Size = targetSize,
				Transparency = 1,
				CFrame = effectObject.CFrame * targetPosition * targetRotation
			})

			tween.Completed:Once(function()
				if effectObject ~= nil and effectObject.Parent ~= nil then
					effectObject:Destroy()
				end
			end)

			effectObject.Parent = effectsfolder
			tween:Play()
		end)

		task.wait(0.1)
	end

	task.wait(1)

	tween_service:Create(tt, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()


	tween_service:Create(rtf, Info2, {CFrame = hrpcff}):Play()


	--humanoid:LoadAnimation(animations.attk2):Stop()


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
