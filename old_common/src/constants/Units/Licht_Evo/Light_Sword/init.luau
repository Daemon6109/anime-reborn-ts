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
	HitDelay = 1.8, -- seconds
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

function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	spawn(function()
		local centerPosition = pos.Position
		local radius = 14
		local swords = {}
		local swordCount = 15

		for i = 1, swordCount do
			spawn(function()
				local bbe = script.Attack2:FindFirstChild("Sword"):Clone()

				local angle = (i / swordCount) * (2 * math.pi)
				local x = math.cos(angle) * radius
				local z = math.sin(angle) * radius

				local size1 = bbe.Size.X
				local size2 = bbe.Size.Y
				local size3 = bbe.Size.Z

				bbe.Size = Vector3.new(0, 0, 0)

				local shoottween = tween_service:Create(bbe, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0, false, 0), {Size = Vector3.new(size1, size2 * 1.5, size3)})
				shoottween:Play()

				local circlePosition = centerPosition + Vector3.new(x, math.random(1, 4), z)

				local lookAtCFrame = CFrame.new(circlePosition, centerPosition)
				local tilt = CFrame.Angles(math.rad(math.random(89, 92)), 0, 0)

				bbe.CFrame = lookAtCFrame * tilt

				bbe.Parent = effectsfolder
				table.insert(swords, bbe)
				debris.AddItem(bbe, 3)

				EmitParticles(bbe)
			end)
			task.wait(0.035)
		end

		task.wait(0.8)
		for _, sword in ipairs(swords) do
			spawn(function()
				if sword and sword:IsDescendantOf(workspace) then
					local direction = (centerPosition - sword.Position).Unit
					local distance = (centerPosition - sword.Position).Magnitude + math.random(-1,2)
					local targetCFrame = sword.CFrame + direction * distance

					local tween = tween_service:Create(sword, TweenInfo.new(0.12, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {CFrame = targetCFrame})
					tween:Play()

					task.wait(0.4)

					local shrinkTween = tween_service:Create(sword, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Size = Vector3.new(0, 0, 0)})
					shrinkTween:Play()
				end
			end)
		end

		task.wait(0.1)

		local ser = script.Attack2:FindFirstChild("Ser"):Clone()
		ser.CFrame = pos.CFrame * CFrame.new(0,1.2,0)
		ser.Parent = effectsfolder
		debris.AddItem(ser,4)

		EmitParticles(ser)
	end)	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
