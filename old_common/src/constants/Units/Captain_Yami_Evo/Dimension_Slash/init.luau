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
	HitDelay = 2.8, -- seconds
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


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		task.wait(1.35)
		SoundWrapper:PlaySound(script["Move4sfx"], rt, Replicated.SoundGroups.UnitSFX)

	end)
	
	local Model = script.Move4:FindFirstChild("Model"):Clone()
	Model.Root.CFrame = rt.CFrame * CFrame.new(0,-1.5,0)
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)
	local MainBox = script.Move4:FindFirstChild("MainBox"):Clone()
	MainBox.CFrame = rt.CFrame * CFrame.new(0,-1.1,0)
	MainBox.Parent = effectsfolder
	debris.AddItem(MainBox,5)


	EmitParticles(Model)

	task.wait(2)

	EmitParticles(MainBox)

	spawn(function()
		local trail1 = script.Move4.Trail:Clone()
		trail1.Parent = effectsfolder
		trail1.Position = rt.Position + Vector3.new(0, -1.5, 0)
		debris.AddItem(trail1, 4)


		-- Movendo a trilha para frente na direção do olhar
		tween_service:Create(trail1, TweenInfo.new(0.5), {Position = trail1.Position + Vector3.new(0,5,0)}):Play()
		tween_service:Create(trail1, TweenInfo.new(0.5), {Orientation = Vector3.new(0, 500, 0)}):Play()

		task.wait(0.5)

		emit.enablevfx(trail1, false)
	end)

	unit.Head.bb.sa.Enabled = true
	unit.Head.aa.sa.Enabled = true

	emit.enablevfx(unit["Right Arm"].Sword,true)

	task.wait(0.7)
	unit.Head.bb.sa.Enabled = false
	unit.Head.aa.sa.Enabled = false
	emit.enablevfx(unit["Right Arm"].Sword,false)

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
