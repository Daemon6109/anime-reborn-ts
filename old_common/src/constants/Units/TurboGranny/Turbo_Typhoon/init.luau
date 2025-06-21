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
	HitDelay = .2, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .22, -- delay between hits in a multi-hit move
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
	
	local LoadAnim = unit.TurboGranny.AnimationController:LoadAnimation(AnimModule.GetAnim(script.Animation3))
	LoadAnim:Play()
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	local Model = script.Attack3:FindFirstChild("Model"):Clone()
	Model.root.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model,7)

	local Model1 = script.Attack3:FindFirstChild("Model1"):Clone()
	Model1.rtt.CFrame = rt.CFrame
	Model1.Parent = effectsfolder
	debris.AddItem(Model1,7)




	task.wait()


	EmitParticles(Model1)


	local a = tween_service:Create(rt,TweenInfo.new(0.15,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame}):Play()


	task.wait(0.1)



	EmitParticles(Model)

	task.wait(2.2)

	local Model2 = script.Attack3:FindFirstChild("Model2"):Clone()
	Model2.rtt.CFrame = rt.CFrame
	Model2.Parent = effectsfolder
	debris.AddItem(Model2,4)

	Model2.rtt.CFrame = CFrame.new(Model2.rtt.Position, back.Position)
	task.wait(0.1)

	EmitParticles(Model2)

	local a = tween_service:Create(rt,TweenInfo.new(0.1,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = back }):Play()


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
