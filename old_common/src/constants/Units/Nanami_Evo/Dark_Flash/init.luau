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
	HitDelay = 3.25, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .5, -- delay between hits in a multi-hit move
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

local function SetParticlesEnabled(part, shouldEnable)
	for i, v in ipairs(part:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				v.Enabled = shouldEnable
			end)()
		end
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local animation = AnimModule.PlayAnim(script.Animation3, unit, 1, "Black Flash") --humanoid:LoadAnimation(script.Animation3):Play()
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)

	local Length = (rt.Position - pos.Position).magnitude - 2
	local back = rt.CFrame

	unit["Right Arm"].a1.Beam1.Enabled = true
	unit["Right Arm"].a1.Beam2.Enabled = true
	unit["Right Arm"].a1.Beam3.Enabled = true
	unit["Right Arm"].a1.Beam4.Enabled = true

	task.wait(0.6)

	SetParticlesEnabled(unit["Right Arm"].aura,true)

	unit["Right Arm"].a1.Beam1.Enabled = false
	unit["Right Arm"].a1.Beam2.Enabled = false
	unit["Right Arm"].a1.Beam3.Enabled = false
	unit["Right Arm"].a1.Beam4.Enabled = false

	task.wait(0.7)

	unit.Acc.Cutter2.Transparency = 0
	unit.Acc.att.Transparency = 1


	local dash = script.Attack3:FindFirstChild("Dash"):Clone()
	dash.CFrame = rt.CFrame * CFrame.new(0,-0.5,0)
	dash.Parent = workspace.Camera
	debris.AddItem(dash,5)

	task.wait(0.6)

	EmitParticles(dash)

	local Tween = tween_service:Create(rt, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {CFrame = rt.CFrame * CFrame.new(0,0,-Length)}):Play()
	local Tween = tween_service:Create(dash, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {CFrame = dash.CFrame * CFrame.new(0,0,-Length)}):Play()

	task.wait(0.8)

	SetParticlesEnabled(unit["Right Arm"].aura,false)

	local Flash = script.Attack3:FindFirstChild("flash"):Clone()
	Flash.crr.CFrame = rt.CFrame * CFrame.new(0,2,-3)
	Flash.Parent = workspace.Camera
	debris.AddItem(Flash,5)

	Flash.crr.Orientation = rt.Orientation
	Flash.crr.Orientation = rt.Orientation


	EmitParticles(Flash)

	task.wait(0.4)

	EmitParticles(Flash)

	task.wait(1.2)

	unit.Acc.Cutter2.Transparency = 1
	unit.Acc.att.Transparency = 0

	rt.CFrame = back

	
	--local humanoid = unit:FindFirstChild("Humanoid")
	--local startpos = rt.CFrame

	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	--local SavedDirection = rt.CFrame.LookVector
	
	--AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	--local Length = (rt.Position - pos.Position).magnitude - 2
	--local back = rt.CFrame

	--unit["Right Arm"].a1.Beam1.Enabled = true
	--unit["Right Arm"].a1.Beam2.Enabled = true
	--unit["Right Arm"].a1.Beam3.Enabled = true
	--unit["Right Arm"].a1.Beam4.Enabled = true

	--task.wait(0.6)

	--emit.enablevfx(unit["Right Arm"].aura,true)

	--unit["Right Arm"].a1.Beam1.Enabled = false
	--unit["Right Arm"].a1.Beam2.Enabled = false
	--unit["Right Arm"].a1.Beam3.Enabled = false
	--unit["Right Arm"].a1.Beam4.Enabled = false

	--task.wait(0.7)

	--unit.Acc.Cutter2.Transparency = 0
	--unit.Acc.att.Transparency = 1


	--local dash = script.Attack3:FindFirstChild("Dash"):Clone()
	--dash.CFrame = rt.CFrame * CFrame.new(0,-0.5,0)
	--dash.Parent =	effectsfolder
	--debris.AddItem(dash,5)

	--task.wait(0.6)

	--EmitParticles(dash)

	--local Tween = tween_service:Create(rt, TweenInfo.new(1.7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {CFrame = rt.CFrame * CFrame.new(0,0,-Length)}):Play()
	--local Tween = tween_service:Create(dash, TweenInfo.new(1.7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0), {CFrame = dash.CFrame * CFrame.new(0,0,-Length)}):Play()

	--task.wait(1.7)

	--emit.enablevfx(unit["Right Arm"].aura,false)

	--local Flash = script.Attack3:FindFirstChild("flash"):Clone()
	--Flash.crr.CFrame = pos.CFrame * CFrame.new(0,3,0)
	--Flash.Parent = effectsfolder
	--debris.AddItem(Flash,5)


	--EmitParticles(Flash)

	--task.wait(1.2)

	--unit.Acc.Cutter2.Transparency = 1
	--unit.Acc.att.Transparency = 0

	--rt.CFrame = back
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
