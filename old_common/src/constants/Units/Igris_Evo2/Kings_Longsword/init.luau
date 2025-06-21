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
	HitDelay = .75, -- seconds
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector

	local Length = (rt.Position - pos.Position).Magnitude - 1
	local back = rt.CFrame

	task.wait(0.4)

	-- Clona e posiciona a espada
	local swrd = script.Attack1:FindFirstChild("swordoa"):Clone()
	swrd.Parent = effectsfolder
	debris.AddItem(swrd, 4)

	EmitParticles(swrd)

	-- Configura a posição inicial e orientação da espada
	local direction = (pos.Position - rt.Position).Unit -- Direção para o alvo
	swrd.CFrame = CFrame.new(rt.Position, rt.Position + direction) * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(180))

	-- Ajusta a espada para "apontar" corretamente para o alvo
	local Length1 = (swrd.Position - pos.Position).Magnitude + 1

	EmitParticles(unit["Right Arm"])

	task.wait(0.1)

	-- Move a espada suavemente em direção ao alvo
	local Tween = tween_service:Create(
		swrd,
		TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0),
		{CFrame = swrd.CFrame * CFrame.new(0, 0, Length1)}
	):Play()

	unit.swordoa.Transparency = 1

	local txx = script.Attack1:FindFirstChild("Exp1"):Clone()
	txx.CFrame = pos.CFrame * CFrame.new(0,0.2,0)
	txx.Parent = effectsfolder
	debris.AddItem(txx,5)

	EmitParticles(txx)

	task.wait(0.7)

	for i, v in ipairs(swrd.t:GetDescendants()) do
		if v:IsA("Beam") then
			coroutine.wrap(function()
				local Tween = tween_service:Create(
					v,
					TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0),
					{Width0 = 0, Width1 = 0}
				):Play()
			end)()
		end
	end

	spawn(function()
		local place = swrd.CFrame

		for i = 1, 15 do
			local randomOffset = CFrame.new(
				math.random(-4, 4) / 10,
				math.random(-2, 2) / 10, -- Faz a espada subir gradualmente
				math.random(-4, 4) / 10
			) * CFrame.Angles(
				math.rad(math.random(-10, 10)),
				math.rad(math.random(-10, 10)),
				math.rad(math.random(-10, 10))
			)

			local Tween = tween_service:Create(
				swrd,
				TweenInfo.new(0.04, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0),
				{ CFrame = place * randomOffset }
			)

			Tween:Play()
			task.wait(0.02)
		end
	end)

	task.wait(0.55)

	local Tween = tween_service:Create(swrd, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = unit.swordoa.CFrame}):Play()

	task.wait(0.07)

	unit.swordoa.Transparency = 0
	swrd.Transparency = 1
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
