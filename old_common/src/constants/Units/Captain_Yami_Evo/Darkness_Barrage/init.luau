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
	HitDelay = .8, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	task.wait(.3)
	
	local main = script["Main"]:Clone()
	main.PrimaryPart.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	main.Parent = effectsfolder
	debris.AddItem(main,13)
	
	task.wait(.1)
	for _, ins in pairs(main.rootpart:GetDescendants()) do
		ins:Destroy()
	end	
		
	main["first projectile"].Anchored = true
	main["third projectile"].Anchored = true

	main["second projectile"].Anchored = true
	main["fourth projectile"].Anchored = true

	task.spawn(function()
		emit.enablevfx(main["first projectile"],true)
		
		local TweenCompletepo = tween_service:Create(main["first projectile"],TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = main["first projectile"].CFrame + (rt.CFrame.LookVector * 18) })
		TweenCompletepo:Play()
		task.wait(.3)
		emit.enablevfx(main["first projectile"],false)
		emit.emitvfx(main["first projectile"].Fina)
		
	end)
	task.wait(.2)
	task.spawn(function()

		emit.enablevfx(main["second projectile"],true)
		local TweenCompletepo = tween_service:Create(main["second projectile"],TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = main["second projectile"].CFrame + (main["second projectile"].CFrame.LookVector * 18) })
		TweenCompletepo:Play()
		task.wait(.3)
		emit.enablevfx(main["second projectile"],false)
		emit.emitvfx(main["second projectile"].Fina)

	end)
	task.wait(.2)

	task.spawn(function()

		emit.enablevfx(main["fourth projectile"],true)
		local TweenCompletepo = tween_service:Create(main["fourth projectile"],TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = main["fourth projectile"].CFrame + (main["fourth projectile"].CFrame.LookVector * 18) })
		TweenCompletepo:Play()
		task.wait(.3)
		emit.enablevfx(main["fourth projectile"],false)
		emit.emitvfx(main["fourth projectile"].Fina)

	end)
	task.wait(.2)

	task.spawn(function()

		emit.enablevfx(main["third projectile"],true)
		local TweenCompletepo = tween_service:Create(main["third projectile"],TweenInfo.new(.3,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{CFrame = main["third projectile"].CFrame + (main["third projectile"].CFrame.LookVector * 18) })
		TweenCompletepo:Play()
		task.wait(.3)
		emit.enablevfx(main["third projectile"],false)
		emit.emitvfx(main["third projectile"].Fina)

	end)

	task.wait(2)
end
	


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
