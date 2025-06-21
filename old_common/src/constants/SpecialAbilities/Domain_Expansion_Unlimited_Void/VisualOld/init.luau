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
local Animations = script.Parent.Animations
local Mesh = script.Mesh
local Sound = script.Parent.Sound
local Scaler = require(Replicated.Libs.VFX_Scale)
local effectsfolder = workspace.Effects
local LightingMaster = require(Replicated:WaitForChild("Libs"):WaitForChild("LightingMaster"))
local FoundLightingSetting = Replicated:WaitForChild("LightingDirectory"):WaitForChild(script.Parent.Name)

module.config = {
	HitDelay = 2.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[1] = .35,
	--},
	ScaleFactor = 1,
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

function module.Effect(Tab)
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	unit.Folder.hair.hair.Transparency = 0
	unit.hairbaixo.Transparency = 1

	local animation = AnimModule.PlayAnim(Animations.Expansion, unit, 1, "GojoDomain")
	wait(.5)
	SoundWrapper:PlaySound(Sound.cape2, rt, Replicated.SoundGroups.UnitSFX)

	wait(.2)

	EmitParticles(unit.Head)

	unit.Folder.hair.hair.Transparency = 1
	unit.hairbaixo.Transparency = 0
	
	SoundWrapper:PlaySound(Sound["Gojo domain expansion"], rt, Replicated.SoundGroups.UnitSFX)
	wait(1.8)
	SoundWrapper:PlaySound(Sound.muryo, rt, Replicated.SoundGroups.UnitSFX)
	wait(.8)
	SoundWrapper:PlaySound(Sound.expansionsfx, rt, Replicated.SoundGroups.UnitSFX)

	local white = Mesh:FindFirstChild("white"):Clone()
	debris.AddItem(white,10)
	white.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	white.Parent = effectsfolder

	local particles = Mesh:FindFirstChild("particles"):Clone()
	debris.AddItem(particles,6)
	particles.CFrame = rt.CFrame * CFrame.new(0,10,20)
	particles.Parent = effectsfolder

	local expansion = Mesh:FindFirstChild("expansion"):Clone()
	debris.AddItem(particles,12)
	expansion.RootPart.CFrame = rt.CFrame * CFrame.new(0,-1,0)

	local BloomEffect = Instance.new("BloomEffect")
	BloomEffect.Parent = game.Lighting
	debris.AddItem(BloomEffect,4)


	SetParticlesEnabled(particles,true)
	--spawn(function()
	--	local tweenInfo = TweenInfo.new(
	--		.7,  
	--		Enum.EasingStyle.Linear, 
	--		Enum.EasingDirection.Out, 
	--		0, 
	--		false, 
	--		0 
	--	)

	--	local originalFOV = game.Workspace.CurrentCamera.FieldOfView

	--	local function changeFOV(newFOV)

	--		local fovTween = tween_service:Create(
	--			game.Workspace.CurrentCamera,
	--			tweenInfo,
	--			{ FieldOfView = newFOV }
	--		)


	--		local returnTween = tween_service:Create(
	--			game.Workspace.CurrentCamera,
	--			tweenInfo,
	--			{ FieldOfView = originalFOV }
	--		)


	--		fovTween:Play()
	--		fovTween.Completed:Wait()

	--		wait(.35)

	--		returnTween:Play()
	--	end

	--	changeFOV(25)
	--end)
	wait(.5)

	tween_service:Create(BloomEffect, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Intensity = 25}):Play()

	wait(0.4)

	LightingMaster:SetLighting(FoundLightingSetting, true)

	tween_service:Create(white, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	tween_service:Create(BloomEffect, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Intensity = 1}):Play()
	expansion.Parent = effectsfolder

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local goal = {Color = Color3.new(0, 0, 0)}
	game:GetService("TweenService"):Create(expansion.black, tweenInfo, goal):Play()


	local emitters = expansion:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("Beam") then
			emitters[i].Enabled = true
		end
	end
	spawn(function()

		local function tweenTransparency(objects, targetTransparency, duration)
			for _, obj in ipairs(objects) do
				if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("Texture") then
					local currentTransparency = obj.Transparency
					local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
					local goal = {Transparency = targetTransparency}
					local tween = tween_service:Create(obj, tweenInfo, goal)
					tween:Play()
				end
			end
		end

		local function getAllParts()
			local parts = {}
			for _, obj in ipairs(workspace.Map:GetDescendants()) do -- MAP FILE HERE --
				if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("Texture") then
					table.insert(parts, obj)
				end
			end
			
			for _, obj in ipairs(workspace.GroundPlacements:GetDescendants()) do -- MAP FILE HERE --
				if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("Texture") then
					table.insert(parts, obj)
				end
			end
			
			for _, obj in ipairs(workspace.AirPlacements:GetDescendants()) do -- MAP FILE HERE --
				if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Decal") or obj:IsA("Texture") then
					table.insert(parts, obj)
				end
			end
			
			return parts
		end

		local function storeOriginalTransparencies(parts)
			local originalTransparencies = {}
			for _, part in ipairs(parts) do
				table.insert(originalTransparencies, part.Transparency)
			end
			return originalTransparencies
		end

		local parts = getAllParts()

		local originalTransparencies = storeOriginalTransparencies(parts)


		tweenTransparency(parts, 1, 0.5)




		unit.Folder.hair.hair.Transparency = 0
		unit.hairbaixo.Transparency = 1

		wait(6)
		for i, part in ipairs(parts) do
			local originalTransparency = originalTransparencies[i]
			tweenTransparency({part}, originalTransparency, 0.5)
		end
	end)



	tween_service:Create(particles, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = Vector3.new(70,35,70)}):Play()
	wait(.25)
	EmitParticles(expansion)
	tween_service:Create(white, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	tween_service:Create(expansion.gargantua1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	tween_service:Create(expansion.black, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	SetParticlesEnabled(expansion,true)
	wait(.25)
	SetParticlesEnabled(particles,false)
	wait(4.3)
	tween_service:Create(white, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()

	SetParticlesEnabled(expansion,false)
	local emitters = expansion:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("Beam") then
			emitters[i].Enabled = false
		end
	end
	tween_service:Create(expansion.gargantua1, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	wait(0.2)
	tween_service:Create(expansion.black, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	wait(0.5)
	SoundWrapper:PlaySound(Sound.bless09, rt, Replicated.SoundGroups.UnitSFX)
	expansion:Destroy()
	wait(0.1)

	tween_service:Create(white, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	LightingMaster:RestoreOriginalLighting(true)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
