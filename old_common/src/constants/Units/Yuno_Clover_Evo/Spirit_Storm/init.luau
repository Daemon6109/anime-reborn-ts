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
	HitDelay = 2.1, -- seconds
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
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local a = script.Move4:FindFirstChild("a"):Clone()
	a.aa.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	a.Parent = effectsfolder
	debris.AddItem(a,6)

	EmitParticles(a)

	wait(0.750)

	tween_service:Create(unit.sword, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	SetParticlesEnabled(unit.sword,true)
	tween_service:Create(unit.sword.Beam, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0.7}):Play()

	wait(1.01)




	local beam = script.Move4:FindFirstChild("beam"):Clone()
	beam.rootpart.CFrame = rt.CFrame * CFrame.new(0,1.4,.8)
	beam.rootpart.CFrame = CFrame.new(beam.rootpart.Position, pos.Position)
	beam.Parent = effectsfolder
	debris.AddItem(beam,6)

	local light1 = script.Move4:FindFirstChild("light1"):Clone()
	light1.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	light1.Parent = effectsfolder
	debris.AddItem(light1,5)

	local Model = script.Move4:FindFirstChild("Model"):Clone()

	Model.Parent = effectsfolder
	debris.AddItem(Model,6)

	local dash = script.Move4:FindFirstChild("dash"):Clone()
	dash.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	dash.Parent = effectsfolder
	debris.AddItem(dash,5)



	tween_service:Create(beam.rootpart.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 12}):Play()


	beam.start.a.sa:Emit(1)
	task.wait(0.01)

	beam.end1.Anchored = true

	dash.CFrame = rt.CFrame * CFrame.new(0,1.4,.8)

	dash.CFrame = CFrame.new(dash.Position, pos.Position + Vector3.new(0,-1.5,0))

	task.wait(0.01)

	SetParticlesEnabled(dash,true)


	Model.root.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	light1.CFrame = pos.CFrame * CFrame.new(0,-1,0)

	tween_service:Create(beam.end1, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = pos.CFrame * CFrame.new(0,-1.5,0)}):Play()

	tween_service:Create(beam.end1.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 12}):Play()

	beam.start.bbbb.a:Emit(1)

	wait(0.1)

	beam.end1.bbbb.a:Emit(1)

	SetParticlesEnabled(Model,true)

	EmitParticles(light1)

	wait(1)

	SetParticlesEnabled(dash,false)

	SetParticlesEnabled(Model,false)

	tween_service:Create(beam.end1.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 0}):Play()


	tween_service:Create(beam.rootpart.PointLight, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 0}):Play()


	for i, v in pairs(beam.end1:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.4,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end

	SetParticlesEnabled(beam,false)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
