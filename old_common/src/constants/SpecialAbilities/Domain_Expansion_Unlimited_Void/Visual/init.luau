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
local Camshaker = require(game.ReplicatedStorage:WaitForChild("Libs"):WaitForChild("CameraShaker"))
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
	if not part or not part.Parent then return end
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

local camShake = Camshaker.new(Enum.RenderPriority.Camera.Value, function(shakeCFrame)
	game.Workspace.Camera.CFrame = game.Workspace.Camera.CFrame * shakeCFrame
end)

camShake:Start()

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	unit.Folder.hair.hair.Transparency = 0
	unit.hairbaixo.Transparency = 1

	local animation = AnimModule.PlayAnim(Animations.Expansion, unit, 1, "GojoDomain")

	task.wait(.25)	

	SoundWrapper:PlaySound(Sound["Gojo domain expansion"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.25)
	SoundWrapper:PlaySound(Sound.cape2, rt, Replicated.SoundGroups.UnitSFX)

	task.wait(.2)

	EmitParticles(unit.Head)

	unit.Folder.hair.hair.Transparency = 1
	unit.hairbaixo.Transparency = 0
	SetParticlesEnabled(unit.Torso["CursedEnergy(Domain)"],true)

	unit.Torso.DomainExpansionText:FindFirstChild("1").aa:Emit(1)
	--SoundWrapper:PlaySound(Sound["Gojo domain expansion"], rt, Replicated.SoundGroups.UnitSFX)
	task.wait(1.8)

	local aura = Mesh:FindFirstChild("Domainstartatgojo"):Clone()
	debris.AddItem(aura,6)
	aura.CFrame = rt.CFrame + (rt.CFrame.LookVector * .01) + Vector3.new(0,0.15,0)
	aura.Parent = effectsfolder
	SetParticlesEnabled(aura,true)
	EmitParticles(aura)

	if unit:FindFirstChild("Torso") then
		unit.Torso.DomainExpansionText:FindFirstChild("2").aa:Emit(1)
	end

	task.wait(.8)

	local white = Mesh:FindFirstChild("white"):Clone()
	debris.AddItem(white,10)
	white.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	white.Parent = effectsfolder

	local particles = Mesh:FindFirstChild("particles"):Clone()
	debris.AddItem(particles,6)
	particles.rootpart.CFrame = rt.CFrame * CFrame.new(0,2.5,0)
	particles.Parent = effectsfolder

	camShake:ShakeSustain(Camshaker.Presets.Explosion)

	local expansion = Mesh:FindFirstChild("expansion"):Clone()
	debris.AddItem(particles,12)
	expansion.RootPart.CFrame = rt.CFrame * CFrame.new(0,-1,0)



	SetParticlesEnabled(particles,true)
	task.spawn(function()
		local tweenInfo = TweenInfo.new(
			1.1,  
			Enum.EasingStyle.Linear, 
			Enum.EasingDirection.Out, 
			0, 
			false, 
			0 
		)
		local tweenInfo2 = TweenInfo.new(
			.5,  
			Enum.EasingStyle.Quart, 
			Enum.EasingDirection.Out, 
			0, 
			false, 
			0 
		)
		local originalFOV = game.Workspace.CurrentCamera.FieldOfView

		local function changeFOV(newFOV)

			local fovTween = tween_service:Create(
				game.Workspace.CurrentCamera,
				tweenInfo,
				{ FieldOfView = newFOV }
			)


			local returnTween = tween_service:Create(
				game.Workspace.CurrentCamera,
				tweenInfo2,
				{ FieldOfView = originalFOV }
			)


			fovTween:Play()
			fovTween.Completed:Wait()

			task.wait(.35)

			camShake:StopSustained(.75)

			returnTween:Play()
		end

		changeFOV(133)
	end)
	task.wait(.5)



	task.wait(0.4)

	LightingMaster:SetLighting(FoundLightingSetting, true)

	tween_service:Create(white, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()

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
	task.spawn(function()

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

		task.wait(6)
		for i, part in ipairs(parts) do
			local originalTransparency = originalTransparencies[i]
			tweenTransparency({part}, originalTransparency, 0.5)
		end
	end)



	task.wait(.25)
	EmitParticles(expansion)
	SetParticlesEnabled(aura,false)

	tween_service:Create(white, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	tween_service:Create(expansion.gargantua1, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	tween_service:Create(expansion.black, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	SetParticlesEnabled(expansion,true)
	task.wait(.5)
	SetParticlesEnabled(particles,false)
	task.wait(3.8)
	tween_service:Create(white, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()

	SetParticlesEnabled(expansion,false)
	if unit:FindFirstChild("Torso") then
		SetParticlesEnabled(unit.Torso["CursedEnergy(Domain)"],false)
	end

	local emitters = expansion:GetDescendants()
	for i = 1, #emitters do
		if emitters[i]:IsA("Beam") then
			emitters[i].Enabled = false
		end
	end
	tween_service:Create(expansion.gargantua1, TweenInfo.new(.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	task.wait(0.2)
	tween_service:Create(expansion.black, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	task.wait(0.5)
	expansion:Destroy()
	task.wait(0.1)

	tween_service:Create(white, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	LightingMaster:RestoreOriginalLighting(true)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
