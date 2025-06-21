local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.6, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	--print(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	
	
	local part = Instance.new("Part"):Clone()
	part.CFrame = rt.CFrame * CFrame.new(0,-1.9,-2)
	part.Anchored = true
	part.Size = Vector3.new(0,0,0)
	debris.AddItem(part,5)
	part.Transparency = 1
	part.Parent = workspace.Effects

	local ExplosionImpact12 = script.Move3:FindFirstChild("ExplosionImpact12"):Clone()
	ExplosionImpact12.CFrame = rt.CFrame * CFrame.new(0,-1.9,-5)
	ExplosionImpact12.Parent =  workspace.Effects
	debris.AddItem(ExplosionImpact12,6)

	local grdash = script.Move3:FindFirstChild("grdash"):Clone()
	grdash.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	grdash.Parent =  workspace.Effects
	debris.AddItem(grdash,5)

	local blueflame = script.Move3:FindFirstChild("blueflame"):Clone()
	blueflame.CFrame = rt.CFrame * CFrame.new(0,-1.9,0)
	blueflame.Parent =  workspace.Effects
	debris.AddItem(blueflame,5)

		
	SoundWrapper:PlaySound(script["Main"], rt, Replicated.SoundGroups.UnitSFX)
	wait(0.2)



	SoundWrapper:PlaySound(script["body-collapse01"], rt, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(grdash)

	unit.Head.eb.a.Enabled = true
	unit.Head.eb1.a.Enabled = true


	wait(0.2)


	emit.enablevfx(blueflame,true)


	emit.emitvfx(unit.Humanoid.Model["Kaido Weapon"].emit)


	emit.enablevfx(unit.Humanoid.Model["Kaido Weapon"].emit,true)



	SoundWrapper:PlaySound(script["body-collapse02"], rt, Replicated.SoundGroups.UnitSFX)

	
	task.spawn(function()
		for i=0,6,1 do
			task.wait(.1)
			emit.bezier(rt.CFrame,ColorSequence.new(Color3.fromRGB(255, 20, 20)),0.00000000005,.5,"Mid",true,5,.5,3.6)
		end
	end)
	
	wait(0.4)

	spawn(function()
		for i = 1,3 do
			task.wait(0.1)
			local emitlight = script.Move3:FindFirstChild("emitlightning"):Clone()
			emitlight.CFrame = rt.CFrame * CFrame.new(math.random(-15,15),math.random(-1.9,-1.9),math.random(-15,15))
			emitlight.Parent =  workspace.Effects
			debris.AddItem(emitlight,3)

			for _, emitter in pairs(emitlight:GetDescendants()) do
				if emitter:IsA("ParticleEmitter") then
					emitter:Emit(emitter:GetAttribute("EmitCount"))
				end
			end

		end
	end)

	wait(0.85)

	unit.Head.eb.a.Enabled = false
	unit.Head.eb1.a.Enabled = false

	emit.enablevfx(blueflame,false)

	SoundWrapper:PlaySound(script["magic-cast-heavy14"], rt, Replicated.SoundGroups.UnitSFX)

	spawn(function()
		for i = 1,6 do
			task.wait(0.1)
			local emitlight = script.Move3:FindFirstChild("emitlightning"):Clone()
			emitlight.CFrame = rt.CFrame * CFrame.new(math.random(-15,15),math.random(-1.9,-1.9),math.random(-25,-10))
			emitlight.Parent =  workspace.Effects
			debris.AddItem(emitlight,3)

			for _, emitter in pairs(emitlight:GetDescendants()) do
				if emitter:IsA("ParticleEmitter") then
					emitter:Emit(emitter:GetAttribute("EmitCount"))
				end
			end

		end
	end)



	emit.emitvfx(unit.Humanoid.Model["Kaido Weapon"].emit)

	emit.emitvfx(ExplosionImpact12)

	spawn(function()
		for i = 1,4 do

			local light1 = script.Move3:FindFirstChild("ExplosionImpact1"):Clone()
			light1.CFrame = part.CFrame * CFrame.new(i * -5, 0.5, i * -4) -- Ajuste o valor 5 conforme necessário para controlar o espaçamento
			light1.Parent =  workspace.Effects
			debris.AddItem(light1,3.5)


			local light = script.Move3:FindFirstChild("ExplosionImpact1"):Clone()
			light.CFrame = part.CFrame * CFrame.new(i * 5, 0.5, i * -4) -- Ajuste o valor 5 conforme necessário para controlar o espaçamento
			light.Parent =  workspace.Effects
			debris.AddItem(light,3.5)

			local light2 = script.Move3:FindFirstChild("ExplosionImpact1"):Clone()
			light2.CFrame = part.CFrame * CFrame.new(0, 0.5, i * -4) -- Ajuste o valor 5 conforme necessário para controlar o espaçamento
			light2.Parent =  workspace.Effects
			debris.AddItem(light2,3.5)



			task.wait(0.05)

			emit.emitvfx(light)
			emit.emitvfx(light1)
			emit.emitvfx(light2)
		end

	end)

	emit.enablevfx(unit.Humanoid.Model["Kaido Weapon"],false)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
