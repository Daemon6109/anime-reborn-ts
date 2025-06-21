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
	HitDelay = 2.7, -- seconds
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Length = (rt.Position - pos.Position).magnitude - 4
	local back = rt.CFrame

	unit["Right Arm"].a1.Beam1.Enabled = true
	unit["Right Arm"].a1.Beam2.Enabled = true
	unit["Right Arm"].a1.Beam3.Enabled = true
	unit["Right Arm"].a1.Beam4.Enabled = true

	task.wait(1.8)

	EmitParticles(unit["Right Arm"].troll)

	local cursed = script.Attack1:FindFirstChild("Dash"):Clone()
	cursed.CFrame = rt.CFrame * CFrame.new(0,-0.5,0)
	cursed.Parent = effectsfolder
	debris.AddItem(cursed,4)

	unit["Right Arm"].a1.Beam1.Enabled = false
	unit["Right Arm"].a1.Beam2.Enabled = false
	unit["Right Arm"].a1.Beam3.Enabled = false
	unit["Right Arm"].a1.Beam4.Enabled = false

	task.wait(0.7)

	EmitParticles(cursed)

	local Tween = tween_service:Create(rt, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = rt.CFrame * CFrame.new(0, 0, -Length)}):Play()

	local cursed = script.Attack1:FindFirstChild("Curseed Explosion"):Clone()
	cursed.CFrame = pos.CFrame * CFrame.new(0,1.5,0)
	cursed.Parent =effectsfolder
	debris.AddItem(cursed,3)

	EmitParticles(cursed)

	task.wait(0.7)

	rt.CFrame = back

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
