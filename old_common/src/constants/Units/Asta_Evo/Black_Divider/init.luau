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
	HitDelay = 2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
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



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Model = script.Move4:FindFirstChild("Model"):Clone()
	Model.aa.CFrame = rt.CFrame * CFrame.new(0, -1, 0)
	Model.Parent = effectsfolder
	debris.AddItem(Model, 8)

	local Part1 = script.Move4:FindFirstChild("Part1"):Clone()
	Part1.CFrame = rt.CFrame * CFrame.new(0, -1, 0)
	Part1.Parent = effectsfolder
	debris.AddItem(Part1, 5.5)

	EmitParticles(Model)

	wait(0.5)

	emit.enablevfx(Part1,true)

	wait(0.450)

	local Highlight = Instance.new("Highlight")
	Highlight.FillTransparency = 1
	Highlight.OutlineTransparency = 1
	Highlight.OutlineColor = Color3.fromRGB(255,32,36)
	Highlight.FillColor = Color3.fromRGB(11,3,3)
	Highlight.Parent = unit.Sword

	spawn(function()

		local trail1 = script.Move4.Trail:Clone()
		trail1.Parent = effectsfolder
		trail1.Position = rt.Position + Vector3.new(0,-1.5,0)
		debris.AddItem(trail1,4)





		tween_service:Create(trail1,TweenInfo.new(.5),{Position = trail1.Position + Vector3.new(0,13.5,0)}):Play()
		tween_service:Create(trail1,TweenInfo.new(.5),{Orientation = Vector3.new(0,600,0)}):Play()

		wait(0.4)


		emit.enablevfx(Part1,false)


		emit.enablevfx(trail1,false)


		emit.enablevfx(unit.Sword.Sword,true)


		tween_service:Create(unit.Sword.Highlight,TweenInfo.new(.2),{FillTransparency = .25}):Play()
		tween_service:Create(unit.Sword.Highlight,TweenInfo.new(.2),{OutlineTransparency = 0.9}):Play()

		wait(0.45)




		local Model1 = script.Move4:FindFirstChild("Model1"):Clone()
		Model1.root.CFrame = rt.CFrame * CFrame.new(0, -1, -1.75)
		Model1.Parent = effectsfolder
		debris.AddItem(Model1, 5.5)



		local mv3 = script.Move4:FindFirstChild("Part"):Clone()
		mv3.Parent = effectsfolder
		mv3.root.CFrame = rt.CFrame * CFrame.new(0, -1, -1.75)
		debris.AddItem(mv3, 5)

		local growAmount = 22 -- O quanto você quer que ela cresça para frente

		-- Define o novo tamanho sem alterar a posição inicial
		local newSize = Vector3.new(mv3.root.Size.X, mv3.root.Size.Y, mv3.root.Size.Z + growAmount)

		-- Ajuste a posição para mover para frente na direção do LookVector
		local newCFrame = mv3.root.CFrame * CFrame.new(0, 0, -growAmount / 2)

		-- Cria e executa o Tween
		local tweenInfo = TweenInfo.new(0.2) -- Duração do Tween
		local tween = tween_service:Create(mv3.root, tweenInfo, {Size = newSize, CFrame = newCFrame})
		tween:Play()



		wait(0.5)

		EmitParticles(Model1)

		spawn(function()
			for i = 1,6 do
				local Ground = script.Move4:FindFirstChild("Ground Burst"):Clone()
				Ground.CFrame = rt.CFrame * CFrame.new(math.random(-3,3),math.random(-1,4.5),math.random(-25,-2))
				Ground.Parent = effectsfolder
				debris.AddItem(Ground,3.25)
				task.wait(0.025)
				EmitParticles(Ground)
			end
		end)


		emit.enablevfx(mv3, false)

	end)

	spawn(function()
		local maxSize = 2 -- Tamanho máximo desejado
		local minSize = 0.5 -- Tamanho original
		local step = 0.1 -- Aumente o passo para menos iterações
		local growthDuration = 0.4 -- Duração total do crescimento em segundos
		local shrinkDuration = 0.5 -- Duração total do encolhimento em segundos
		local numSteps = maxSize / step
		local growthInterval = growthDuration / numSteps

		-- Crescimento do modelo
		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Interpolação cúbica
			unit.Sword:ScaleTo(smoothScale)
			task.wait(growthInterval)
		end

		wait(1.15)

		-- Efeito de desvanecimento
		tween_service:Create(unit.Sword.Highlight, TweenInfo.new(.2), {FillTransparency = 1}):Play()
		tween_service:Create(unit.Sword.Highlight, TweenInfo.new(.2), {OutlineTransparency = 1}):Play()

		emit.enablevfx(unit.Sword.Sword,false)

		-- Redução do modelo de volta ao tamanho original
		local numStepsDown = (maxSize - minSize) / step
		local shrinkInterval = shrinkDuration / numStepsDown

		for i = 1, numStepsDown do
			local t = i / numStepsDown
			local smoothScaleDown = maxSize - (t * (maxSize - minSize)) -- Linear para um encolhimento mais rápido
			unit.Sword:ScaleTo(smoothScaleDown)
			task.wait(shrinkInterval)
		end
	end)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
