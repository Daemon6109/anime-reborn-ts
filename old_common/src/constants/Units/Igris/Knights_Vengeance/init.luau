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
	HitDelay = 1.3, -- seconds
	HitCount = 6, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
	CustomDelay = {
		[5] = .6,
	},
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
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Length = (rt.Position - pos.Position).magnitude - 2
	local back = rt.CFrame

	local ttt = script.Attack2:FindFirstChild("Emits"):Clone()
	ttt.CFrame = pos.CFrame * CFrame.new(0,2.3,0)
	ttt.Parent =effectsfolder
	debris.AddItem(ttt,5)

	local ttte = script.Attack2:FindFirstChild("Crash"):Clone()
	ttte.CFrame = pos.CFrame * CFrame.new(0,-0.3,0)
	ttte.Parent = effectsfolder
	debris.AddItem(ttte,4)

	EmitParticles(ttt)

	EmitParticles(ttte)

	task.wait(0.9)

	local dash = script.Attack2:FindFirstChild("Dash"):Clone()
	dash.CFrame = rt.CFrame * CFrame.new(0,-1.1,0)
	dash.Parent = effectsfolder
	debris.AddItem(dash,4)

	EmitParticles(dash)

	local dddr = script.Attack2:FindFirstChild("drr"):Clone()
	dddr.CFrame = rt.CFrame * CFrame.new(0,3,-6)
	dddr.Parent = effectsfolder
	debris.AddItem(dddr,4)

	EmitParticles(dddr)


	local Tween = tween_service:Create(rt, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = rt.CFrame * CFrame.new(0,0,-Length)}):Play()

	task.wait(1.3)

	rocksmodule.Ground(pos.Position + Vector3.new(0, 1, 0), 13, Vector3.new(3,2,3), nil, 8, false, 1.6)

	task.wait(1)

	rt.CFrame = back

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
