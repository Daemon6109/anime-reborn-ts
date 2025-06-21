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
	HitDelay = 2.1, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation4, unit, 1.3, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	task.wait(0.6)

	spawn(function()

		local sword = script.Attack4:FindFirstChild("Slash"):Clone()
		sword.CFrame = rt.CFrame * CFrame.new(0,3,-4)
		sword.Orientation = rt.Orientation + Vector3.new(0, 0, -25)
		sword.Parent = rt
		debris.AddItem(sword,3)

		for i, v in ipairs(sword:GetDescendants()) do
			if v:IsA("Beam") then

				local Wd0 = v.Width0
				local Wd1 = v.Width1
				local Txt = v.TextureLength

				v.Width0 = 0
				v.Width1 = 0
				v.TextureLength = 0

				task.wait(0.01)

				local Tween = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Width0 = Wd0, Width1 = Wd1, TextureLength = Txt}):Play()

			end
		end

		EmitParticles(sword)

	end)

	task.wait(0.3)

	spawn(function()

		local sword = script.Attack4:FindFirstChild("Slash"):Clone()
		sword.CFrame = rt.CFrame * CFrame.new(0,3,-4)
		sword.Orientation = rt.Orientation + Vector3.new(0, 0, 35)
		sword.Parent = rt
		debris.AddItem(sword,3)


		for i, v in ipairs(sword:GetDescendants()) do
			if v:IsA("Beam") then

				local Wd0 = v.Width0
				local Wd1 = v.Width1
				local Txt = v.TextureLength

				v.Width0 = 0
				v.Width1 = 0
				v.TextureLength = 0

				task.wait(0.01)

				local Tween = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Width0 = Wd0, Width1 = Wd1, TextureLength = Txt}):Play()

			end
		end

		spawn(function()

			task.wait(0.2)

			for i, v in ipairs(sword:GetDescendants()) do
				if v:IsA("ParticleEmitter") then

					local timeS = v.TimeScale 

					local Tween = tween_service:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {TimeScale = 0}):Play()

					task.wait(0.4)

					local Tween = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {TimeScale = timeS}):Play()


				end
			end

		end)

		EmitParticles(sword)

	end)

	task.wait(0.6)

	for i, v in ipairs(rt:GetDescendants()) do
		if v.name == "Slash" then
			coroutine.wrap(function()

				for i, v in ipairs(v:GetDescendants()) do
					if v:IsA("Beam") then

						local Tween = tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Width0 = v.Width0 * 4, Width1 = v.Width1 * 4}):Play()

					end
				end

				local Length2 = (v.Position - pos.Position).magnitude

				local Tween = tween_service:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = v.CFrame * CFrame.new(0,0,-Length2)}):Play()

				for i, v in ipairs(v:GetDescendants()) do
					if v:IsA("Beam") then

						local Tween = tween_service:Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {Width0 = 0, Width1 = 0, TextureLength = 0.1, TextureSpeed = 1.5}):Play()

					end
				end


			end)()
		end
	end

	task.wait(0.1)

	local ter = script.Attack4:FindFirstChild("ter"):Clone()
	ter.ter.CFrame = pos.CFrame * CFrame.new(0,1.2,0)
	ter.AuraPressure.CFrame = pos.CFrame * CFrame.new(0,-0.3,0)
	ter.Parent = rt
	debris.AddItem(ter,3)

	EmitParticles(ter)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
