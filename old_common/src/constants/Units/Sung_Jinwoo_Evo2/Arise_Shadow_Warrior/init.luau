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
	HitDelay = 3.5, -- seconds
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
	
	--AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	
	local atk = script.Attack3:FindFirstChild("Arise"):Clone()
	atk.Part.CFrame = rt.CFrame * CFrame.new(2.936, -1.5, 0.835)
	atk.Parent = effectsfolder
	debris.AddItem(atk,6)

	task.wait(0.5)


	local Iron = script:FindFirstChild("Iron"):Clone()
	Iron.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(2.936, 0.5, 0.835)



	Iron.Parent = effectsfolder
	debris.AddItem(Iron,4.5)
	emit.enablevfx(atk,true)
	for i, v in pairs(atk.Part:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.375,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Width0 = 1.2,Width1 = 1.2}):Play()
		end
	end 
	emit.enablevfx(atk,true)
	--local animation = Iron.Humanoid:LoadAnimation(script.Animation3Iron):Play()
	local ANIMM = AnimModule.PlayAnim(script.Animation3Iron, Iron, 1, "", {Weight = 2, Fade = .15})
	local ANIMM = AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})

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
	
	task.wait(.5)
	
	local Model2 = script.Attack3:FindFirstChild("Model2"):Clone()
	Model2.Part.CFrame = rt.CFrame * CFrame.new(2.936, 0.5, 0.835)
	Model2.Parent = effectsfolder
	debris.AddItem(Model2,6)
	emit.enablevfx(atk,false)

	EmitParticles(Model2)

	Model2.Part.CFrame = CFrame.new(Model2.Part.Position, pos.Position)

	

	Iron.HumanoidRootPart.CFrame = pos.CFrame * CFrame.new(0,0.5,0)



	local Part1 = Instance.new("Part")
	Part1.Anchored = true
	Part1.CanCollide = false
	Part1.Transparency = 1
	Part1.CFrame = Iron.HumanoidRootPart.CFrame * CFrame.new(0,0,0)

	emit.enablevfx(Part1,false)

	debris.AddItem(Part1,5)

	local Model1 = script.Attack3:FindFirstChild("Model1"):Clone()
	Model1.Part.CFrame = Part1.CFrame
	Model1.Parent = effectsfolder
	debris.AddItem(Model1,6)

	EmitParticles(Model1)



	task.wait(0.2)

	



	task.wait(3.55)

	local bb = script.Attack3:FindFirstChild("bb"):Clone()
	bb.CFrame = Iron.HumanoidRootPart.CFrame
	
	atk.Part .CFrame = Iron.HumanoidRootPart.CFrame + Vector3.new(0,-2,0)
	emit.emitvfx(atk)
	
	bb.Parent = effectsfolder
	debris.AddItem(bb,6)

	EmitParticles(bb)



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
