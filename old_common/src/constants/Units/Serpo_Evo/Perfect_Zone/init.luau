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
	HitDelay = 1.25, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .425, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	emit.enablevfx(unit.Torso.movement,true)
	
	task.wait(.25)
	

	local atplayer = script:WaitForChild("ATplayer"):Clone()
	atplayer.Parent = effectsfolder
	atplayer.Position = rt.CFrame.Position + Vector3.new(0,-1.3,0)
	debris.AddItem(atplayer, 3)
	emit.enablevfx(atplayer,true)
	
	task.wait(.15)
	
	local mainFX = script:WaitForChild("Serpo3"):Clone()
	mainFX.Parent = effectsfolder
	mainFX.Position = pos.Position + Vector3.new(0,-1,0)
	debris.AddItem(mainFX, 3)
	EmitParticles(mainFX)
	
	task.wait(1.5)
	
	local endd = script:WaitForChild("Serpo3End"):Clone()
	endd.Parent = effectsfolder
	endd.Position = pos.Position + Vector3.new(0,-1,0)
	debris.AddItem(endd,3)
	emit.emitvfx(endd)
	
	emit.enablevfx(unit.Torso.movement,false)
	emit.enablevfx(atplayer,false)

	
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
