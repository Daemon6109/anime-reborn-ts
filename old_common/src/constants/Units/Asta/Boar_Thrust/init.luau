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
	HitDelay = 1, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 1.7, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	-- Clone do modelo e definição do CFrame com a rotação correta
	local model = script.Move1:FindFirstChild("Model"):Clone()
	model.aa.CFrame = rt.CFrame * CFrame.new(0, -1, 0)
	-- Alinha a orientação do model.aa com a direção de rt
	model.aa.CFrame = CFrame.new(model.aa.Position, model.aa.Position + rt.CFrame.LookVector)
	model.Parent = effectsfolder
	debris.AddItem(model, 7)
	EmitParticles(model)

	-- Clone do Asta rock e definição do CFrame com a rotação correta
	local asta1 = script.Move1:FindFirstChild("Asta rock ta"):Clone()
	asta1.Part.CFrame = rt.CFrame * CFrame.new(0, -3, 0)
	-- Alinha a orientação do Asta rock com a direção de rt
	asta1.Part.CFrame = CFrame.new(asta1.Part.Position, asta1.Part.Position + rt.CFrame.LookVector)
	asta1.Parent = effectsfolder
	debris.AddItem(asta1, 7)

	-- Carrega e toca a animação do Asta


	local LoadAnim = asta1.AnimationController:LoadAnimation(AnimModule.GetAnim(script.RockAnim))


	LoadAnim:Play()
	wait(2)

	-- Desativa o ParticleEmitter após 2 segundos
	asta1.rock.ata.ParticleEmitter.Enabled = false

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
