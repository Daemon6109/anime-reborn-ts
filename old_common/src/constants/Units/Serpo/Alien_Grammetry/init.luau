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
	HitDelay = 1.5, -- seconds
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
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.spawn(function()
		for i=0,6,1 do
			task.wait(.06)
			emit.bezier(unit["Left Arm"].CFrame,ColorSequence.new(Color3.fromRGB(96, 255, 78)),0.00000000005,.5,"Mid",true,10,1,1.1)
		end
	end)

	task.wait(.6)



	local shoot = script.Serpo2Shoot:Clone()
	shoot.CFrame = rt.CFrame + (rt.CFrame.LookVector * -.5) + Vector3.new(0,.3,0)
	shoot.Parent = effectsfolder
	debris.AddItem(shoot,3)
	emit.emitvfx(shoot)	



	local MainProjectile = script.Serpo2Proj:Clone()
	MainProjectile.CFrame = rt.CFrame + (rt.CFrame.LookVector * -.5) + Vector3.new(0,.6,0)
	MainProjectile.Parent = effectsfolder
	debris.AddItem(MainProjectile,3)
	EmitParticles(MainProjectile,true)	

	local TweenComplete = tween_service:Create(MainProjectile,TweenInfo.new(.4,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{Position = pos.Position})
	TweenComplete:Play()
	
	task.wait(.4)
	
	local destroy = script.Serpo2ProjEnd:Clone()
	destroy.Position = MainProjectile.Position
	destroy.Parent = effectsfolder
	debris.AddItem(destroy,3)
	emit.emitvfx(destroy)	

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
