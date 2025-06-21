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
	HitDelay = 1.1, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
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
	
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1.2, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.2)
	
	
	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = CFrame.lookAt(rt.Position, pos.Position) + Vector3.new(0,3.5,0)})
	TweenCompletepo:Play()

	local jump = script.Jump:Clone()
	jump.Position = rt.Position + Vector3.new(0,-1,0)
	jump.Parent = effectsfolder
	debris.AddItem(jump,5)
	emit.emitvfx(jump)
	
	task.wait(.3)
	
	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = CFrame.lookAt(rt.Position, pos.Position + Vector3.new(0,-6,0))})
	TweenCompletepo:Play()
	local float = script.Float:Clone()
	float.Position = rt.Position + Vector3.new(0,-1.2,0)
	float.Parent = effectsfolder
	debris.AddItem(float,5)
	emit.emitvfx(float)
	emit.enablevfx(float,true)
	
	task.wait(.2)
	
	for i=0,4,1 do
		task.wait(.1)
		task.spawn(function()

			local Bullet = script.Bulelt:Clone()
			Bullet.CFrame = rt.CFrame + (rt.CFrame.LookVector * .5) + (rt.CFrame.RightVector * .5)
			Bullet.Parent = effectsfolder
			debris.AddItem(Bullet,5)
			emit.emitvfx(unit.Gun.cube.FlashGreen)

			local TweenCompletepo = tween_service:Create(Bullet,TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = CFrame.lookAt(pos.Position, pos.Position+SavedDirection) + (rt.CFrame.LookVector * math.random(-3,3)) + Vector3.new(math.random(-3,3),math.random(-1.5,1.5),math.random(-3,3))})
			TweenCompletepo:Play()
	
			task.wait(.15)

			local Impact = script.BulletimpactAtk2:Clone()
			Impact.Position = Bullet.Position
			Impact.Parent = effectsfolder
			debris.AddItem(Impact,5)
			emit.emitvfx(Impact)

			Bullet.Transparency = 1
			emit.enablevfx(Bullet,false)

		end)
	end
	
	
	local TweenCompletepo = tween_service:Create(rt,TweenInfo.new(.15,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = startpos})
	TweenCompletepo:Play()
	emit.enablevfx(float,false)

	emit.emitvfx(jump)


	


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
