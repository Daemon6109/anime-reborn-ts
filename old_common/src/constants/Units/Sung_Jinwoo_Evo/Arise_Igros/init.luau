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
	HitDelay = 3, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end 

				local _delay = v:GetAttribute("EmitDuration")
				if _delay then
					v.Enabled = true
					task.delay(_delay, function()
						v.Enabled = false
					end)
				end
			end)()
		end
	end
end

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	--AnimModule.PlayAnim(script.Animation3, unit, 1.6, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	local atk = script.Attack4:FindFirstChild("Arise"):Clone()
	atk.Part.CFrame = rt.CFrame * CFrame.new(-2.936, -1.5, 0.835)
	atk.Parent = effectsfolder
	debris.AddItem(atk,6)

	task.wait(0.3)

	local Igris = script:FindFirstChild("Igris"):Clone()
	Igris.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(-2.936, -.5, 0.835)
	Igris.Parent = effectsfolder
	debris.AddItem(Igris,3.3)
	emit.enablevfx(atk,true)
	for i, v in pairs(atk.Part:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.375,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 1.2,Width1 = 1.2}):Play()
		end
	end 
	emit.enablevfx(atk,true)
	--local animation = Igris.Humanoid:LoadAnimation(script.Animation4Igris):Play()
	local ANIMM = AnimModule.PlayAnim(script.Animation4Igris, Igris, 1, "", {Weight = 2, Fade = .15})
	--local ANIMM = AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})


	spawn(function()
		local maxSize = .7 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.1 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.1 * maxSize -- Função de interpolação cúbica
			atk:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)
	
	local atk4 = script.Attack4:FindFirstChild("atk4"):Clone()
	atk4.Part.CFrame = Igris.HumanoidRootPart.CFrame
	atk4.Parent = effectsfolder
	debris.AddItem(atk4,6)

	EmitParticles(atk4)


	task.wait(1.2)
	emit.enablevfx(atk,false)


	local Length = (Igris.HumanoidRootPart.Position - pos.Position).magnitude	


	local Tween = tween_service:Create(Igris.HumanoidRootPart, TweenInfo.new(0.125, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0), {CFrame = pos.CFrame}):Play()

	task.wait(0.125)

	local rockemit = script.Attack4:FindFirstChild("rockemit"):Clone()
	rockemit.CFrame = Igris.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
	rockemit.Parent = effectsfolder
	debris.AddItem(rockemit,6)


	spawn(function()
		task.wait(0.1)
		EmitParticles(rockemit)

	end)

	local Model = script.Attack4:FindFirstChild("Model"):Clone()
	Model.Part.CFrame = Igris.HumanoidRootPart.CFrame * CFrame.new(0,-.3,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model,6)



	EmitParticles(Model)

	spawn(function()

		task.wait(1.2)

		for i, v in pairs(Model.Model.beam:GetChildren()) do
			if v:IsA("Beam") then
				local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.275,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
			end
		end 

	end)




	task.wait(1.75)



	local bb = script.Attack4:FindFirstChild("bb"):Clone()
	bb.CFrame = Igris.HumanoidRootPart.CFrame

	atk.Part .CFrame = Igris.HumanoidRootPart.CFrame + Vector3.new(0,-2,0)
	emit.emitvfx(atk)

	bb.Parent = effectsfolder
	debris.AddItem(bb,6)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
