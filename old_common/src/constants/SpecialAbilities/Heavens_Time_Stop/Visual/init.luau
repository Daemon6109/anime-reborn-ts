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



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	

	local LoadAnim = unit.DIO.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation6))
	LoadAnim:Play()


	SoundWrapper:PlaySound(script["Move6sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	EmitParticles(unit.DIO.RootPart.emit)

	local colorcorrection = Instance.new("ColorCorrectionEffect")
	colorcorrection.Parent = game.Lighting
	debris.AddItem(colorcorrection,25)


	local tween_service = game:GetService("TweenService")
	local camera = workspace.CurrentCamera
	local original_fov = camera.FieldOfView -- Salva o FOV original

	-- Primeiro tween: vai para 100


	wait(1.5)
	tween_service:Create(camera, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {FieldOfView = 55}):Play()

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Brightness = 0.5}):Play()

	wait(0.1)

	EmitParticles(unit.DIO.BodyAura.adsasd)

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Brightness = -1}):Play()

	wait(0.05)

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.05,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Brightness = 0}):Play()
	local aa1 = script.Active:FindFirstChild("aa"):Clone()
	aa1.Parent = effectsfolder
	debris.AddItem(aa1,25)
	aa1.CFrame = rt.CFrame



	EmitParticles(aa1)

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = -1}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -3}):Play()
	wait(0.08)


	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = -6}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = 3}):Play()
	wait(0.08)

	tween_service:Create(camera, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {FieldOfView = 300}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = -3}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -3}):Play()
	wait(0.08)

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = -4}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -1}):Play()
	wait(0.08)


	tween_service:Create(camera, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {FieldOfView = 77}):Play()


	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = .35}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.075,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -2}):Play()

	wait(0.25)


	tween_service:Create(camera, TweenInfo.new(18, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {FieldOfView = 99}):Play()
	for i,v in aa1:GetDescendants() do
		if v:IsA("ParticleEmitter") then

			local shoottween = tween_service:Create(
				v, 
				TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
				{TimeScale = 0}
			)
			shoottween:Play()
		end
	end

	for i,v in aa1.bb:GetDescendants() do
		if v:IsA("ParticleEmitter") then

			local shoottween = tween_service:Create(
				v, 
				TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
				{TimeScale = 0.05}
			)
			shoottween:Play()
		end
	end

	wait(19)

	for i,v in aa1:GetDescendants() do
		if v:IsA("ParticleEmitter") then

			local shoottween = tween_service:Create(
				v, 
				TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
				{TimeScale = 1}
			)
			shoottween:Play()
		end
	end

	for i,v in aa1.bb:GetDescendants() do
		if v:IsA("ParticleEmitter") then

			local shoottween = tween_service:Create(
				v, 
				TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
				{TimeScale = 1}
			)
			shoottween:Play()
		end
	end
	tween_service:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {FieldOfView = original_fov}):Play()

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = -4}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -1}):Play()
	wait(0.1)

	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.15,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = -4}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.15,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -1}):Play()
	wait(0.15)
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.2,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = 1}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.2,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = -3}):Play()
	wait(0.25)


	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Contrast = 0}):Play()
	local aa = tween_service:Create(colorcorrection,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Saturation = 0}):Play()

	wait(0.1)

	colorcorrection:Destroy()
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
