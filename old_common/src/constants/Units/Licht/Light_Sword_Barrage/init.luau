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
	HitDelay = 1.6, -- seconds
	HitCount = 9, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
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
	local Mnainanim = AnimModule.PlayAnim(script.Animation1, unit, 1, "Mainanim", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Character = unit

	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	task.wait(1.3)

	spawn(function()

		local startTime = tick()  -- Marca o tempo inicial

		while (tick() - startTime) < 1.3 do

			spawn(function()

				local bbe = script.Attack1:FindFirstChild("Sword"):Clone()
				bbe.CFrame = rt.CFrame 
					* CFrame.Angles(math.rad(90), math.rad(-180), 0) 
					* CFrame.new(math.random(1, 2) == 1 and 4 + math.random(-3,2) or -4 + math.random(-2,3), math.random(-2,2), math.random(-1,4))
				bbe.Parent =effectsfolder
				debris.AddItem(bbe,1.2)

				EmitParticles(bbe)

				local shoottween = tween_service:Create(bbe,TweenInfo.new(0.3,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{CFrame = bbe.CFrame * CFrame.new(0,-math.random(6,15),0)}):Play()

				task.wait(0.15)

				local shoottween = tween_service:Create(bbe,TweenInfo.new(0.2,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Size = Vector3.new(0,0,0)}):Play()


			end)

			task.wait(0.025)

		end

	end)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
