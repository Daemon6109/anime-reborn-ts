local module = {}
local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)
local vfx_custom = require(Replicated:WaitForChild("Libs"):WaitForChild("VFX_Custom"))
local Run = game:GetService("RunService")

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Animations = script
local Sound = script.Parent:WaitForChild("Sound")
local Mesh = script.Mesh
local Scaler = require(Replicated.Libs.VFX_Scale)
local effectsfolder = workspace.Effects

module.config = {
	HitDelay = 2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .07, -- delay between hits in a multi-hit move
	Speed = 88,
	--CustomDelay = {
	--	[1] = .35,
	--},
	ScaleFactor = .9,
}

Scaler:scale(module.config.ScaleFactor, Mesh)

local function SetParticlesEnabled(part, shouldEnable)
	for i, v in ipairs(part:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v.Enabled = shouldEnable
				end
			end)()
		end
	end
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
	
	local hum = unit:FindFirstChild("Humanoid")
	local SavedDirection = rt.CFrame.LookVector
	local Enemy = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	local function movehere1()
		local animation = AnimModule.PlayAnim(Animations["Animation1"], unit, 1, "", {Weight = 2, Fade = .15})


		local wind = Mesh.wind:Clone()
		wind.CFrame = rt.CFrame * CFrame.new(0,-1.3,0)
		wind.Parent = effectsfolder
		debris.AddItem(wind,4)

		local em = Mesh.emit:Clone()
		em.CFrame = rt.CFrame * CFrame.new(0,0,-1.35)
		em.Parent = effectsfolder
		debris.AddItem(em,4)

		SoundWrapper:PlaySound(Sound["Jump Swish 1 (SFX)"], rt, Replicated.SoundGroups.UnitSFX)

		wait(0.75)

		SoundWrapper:PlaySound(Sound["Shine Charge"], rt, Replicated.SoundGroups.UnitSFX)

		local em2 = Mesh.emit2:Clone()
		em2.CFrame = rt.CFrame * CFrame.new(0,-1.3,0)
		em2.Parent = effectsfolder
		debris.AddItem(em2,5)

		local exp = Mesh.exp:Clone()
		exp.CFrame = pos.CFrame * CFrame.new(0,-1.3,0)
		exp.Parent = effectsfolder
		debris.AddItem(exp,4)

		local fr = Mesh.Model:Clone()
		fr.FireBall.CFrame = rt.CFrame * CFrame.new(0,0,-1.35)
		fr.Parent = effectsfolder
		debris.AddItem(fr,4)

		local dash = Mesh.dash:Clone()
		dash.CFrame = rt.CFrame * CFrame.new(0,0,-1.35)
		dash.Parent = effectsfolder
		debris.AddItem(dash,4)
		dash.CFrame = CFrame.new(dash.Position, pos.Position)

		SetParticlesEnabled(fr,true)


		fr.FireBall.emit.Aura:Emit(1)


		task.spawn(function()

			local maxSize = 1 -- Defina o tamanho máximo desejado
			local step = 0.01
			local duration = 0.2 -- Defina a duração total do crescimento em segundos

			local numSteps = maxSize / step
			local interval = duration / numSteps

			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^0.2 * maxSize -- Função de interpolação cúbica
				fr:ScaleTo(smoothScale)
				task.wait(interval)
			end

		end)

		EmitParticles(em)

		SetParticlesEnabled(wind,true)

		local shoottween = tween_service:Create(fr.FireBall.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 12}):Play()

		wait(0.6)

		SoundWrapper:PlaySound(Sound["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)

		EmitParticles(em2)

		EmitParticles(dash)

		SetParticlesEnabled(wind,false)




		local rocketpos = fr.FireBall.Position
		local enemypos = pos.Position

		local magnitude = (rocketpos-enemypos).magnitude
		local Step = 19

		local LookAt = CFrame.new(rocketpos,enemypos)

		local Time = math.random(-0,0)/100
		local Time2 = math.random(12,12)/200
		task.spawn(function()

			for i = 1,Step do
				fr.FireBall.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (45 * Time),math.sin(math.rad((i * (180/Step))))* (15 * Time2),-(magnitude/Step) * (i))
				game:GetService("RunService").Heartbeat:Wait()
			end

			local shoottween = tween_service:Create(fr.FireBall.PointLight, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()

			fr.FireBall.Transparency = 1

			fr:Destroy()

			SoundWrapper:PlaySound(Sound.explosion03, rt, Replicated.SoundGroups.UnitSFX)

			EmitParticles(exp)
		end)


	end
	movehere1()
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
