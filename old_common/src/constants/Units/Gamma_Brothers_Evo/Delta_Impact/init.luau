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
	HitDelay = .7, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .6, -- delay between hits in a multi-hit move
	CustomDelay = {
		[2] = 1.4,
	},
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local G_1 = unit.Gamma1
	local G_2 = unit.Gamma2

	local rtG1 = unit.Gamma1:WaitForChild("HumanoidRootPart")
	local rtG2 = unit.Gamma2:WaitForChild("HumanoidRootPart")

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script["Animation2(G1)"], G_1, 1, "", {Weight = 2, Fade = .15})
	AnimModule.PlayAnim(script["Animation2(G2)"], G_2, 1, "", {Weight = 2, Fade = .15})
	
	
	SoundWrapper:PlaySound(script["Move2"], rt, Replicated.SoundGroups.UnitSFX)
	
	local rocksmodule = require(script.RocksModule)

	local Length1 = (rtG1.Position - pos.Position).magnitude
	local back1 = rtG1.CFrame

	local Length2 = (rtG2.Position - pos.Position).magnitude - 2
	local back2 = rtG2.CFrame

	rtG2.Anchored = true

	local kicks = script.Attack2:FindFirstChild("Kick"):Clone()
	kicks["Doka!"].CFrame = pos.CFrame * CFrame.new(0,0.8,0)
	kicks.Parent = effectsfolder	
	debris.AddItem(kicks,6)

	emit.emitvfx(kicks)

	task.wait(0.3)

	local Tween = tween_service:Create(rtG2, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = rtG2.CFrame * CFrame.new(0,0,-Length2)}):Play()

	task.wait(1.6)

	local kicke = script.Attack2:FindFirstChild("Skille"):Clone()
	kicke.CFrame = pos.CFrame * CFrame.new(0,-0.9,0)
	kicke.Parent = effectsfolder
	debris.AddItem(kicke,6)

	task.wait(0.2)

	emit.emitvfx(kicke)

	--rocksmodule.Ground(pos.Position + Vector3.new(0, 1, 0), 10, Vector3.new(2,3,2), nil, 15, false, 1.6)

	local Tween = tween_service:Create(rtG2, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out,0,false,0), {CFrame = rtG2.CFrame * CFrame.new(0,12,0)}):Play()

	task.wait(0.7)

	local tep = script.Attack2:FindFirstChild("Teleport"):Clone()
	tep.CFrame = rtG2.CFrame * CFrame.new(0,0.8,0)
	tep.Parent = effectsfolder
	debris.AddItem(tep,4)

	emit.emitvfx(tep)

	rtG2.Anchored = false

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
