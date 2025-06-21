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
	HitDelay = 1.25, -- seconds
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
local run_service = game:GetService("RunService")

local function QuadraticBezier(t,p0,p1,p2)
	return (1-t)^2*p0+2*(1-t)*t*p1+t^2*p2
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	task.wait(0.3)

	for _, particle in pairs(unit.Ball:GetDescendants()) do
		if particle:IsA("ParticleEmitter") or particle:IsA("Beam") then
			spawn(function()
				particle.Enabled = true
			end)
		end
	end

	task.wait(0.5)

	for _, particle in pairs(unit.Ball:GetDescendants()) do
		if particle:IsA("ParticleEmitter") or particle:IsA("Beam") then
			spawn(function()
				particle.Enabled = false
			end)
		end
	end

	spawn(function()
		spawn(function()
			local Charge = script.Move1.Ball:Clone()
			Charge.Parent = effectsfolder
			Charge.CFrame = rt.CFrame * CFrame.new(0, 0, 0)

			task.spawn(function()
				local StartPos = Charge:GetPivot().Position
				local CurvePos = (Charge:GetPivot().Position + pos.Position) / 2 + Vector3.new(math.random(0,0)*math.random(1,20),20,math.random(0,0)*math.random(1,20))
				local EndPos = pos.Position

				local Value = 0

				local Connection; Connection = run_service.Heartbeat:Connect(function(et)
					local TargetPosition = QuadraticBezier(Value , StartPos, CurvePos, EndPos);
					Charge:PivotTo(CFrame.new(TargetPosition));

					Value += et * 2.2
				end)
				task.delay(0.5, function()
					Connection:Disconnect()
				end)
			end)

			task.delay(0.2, function()
				Charge:PivotTo(pos.CFrame * CFrame.new(0, 0, 0))
				game.Debris:AddItem(Charge,0.5)
			end)

			task.wait(0.5)
			local Explosion = script.Move1.Explosion:Clone()
			Explosion.Parent = effectsfolder
			Explosion.CFrame = pos.CFrame * CFrame.new(0,-1.1,0)
			for _, particle in pairs(Explosion:GetDescendants()) do
				if particle:IsA("ParticleEmitter") then
					particle:Emit(particle:GetAttribute("EmitCount"))
				end
			end
			game.Debris:AddItem(Explosion,3)
		end)
	end)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
