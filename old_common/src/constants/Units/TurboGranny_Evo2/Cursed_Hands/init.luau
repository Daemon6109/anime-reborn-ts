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
	HitDelay = .65, -- seconds
	HitCount = 16, -- amout of hits the skill does to split the damage visually on client
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
	

	local LoadAnim = unit.TurboGranny.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation1))
	LoadAnim:Play()

--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	local SavedDirection = rt.CFrame.LookVector

	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame



	wait(0.5)

	spawn(function()
		for i = 1,16 do

			wait(0.1)

			spawn(function()

				local ha = script.Attack2:FindFirstChild("hand"):Clone()
				ha.root.CFrame = rt.CFrame * CFrame.new(math.random(-5,5), -1.5, i * -1)
				ha.root.Orientation = Vector3.new(math.random(0,0),math.random(-15,15),math.random(0,0))
				ha.Parent = effectsfolder

				debris.AddItem(ha,3)

				local LoadAnim = ha.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Hands))
				LoadAnim:Play()
				EmitParticles(ha)

				task.wait(2.3)
				local Transparencyshoottween = tween_service:Create(ha.root,TweenInfo.new(0.4,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = ha.root.CFrame * CFrame.new(0,-5,0)}):Play()
				task.wait(0.6)
				ha:Destroy()



			end)

		end

	end)
end

	
	


-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
