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
	HitDelay = 2, -- seconds
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
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

local rand = Random.new()


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector
	
	local heartt = script.KissPistol:Clone()
	heartt.Parent = unit["Right Arm"]
	heartt.CFrame = unit["Right Arm"].CFrame * CFrame.new(0, -2, 0)

	local weld = Instance.new("Motor6D")
	weld.Parent = unit["Right Arm"]
	weld.Part0 = unit["Right Arm"]
	weld.Part1 = heartt
	weld.C1 = CFrame.new(0, 0.525, 0)

	local bullet = script.Bullet:Clone()
	bullet.Parent = effectsfolder
	debris.AddItem(heartt, 5)
	debris.AddItem(bullet, 5)



	task.wait(0.6)

	emit.enablevfx(heartt, true)
	EmitParticles(heartt[".main"].Impact)

	task.wait(1)

	bullet.CFrame = heartt.CFrame
	emit.enablevfx(heartt, false)
	EmitParticles(heartt[".main"].Impact)
	EmitParticles(heartt[".main"].Impact2)

	emit.enablevfx(bullet, true)

	local info = TweenInfo.new(.2,Enum.EasingStyle.Linear,Enum.EasingDirection.In)
	local tween = tween_service:Create(bullet,info,{Position = pos.Position})
	tween:Play()

	task.wait(0.2)

	EmitParticles(bullet)
	emit.enablevfx(bullet, false)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
