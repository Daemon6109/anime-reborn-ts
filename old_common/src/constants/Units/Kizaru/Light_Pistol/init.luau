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
	HitDelay = 1.2, -- seconds
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


local effectsfolder = workspace.Effects

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["mov1"], rt, Replicated.SoundGroups.UnitSFX)
	
	local a = script.Move1:FindFirstChild("A"):Clone()
	a.Parent = effectsfolder
	debris.AddItem(a,4)

	wait(0.550)

	local shoottween = tween_service:Create(unit["Right Arm"].partcframe1.PointLight,TweenInfo.new(0.35,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Range = 14}):Play()


	emit.enablevfx(unit["Right Arm"].aa,true)

	wait(0.425)



	a.CFrame = unit["Right Arm"].partcframe1.CFrame

	task.wait(0.001)


	local light1 = script.Move1:FindFirstChild("light1"):Clone()
	light1.Parent = effectsfolder
	debris.AddItem(light1,4)
	light1.CFrame = pos.CFrame

	a.CFrame = CFrame.new(a.Position, pos.Position)

	task.wait(0.001)






	emit.emitvfx(a)


	emit.enablevfx(unit["Right Arm"].aa,false)





	local shoottween = tween_service:Create(unit["Right Arm"].partcframe1.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{Range = 0}):Play()


	task.wait(0.03)

	emit.emitvfx(light1)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
