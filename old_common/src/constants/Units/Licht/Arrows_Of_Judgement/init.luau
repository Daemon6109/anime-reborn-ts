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
	HitDelay = 2.65, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .085, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "Mainaim", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)


	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	spawn(function()

		for i = 1, 7 do
			spawn(function()
				local rand1 = 4.5
				local randCurv = 4.5

				local NLH3 = script.Attack3:FindFirstChild("NoLongerCircle"):Clone()
				NLH3.CFrame = unit.Torso.CFrame
				NLH3.Parent = effectsfolder	
				debris.AddItem(NLH3, 3)

				-- Cria um Motor6D para fixar a parte
				local weld = Instance.new("Motor6D")
				weld.Part0 = unit.Torso
				weld.Part1 = NLH3
				weld.C0 = CFrame.new(0, 0, 0)
				weld.C1 = CFrame.new(0, 0, 0)
				weld.Parent = NLH3

				-- Tween para os beams
				local Tween = tween_service:Create(NLH3.Folder.Beam, TweenInfo.new(1, Enum.EasingStyle.Back), {Width0 = 2, Width1 = 2})
				Tween:Play()

				local Tween = tween_service:Create(NLH3.Folder.Beam1, TweenInfo.new(1, Enum.EasingStyle.Back), {Width0 = 2, Width1 = 2})
				Tween:Play()

				-- Animação de rotação da parte (usando Motor6D)
				local targetRotation = weld.C0 * CFrame.Angles(math.rad(math.random(-90,90)), math.rad(math.random(-90,90)), math.rad(math.random(-90,90)))
				local rotateTween = tween_service:Create(weld, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {C0 = targetRotation})
				rotateTween:Play()

				-- Tween para a curva dos beams
				local Tween = tween_service:Create(NLH3.Folder.Beam, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CurveSize0 = -randCurv, CurveSize1 = randCurv})
				Tween:Play()

				local Tween = tween_service:Create(NLH3.Folder.Beam1, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CurveSize0 = randCurv, CurveSize1 = -randCurv})
				Tween:Play()

				wait(0.8)

				-- Reduz a largura dos beams antes de remover
				local Tween = tween_service:Create(NLH3.Folder.Beam, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {Width0 = 0, Width1 = 0})
				Tween:Play()

				local Tween = tween_service:Create(NLH3.Folder.Beam1, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {Width0 = 0, Width1 = 0})
				Tween:Play()

				wait(0.6)
			end)
		end

		task.wait(0.01)

	end)

	task.wait(0.2)

	for i = 1, 35 do
		task.wait(0.025)

		spawn(function()
			local Sword = script.Attack3:FindFirstChild("Sword"):Clone()

			-- Definir o raio máximo do círculo
			local maxRadius = 25
			local randomRadius = math.random() * maxRadius -- Raio aleatório dentro do círculo
			local angle = math.rad(math.random(0, 360)) -- Ângulo aleatório em radianos

			-- Coordenadas cartesianas no plano XY
			local x = math.cos(angle) * randomRadius
			local z = math.sin(angle) * randomRadius

			-- Posicionar a espada no círculo
			Sword.Handle.CFrame = rt.CFrame * CFrame.new(x, 10, z)
			Sword.Handle.Orientation = Vector3.new(0, math.random(-100, 100), 0)
			Sword.Parent = effectsfolder
			debris.AddItem(Sword, 5)

			EmitParticles(Sword)

			local Transparencyshoottween = tween_service:Create(Sword.Sword, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()
			local Transparencyshoottween = tween_service:Create(Sword.Handle, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = Sword.Handle.CFrame * CFrame.new(0, 5, 0)}):Play()

			local ex = script.Attack3:FindFirstChild("ex"):Clone()
			ex.Parent = effectsfolder
			debris.AddItem(ex, 5)

			local aa = script.Attack3:FindFirstChild("aa"):Clone()
			aa.Parent = effectsfolder
			debris.AddItem(aa, 5)

			for _, v in ipairs(Sword.Handle:GetDescendants()) do
				if v:IsA("Beam") then
					tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 5, Width1 = 1}):Play()
				end
			end

			task.wait(2)

			ex.CFrame = Sword.Handle.CFrame * CFrame.new(0, -15.8, 0)
			aa.CFrame = Sword.Handle.CFrame * CFrame.new(0, 0, 0)

			task.wait(0.01)

			EmitParticles(aa)

			local Transparencyshoottween = tween_service:Create(Sword.Handle, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = Sword.Handle.CFrame * CFrame.new(0, -15, 0)}):Play()

			task.wait(0.1)

			EmitParticles(ex)

			task.wait(0.4)

			for _, v in ipairs(Sword.Handle:GetDescendants()) do
				if v:IsA("Beam") then
					tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
				end
			end

			EmitParticles(Sword)

			local Transparencyshoottween = tween_service:Create(Sword.Sword, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
		end)
	end
end


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
