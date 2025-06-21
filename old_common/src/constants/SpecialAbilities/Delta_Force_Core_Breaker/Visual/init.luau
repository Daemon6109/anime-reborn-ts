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
	HitDelay = 1.7, -- seconds
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

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid1 = character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	local G_1 = unit.Gamma1
	local G_2 = unit.Gamma2

	local rtG1 = unit.Gamma1:WaitForChild("HumanoidRootPart")
	local rtG2 = unit.Gamma2:WaitForChild("HumanoidRootPart")
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector

	SoundWrapper:PlaySound(script["Move4"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Length2 = (rtG2.Position - pos.Position).magnitude - 5
	local back2 = rtG2.CFrame
	
	AnimModule.PlayAnim(script["Animation4(G1)"], G_1, 1, "", {Weight = 2, Fade = .15})
	AnimModule.PlayAnim(script["Animation4(G2)"], G_2, 1, "", {Weight = 2, Fade = .15})

	rtG2.Anchored = true

	local aura = script.Active:FindFirstChild("Aura"):Clone()
	aura.CFrame = G_2.Torso.CFrame * CFrame.new(0,1,0)
	aura.Parent = effectsfolder
	debris.AddItem(aura,8)
	
	task.delay(4.5, function()
		game.Lighting.ExposureCompensation = 0
		tween_service:Create(game.Lighting, TweenInfo.new(.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), {ExposureCompensation = 5}):Play()
		task.wait(.25)
		tween_service:Create(game.Lighting, TweenInfo.new(.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), {ExposureCompensation = 0}):Play()
		task.wait(1)
		game.Lighting.ExposureCompensation = 0
	end)

	local Tween = tween_service:Create(aura.ett1.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {Brightness = 25}):Play()


	local weld = Instance.new("WeldConstraint")
	weld.Parent = aura
	weld.Part0 = G_2.Torso
	weld.Part1 = aura
	debris.AddItem(weld,8)

	EmitParticles(aura)

	task.wait(1.7)

	local Tween = tween_service:Create(rtG2, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out,0,false,0), {CFrame = rtG2.CFrame * CFrame.new(0,0,-Length2)}):Play()

	local ball = script.Active.Mainexplosion:Clone() -- the ball after the impact
	ball.Parent = workspace.Effects
	ball.ball.Position = pos.Position + Vector3.new(0,-1,0)
	ball.Attack3.Position = pos.Position + Vector3.new(0,-1,0)
	emit.enablevfx(ball,true) 


	local oldscale = ball:GetScale() -- scaling the ball
	ball:ScaleTo(0.2)



	local plus = 0
	
	spawn(function()

		local unit = rt -- Supondo que rt seja uma parte ou instância da sua unidade
		local unitPosition = unit.Position -- Acessa a propriedade Position da unidade
		local tremorDistance = 25 -- Distância máxima para causar o tremor (em studs)

		-- Função para calcular a distância entre o player e a unidade

		-- THIS IS FOR A POTENTIAL CAMERA SHAKE

		local function isPlayerNear()


			local playerPosition = character:WaitForChild("HumanoidRootPart").Position 


				local distance = (playerPosition - unitPosition).Magnitude
			return distance <= tremorDistance
		end

		-- THIS IS FOR A POTENTIAL CAMERA SHAKE


		local function ShakeScreen(intensity, frequency, duration)
			if not isPlayerNear() then return end -- Se o player estiver longe, não treme

			local startTime = tick()

			local function onRenderStep()
				if tick() - startTime < duration then
					local offset = Vector3.new(
						math.random() * intensity - intensity / 2,
						math.random() * intensity - intensity / 2,
						math.random() * intensity - intensity / 2
					)
					humanoid1.CameraOffset = offset
				else
					humanoid1.CameraOffset = Vector3.new() -- Parar o tremor
					RunService:UnbindFromRenderStep("CameraShake")
				end
			end

			RunService:BindToRenderStep("CameraShake", Enum.RenderPriority.Camera.Value, onRenderStep)
		end


		-- THIS IS FOR A POTENTIAL CAMERA SHAKE


		task.spawn(function()
			-- Exemplo: Apenas um ataque especial causa tremor
			ShakeScreen(1.5, 0.08, 3.5)
		end)
	end)
	
	for i=0,15,1 do
		ball:SetPrimaryPartCFrame(pos.CFrame + Vector3.new(0,-1,0))
		plus = plus + .075
		ball:ScaleTo(plus)
		wait(0.1)
	end

	for i=0,14,1 do
		ball:SetPrimaryPartCFrame(pos.CFrame + Vector3.new(0,-1,0))
		local a = math.random(1000,1700)/1000
		ball:ScaleTo(a)
		wait(.07)
	end
	
	task.wait(0.1)

	emit.emitvfx(ball.Attack3.A)
	emit.enablevfx(ball,false) 

	local imp = script.Active.finalimpact:Clone() -- the ball after the impact
	imp.Parent = workspace.Effects
	imp.Position= pos.Position + Vector3.new(0,-1,0)
	emit.emitvfx(imp)


	local Tween = tween_service:Create(aura.ett1.PointLight, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Brightness = 45}):Play()
	local Tween = tween_service:Create(aura.ett1.PointLight, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Range = 35}):Play()
	local Tween = tween_service:Create(aura.ett1.PointLight, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Color = Color3.new(1, 0.270588, 0.0901961)}):Play()



	local Tween = tween_service:Create(aura.ett1.PointLight, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {Brightness = 0}):Play()


	--G_2:Destroy()

	task.wait(0.5)

	rtG2.Anchored = false
	rtG2.CFrame = back2
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
