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
local bezierModule = require(script.BezierModule)

module.config = {
	HitDelay = .7, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .9, -- delay between hits in a multi-hit move
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.3, "Mainaim", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Character = unit
	local startwater = script.NoelleMOvestart:Clone()
	startwater.Parent = effectsfolder
	startwater.CFrame = rt.CFrame + (rt.CFrame.LookVector * .6) 
	debris.AddItem(startwater,3)
	emit.enablevfx(startwater,true)

	task.wait(.6	)
	emit.enablevfx(startwater,false)

	local distance = 20

	local angles = { 0} -- Angles in radians for left, center, and right

	for _, angle in ipairs(angles) do
		task.spawn(function()
			-- Clone and set up the projectile
			local Water = script.Dragon:Clone()
			Water.Parent = effectsfolder
			Water:SetPrimaryPartCFrame(Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5))
			debris.AddItem(Water,4)
		
			-- Calculate the goal position with rotation applied
			local rotatedCFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(angle), 0) -- Rotate by the given angle
			local goal = {}
			goal.CFrame = rotatedCFrame * CFrame.new(0, 0, -distance) -- Move the projectile forward in the rotated direction

			-- Tween the projectile to the goal
			local info = TweenInfo.new(1)
			local tween = game.TweenService:Create(Water.PrimaryPart, info, goal)
			tween:Play()
			tween.Completed:Wait()

			-- Create the explosion effect at the final position
			local WaterA = script.MegaExplosion:Clone()
			WaterA.Parent = effectsfolder
			WaterA.CFrame = Water.WaterFront.CFrame
			task.wait(.1)
			emit.emitvfx(WaterA)
			debris.AddItem(WaterA,3)
			Water.Circle.Transparency = 1
			Water["Cube.002"].Transparency = 1
			Water.Sphere.Transparency = 1
			Water["untitled.001"].Transparency = 1

			emit.enablevfx(Water,false)

			SoundWrapper:PlaySound(script["Impacto"], rt, Replicated.SoundGroups.UnitSFX)
		
			-- Emit explosion effects
			for i, v in pairs(WaterA:GetDescendants()) do
				if v:IsA("Beam") or v:IsA("ParticleEmitter") then
					v:Emit(v:GetAttribute("EmitCount"))
				end
			end
		end)
	end

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
