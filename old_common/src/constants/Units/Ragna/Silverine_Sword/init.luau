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
	
	local ANIMM = AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	

	local Length = (rt.Position - pos.Position).magnitude - 1
	local back = rt.CFrame

	task.wait(0.4)

	spawn(function()

		local d1 = 3

		for i= 1,4 do

			spawn(function()

				local a2 = pos.CFrame * CFrame.new(math.random(-5,5),math.random(-1,2),math.random(-5,5))

				local sword = script.Attack2:FindFirstChild("Sword"):Clone()
				sword.CFrame = rt.CFrame * CFrame.new(-3 + math.random(-5,5)/10, d1, 0)
				sword.Orientation = rt.Orientation + Vector3.new(0, 90, 0)
				sword.Parent = effectsfolder

				local ttt = script.Attack2:FindFirstChild("Dee"):Clone()
				ttt.CFrame = a2
				ttt.Parent = effectsfolder
				debris.AddItem(ttt,4)

				debris.AddItem(sword, 4)
				EmitParticles(sword)

				-- Primeiro tween: girar para olhar para 'pos'
				local lookAtCFrame = CFrame.new(sword.Position, a2.Position) * CFrame.Angles(0, math.rad(90), 0)

				task.wait(0.3)

				local rotateTween = tween_service:Create(
					sword,
					TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
					{CFrame = lookAtCFrame}
				)
				rotateTween:Play()

				task.wait(0.3)

				local Tween = tween_service:Create(sword, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = sword.CFrame * CFrame.new(-3, 0, 0)}):Play()

				task.wait(0.2)

				local Length1 = (sword.Position - a2.Position).magnitude

				local Tween = tween_service:Create(sword, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = sword.CFrame * CFrame.new(Length1, 0, 0)}):Play()

				task.wait(0.1)

				EmitParticles(ttt)

				task.wait(1.05)

				local Tween = tween_service:Create(sword, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Transparency = 1}):Play()



			end)

			spawn(function()

				local a2 = pos.CFrame * CFrame.new(math.random(-5,5),math.random(-1,2),math.random(-5,5))

				local sword = script.Attack2:FindFirstChild("Sword"):Clone()
				sword.CFrame = rt.CFrame * CFrame.new(3 + math.random(-5,5)/10, d1, 0)
				sword.Orientation = rt.Orientation + Vector3.new(0, 90, 0)
				sword.Parent = effectsfolder

				local ttt = script.Attack2:FindFirstChild("Dee"):Clone()
				ttt.CFrame = a2
				ttt.Parent = effectsfolder
				debris.AddItem(ttt,4)

				debris.AddItem(sword, 4)
				EmitParticles(sword)

				-- Primeiro tween: girar para olhar para 'pos'
				local lookAtCFrame = CFrame.new(sword.Position, a2.Position) * CFrame.Angles(0, math.rad(90), 0)

				task.wait(0.3)


				local rotateTween = tween_service:Create(
					sword,
					TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
					{CFrame = lookAtCFrame}
				)
				rotateTween:Play()

				task.wait(0.3)

				local Tween = tween_service:Create(sword, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = sword.CFrame * CFrame.new(-3, 0, 0)}):Play()

				task.wait(0.2)

				local Length1 = (sword.Position - a2.Position).magnitude

				local Tween = tween_service:Create(sword, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = sword.CFrame * CFrame.new(Length1, 0, 0)}):Play()

				task.wait(0.1)

				EmitParticles(ttt)

				task.wait(1.05)

				local Tween = tween_service:Create(sword, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Transparency = 1}):Play()


			end)

			task.wait(0.1)

			d1 -= 1

		end

	end)

	task.wait(1.2)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
