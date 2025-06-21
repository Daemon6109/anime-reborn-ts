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
	
	local theanim = AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	    
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	task.wait(.2)
	
	local charge = script.Charge:Clone() 
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1.3,0)
	emit.enablevfx(charge,true)
	debris.AddItem(charge,3)
	
	
	
	task.wait(.3)
	
	local chargeBuddha = script.ChargeBuddha:Clone() 
	chargeBuddha.Parent = workspace.Effects
	chargeBuddha.CFrame = rt.CFrame + Vector3.new(0,-1.3,0) + (rt.CFrame.LookVector * -4)
	emit.enablevfx(chargeBuddha,true)
	debris.AddItem(chargeBuddha,3)
	
	task.wait(.15)
	
	local Buddha = script.Buddha:Clone() 
	Buddha.Parent = workspace.Effects
	Buddha:SetPrimaryPartCFrame(rt.CFrame + Vector3.new(0,-1,0) + (rt.CFrame.LookVector * -4))
	debris.AddItem(Buddha,35)
	emit.emitvfx(Buddha.RootPart)

	local LoadAnim = Buddha.AnimationController:LoadAnimation(AnimModule.GetAnim(script.AnimationBuddha))
	LoadAnim:Play()
	
	task.wait(.3)
	AnimModule.ChangeAnimSpeed(theanim,.35)
	emit.enablevfx(Buddha.RootPart,true)
	
	task.wait(1.3)
	emit.enablevfx(charge,false)

	local hit = script.BuddhaHit:Clone() 
	hit.Parent = workspace.Effects
	hit.CFrame = rt.CFrame + Vector3.new(0,3.6,0) + (rt.CFrame.LookVector * -2)
	emit.emitvfx(hit)
	debris.AddItem(hit,3)
	emit.enablevfx(Buddha.RootPart,false)

	emit.enablevfx(chargeBuddha,false)
	emit.enablevfx(Buddha,false)
	
	task.wait(.75)

	Buddha.Flowers.Transparency = 1
	Buddha["that Guy done.004"].Transparency = 1
	Buddha["that Guy done.005"].Transparency = 1
	Buddha["that Guy done.006"].Transparency = 1

	emit.emitvfx(Buddha.RootPart)

	

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
