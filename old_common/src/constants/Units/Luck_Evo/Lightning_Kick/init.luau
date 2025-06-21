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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local tpeffect = script.TpEffect:Clone()
	tpeffect.Parent = effectsfolder
	tpeffect.CFrame = rt.CFrame
	for _,s in pairs(tpeffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(tpeffect,5)

	task.wait(0.05)

	rt.CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection)

	local tpeffect = script.TpEffect:Clone()
	tpeffect.Parent = effectsfolder
	tpeffect.CFrame = rt.CFrame
	for _,s in pairs(tpeffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(tpeffect,5)

	rt.CFrame = rt.CFrame * CFrame.Angles(0,math.rad(180),0)


	task.wait(0.4)

	local slam = script.SlamVFX:Clone()
	slam.Parent = effectsfolder
	slam.CFrame = rt.CFrame * CFrame.new(0,-1,-2)
	for _,s in pairs(slam:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(slam,5)

	local blurshock = script.Blurshock:Clone()
	blurshock.CFrame = rt.CFrame * CFrame.new(0,3,-2) * CFrame.Angles(0, math.rad(180), 0)
	blurshock.Parent  = effectsfolder
	debris.AddItem(blurshock,5)

	local swirl = script.Swirl:Clone()
	swirl.CFrame = rt.CFrame * CFrame.new(0,3,-2) 
	swirl.Parent  = effectsfolder
	debris.AddItem(swirl,5)

	local mesh = script.Mesh:Clone()
	mesh.Parent = effectsfolder
	mesh.CFrame = rt.CFrame * CFrame.new(0,2,-2) * CFrame.Angles(0,0,0)
	tween_service:Create(mesh, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
		Size = Vector3.new(0, 20.484, 0),
	}):Play()
	debris.AddItem(mesh,5)


	task.delay(0.4, function()
		mesh:Destroy()
	end)

	tween_service:Create(blurshock.SpecialMesh, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
		Scale = Vector3.new(-0.085, -0.05, -0.085),
		Offset = Vector3.new(0, -2.5, 0),
		VertexColor = Vector3.one
	}):Play()

	tween_service:Create(blurshock, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
		Transparency = 1
	}):Play()

	tween_service:Create(swirl, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
		Size = Vector3.new(20, 6, 20),
		Transparency = 1,
		CFrame = swirl.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(0, math.rad(-90), 0)
	}):Play()

	task.wait(0.4)

	local tpeffect = script.TpEffect:Clone()
	tpeffect.Parent = effectsfolder
	tpeffect.CFrame = rt.CFrame
	for _,s in pairs(tpeffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(tpeffect,5)

	task.wait(0.05)

	rt.CFrame = rt.CFrame + rt.CFrame.LookVector * 18
	local tpeffect = script.TpEffect:Clone()
	tpeffect.Parent = effectsfolder
	tpeffect.CFrame = rt.CFrame
	for _,s in pairs(tpeffect:GetDescendants()) do
		if s:IsA("ParticleEmitter") then
			s:Emit(s.Rate)
		end
	end
	debris.AddItem(tpeffect,5)

	rt.CFrame = rt.CFrame * CFrame.Angles(0,math.rad(180),0)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
