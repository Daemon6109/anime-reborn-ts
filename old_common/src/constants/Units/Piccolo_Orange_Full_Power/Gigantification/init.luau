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
	HitDelay = 3.4, -- seconds
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



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local piccolo = script.Move3:FindFirstChild("Piccolo(Orange)1"):Clone()
	piccolo.HumanoidRootPart.CFrame = rt.CFrame * CFrame.new(0,-1000,0)
	piccolo.Parent = effectsfolder
	debris.AddItem(piccolo,6)


	local summonPart = Instance.new("Part")
	summonPart.Anchored = true
	summonPart.Parent = effectsfolder
	summonPart.CFrame = rt.CFrame
	summonPart.CanTouch = false
	summonPart.CanCollide = false
	summonPart.Transparency = 1
	summonPart.CFrame = CFrame.new(summonPart.Position, pos.Position)
	debris.AddItem(summonPart,7)

	local ex = script.Move3:FindFirstChild("ex"):Clone()
	ex.CFrame = rt.CFrame * CFrame.new(0,4,0)
	ex.Parent = effectsfolder
	debris.AddItem(ex,6.7)


	AnimModule.PlayAnim(script.Animation3,piccolo, 1, "", {Weight = 2, Fade = .15})




	local Model = script.Move3:FindFirstChild("Model"):Clone()
	Model.root.CFrame = rt.CFrame * CFrame.new(0,0,-1)
	Model.Parent = effectsfolder
	debris.AddItem(Model,5)
	emit.emitvfx(Model)

	local aura1 = script.Move3:FindFirstChild("aura1"):Clone()
	aura1.root.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	aura1.Parent = effectsfolder
	debris.AddItem(aura1,6)
	emit.emitvfx(aura1)


	wait(1.65)

	emit.enablevfx(piccolo["Right Arm"].Particles,true)



	piccolo.HumanoidRootPart.CFrame = summonPart.CFrame * CFrame.new(0,3,0)

	rt.CFrame = summonPart.CFrame * CFrame.new(0,-5,0)

	spawn(function()
		local trail1 = script.Move3.Trail:Clone()
		trail1.Parent = effectsfolder
		trail1.Position = rt.Position
		debris.AddItem(trail1, 4)

		tween_service:Create(trail1, TweenInfo.new(0.55), {Position = trail1.Position + Vector3.new(0,15,0)}):Play()
		tween_service:Create(trail1, TweenInfo.new(0.55), {Orientation = Vector3.new(0, 600, 0)}):Play()

		wait(0.4)

		emit.enablevfx(trail1, false)
	end)



	wait(0.25)




	emit.emitvfx(ex)


	for _, v in ipairs(aura1:GetDescendants()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.175, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Width0 = 0, Width1 = 0}):Play()
		end
	end

	wait(1.2)

	emit.enablevfx(piccolo["Right Arm"].Particles,false)

	wait(0.8)

	emit.emitvfx(ex)

	rt.CFrame = summonPart.CFrame * CFrame.new(0,0,0)

	piccolo:Destroy()
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
