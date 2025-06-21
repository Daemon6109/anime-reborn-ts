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
	HitDelay = .3, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .3, -- delay between hits in a multi-hit move
	CustomDelay = {
		[3] = 1.2,
	},
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end




function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	
	tween_service:Create(unit.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0}):Play()
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Stand = script.Move3:FindFirstChild("stand"):Clone()
	Stand.Parent = effectsfolder
	Stand.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(0,0,2)
	local rtf = Stand:WaitForChild("HumanoidRootPart")
	local hrpcff = rtf.CFrame
	
	debris.AddItem(Stand,3.65)
	
	tween_service:Create(Stand.Handle,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()

	AnimModule.PlayAnim(script.Animation3Stand, Stand, 1, "", {Weight = 2, Fade = .15})


	task.wait(0.3)

	local Shoot = script.Move3.Shoot:Clone()
	Shoot.Parent = effectsfolder
	Shoot.CFrame = rt.CFrame * CFrame.new(0,0,-5)
	for _, particle in pairs(Shoot:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end
	debris.AddItem(Shoot,3.8)

	task.delay(0.27,function()
		for _, particle in pairs(Shoot:GetDescendants()) do
			if particle:IsA("ParticleEmitter") then
				particle:Emit(particle:GetAttribute("EmitCount"))
			end
		end
	end)


	task.wait(0.7)

	local Emit1 = script.Move3.Emit1:Clone()
	Emit1.Parent = effectsfolder
	local rotation = CFrame.Angles(math.rad(0), math.rad(90), math.rad(90))
	Emit1.CFrame = rtf.CFrame * rotation * CFrame.new(0,0,0)
	for _, particle in pairs(Emit1:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end
	debris.AddItem(Emit1,3.8)

	local EmitText = script.Move3.EmitText:Clone()
	EmitText.Parent = effectsfolder
	EmitText.CFrame = rt.CFrame * CFrame.new(0,0,0)
	for _, particle in pairs(EmitText:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end
	debris.AddItem(EmitText,3.8)

	tween_service:Create(Stand.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0}):Play()

	task.wait(0.3)

	tween_service:Create(Stand.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()

	task.wait(0.2)

	task.delay(0.35,function()
		local Explosion = script.Move3.Explosion:Clone()
		Explosion.Parent = effectsfolder
		local rotation = CFrame.Angles(math.rad(0), math.rad(90), math.rad(0))
		Explosion.CFrame = rtf.CFrame * rotation * CFrame.new(2,-1.3,0)
		for _, particle in pairs(Explosion:GetDescendants()) do
			if particle:IsA("ParticleEmitter") then
				particle:Emit(particle:GetAttribute("EmitCount"))
			end
		end
	end)

	task.delay(0.9,function()
		local Explosion = script.Move3.Explosion:Clone()
		Explosion.Parent = effectsfolder
		local rotation = CFrame.Angles(math.rad(0), math.rad(90), math.rad(0))
		Explosion.CFrame = rtf.CFrame * rotation * CFrame.new(2,-1.3,0)
		debris.AddItem(Explosion,3.8)

		for _, particle in pairs(Explosion:GetDescendants()) do
			if particle:IsA("ParticleEmitter") then
				particle:Emit(particle:GetAttribute("EmitCount"))
			end
		end
	end)

	local Info = TweenInfo.new(0.1)
	tween_service:Create(rtf, Info, {CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) }):Play()

	task.wait(1.3)

	tween_service:Create(unit.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 0}):Play()


	for _, particle in pairs(Shoot:GetDescendants()) do
		if particle:IsA("ParticleEmitter") then
			particle:Emit(particle:GetAttribute("EmitCount"))
		end
	end

	task.wait(.65)

	tween_service:Create(unit.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()
	local tp = script:FindFirstChild("Appear"):Clone()
	tp.Parent = effectsfolder
	tp.CFrame = rt.CFrame
	emit.emitvfx(tp)
	debris.AddItem(tp,2)

	local tp2 = script:FindFirstChild("Appear"):Clone()
	tp2.Parent = effectsfolder
	tp2.CFrame = Stand.HumanoidRootPart.CFrame
	emit.emitvfx(tp2)
	debris.AddItem(tp2,2)

	tween_service:Create(unit.Handle, TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0), {Transparency = 1}):Play()


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
