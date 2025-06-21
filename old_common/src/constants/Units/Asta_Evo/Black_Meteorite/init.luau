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
	HitDelay = .8, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local slash = script.Move2:FindFirstChild("slash"):Clone()
	slash.Parent = effectsfolder
	slash.aa.CFrame = rt.CFrame * CFrame.new(0, -1, 0)
	debris.AddItem(slash, 4)

	EmitParticles(slash)



	wait(0.683)

	spawn(function()
		local slash = script.Move2:FindFirstChild("slash1"):Clone()
		slash.Parent = effectsfolder
		slash.Part.CFrame = rt.CFrame * CFrame.new(0, 0.8, -0.5)
		debris.AddItem(slash, 4)

		-- Ajuste: mantém a rotação de 'rt' e move para a posição de 'pos'
		tween_service:Create(slash.Part, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), 
			{CFrame = CFrame.new(pos.Position) * CFrame.Angles(rt.CFrame:ToEulerAnglesXYZ())}):Play()
		wait(0.275)

		EmitParticles(slash.Part)

		tween_service:Create(slash.Part.aa, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.bb, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.cc, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.dd, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()

		emit.enablevfx(slash, false)
	end)

	wait(0.417)

	spawn(function()
		local slash = script.Move2:FindFirstChild("slash2"):Clone()
		slash.Parent = effectsfolder
		slash.Part.CFrame = rt.CFrame * CFrame.new(0, 0.8, -0.5)
		debris.AddItem(slash, 4)

		-- Ajuste: mantém a rotação de 'rt' e move para a posição de 'pos'
		tween_service:Create(slash.Part, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), 
			{CFrame = CFrame.new(pos.Position) * CFrame.Angles(rt.CFrame:ToEulerAnglesXYZ())}):Play()
		wait(0.275)

		EmitParticles(slash.Part)

		tween_service:Create(slash.Part.aa, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.bb, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.cc, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.dd, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()

		emit.enablevfx(slash, false)
	end)
	wait(0.333)

	spawn(function()
		local slash = script.Move2:FindFirstChild("slash1"):Clone()
		slash.Parent = effectsfolder
		slash.Part.CFrame = rt.CFrame * CFrame.new(0, 0.8, -0.5)
		debris.AddItem(slash, 4)

		-- Ajuste: mantém a rotação de 'rt' e move para a posição de 'pos'
		tween_service:Create(slash.Part, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), 
			{CFrame = CFrame.new(pos.Position) * CFrame.Angles(rt.CFrame:ToEulerAnglesXYZ())}):Play()
		wait(0.275)

		EmitParticles(slash.Part)

		tween_service:Create(slash.Part.aa, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.bb, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.cc, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()
		tween_service:Create(slash.Part.dd, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Width0 = 0, Width1 = 0}):Play()

		emit.enablevfx(slash, false)
	end)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
