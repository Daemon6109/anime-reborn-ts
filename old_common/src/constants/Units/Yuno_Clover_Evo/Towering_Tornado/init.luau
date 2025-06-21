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
	HitDelay = 2.3, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local a = script.Move1:FindFirstChild("a"):Clone()
	a.aa.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	a.Parent = effectsfolder
	debris.AddItem(a, 5)

	emit.emitvfx(a)

	wait(0.7)

	spawn(function()
		for i = 1, 6 do
			wait(0.05)

			spawn(function()
				local sword = script.Move1:FindFirstChild("sword"):Clone()
				sword.RootPart.CFrame = rt.CFrame * CFrame.new(math.random(-5,5), math.random(3,6), math.random(1,4.9))
				sword.Parent = effectsfolder
				debris.AddItem(sword, 5)

				emit.emitvfx(sword.RootPart)


				local aa = script.Move1:FindFirstChild("aa"):Clone()
				aa.CFrame = sword.RootPart.CFrame
				aa.Parent = effectsfolder
				debris.AddItem(aa, 5)

				wait()

				tween_service:Create(sword.Cylinder001, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
				tween_service:Create(sword.RootPart.beam.Beam, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width1 = 2.187}):Play()

				emit.enablevfx(sword, true)

				wait(0.6)

				local part = sword.RootPart
				local targetPosition = pos.Position + Vector3.new(math.random(-5, 5), math.random(-1, -1), math.random(-5.5, 5.5))

				-- Criando um CFrame que leva a espada à posição aleatória com orientação correta
				local lookAtCFrame = CFrame.new(part.Position, targetPosition) -- Direciona a espada para o destino
				local targetCFrame = CFrame.new(targetPosition) -- Posição final do destino

				-- Tween para mover e orientar a espada
				tween_service:Create(part, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {CFrame = lookAtCFrame}):Play()

				wait(0.5)

				emit.emitvfx(aa)

				-- Tween para colocar a espada na posição exata ao redor de `pos`
				tween_service:Create(part, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
				wait(0.1)

				local exp = script.Move1:FindFirstChild("exp"):Clone()
				exp.CFrame = sword.RootPart.CFrame
				exp.Parent = effectsfolder
				debris.AddItem(exp, 5)
				exp.Orientation = Vector3.new()

				emit.emitvfx(exp)

				emit.enablevfx(sword, false)

				sword.RootPart.Anchored = false

				wait(0.3)

				sword:Destroy()
			end)
		end
	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
