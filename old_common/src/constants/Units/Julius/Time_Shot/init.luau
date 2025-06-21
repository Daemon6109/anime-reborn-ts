local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .6, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .55, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

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

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1SFX"], rt, Replicated.SoundGroups.UnitSFX, {PlaybackSpeed = 1})

	local a = script.Move1:FindFirstChild("a"):Clone()
	a.aa.CFrame = rt.CFrame
	a.Parent = effectsfolder
	debris.AddItem(a, 5)

	EmitParticles(a)

	wait(0.415)

	local untitled = script.Move1:FindFirstChild("untitled"):Clone()
	untitled.Root.CFrame = pos.CFrame
	untitled.Parent = effectsfolder
	debris.AddItem(untitled, 5)

	tween_service:Create(untitled.Icosphere, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), { Rotation = Vector3.new(math.random(-55, 55), math.random(-55, 55), math.random(-55, 55)) }):Play()

	local ta = script.Move1:FindFirstChild("ta"):Clone()
	ta.CFrame = untitled.Root.CFrame
	ta.Parent = effectsfolder
	debris.AddItem(ta, 5)

	EmitParticles(ta)

	spawn(function()
		local maxSize = 1.35 -- Tamanho máximo desejado
		local step = 0.1 -- Aumente o passo para menos iterações
		local growthDuration = 0.175 -- Duração total do crescimento em segundos
		local numSteps = maxSize / step
		local growthInterval = growthDuration / numSteps

		-- Crescimento do modelo
		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Interpolação cúbica
			untitled:ScaleTo(smoothScale)
			task.wait(growthInterval)
		end
	end)


	local ex = script.Move1:FindFirstChild("ex"):Clone()
	ex.CFrame = untitled.Root.CFrame * CFrame.new(0,-1,0)
	ex.Parent = effectsfolder
	debris.AddItem(ex, 5)

	EmitParticles(ex)

	tween_service:Create(untitled.Root, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = untitled.Root.CFrame * CFrame.new(0,1,0)}):Play()

	wait(0.9)

	tween_service:Create(untitled.Root, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = untitled.Root.CFrame * CFrame.new(0,-1,0)}):Play()


	wait(0.8)

	EmitParticles(ta)

	EmitParticles(ex)

	tween_service:Create(untitled.Icosphere, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Transparency = 1, Size = Vector3.new(5,5,5)}):Play()

	SetParticlesEnabled(untitled,false)

	for i, v in pairs(untitled.Icosphere:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.1,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 00,Width1 = 00}):Play()
		end
	end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
