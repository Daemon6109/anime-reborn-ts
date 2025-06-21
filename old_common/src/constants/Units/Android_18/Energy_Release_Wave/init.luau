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
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .2, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end



function module:Effect(Tab)
	print(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2"], rt, Replicated.SoundGroups.UnitSFX)
	local summonPart = Instance.new("Part")
	summonPart.Anchored = true
	summonPart.Parent = effectsfolder
	summonPart.CFrame = rt.CFrame
	summonPart.CanTouch = false
	summonPart.CanCollide = false
	summonPart.Transparency = 1
	summonPart.CFrame = CFrame.new(summonPart.Position, pos.Position)
	debris.AddItem(summonPart,10)


	local impact =  script.attack2impact:FindFirstChild("explode"):Clone()
	impact.Parent = effectsfolder
	impact.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	debris.AddItem(impact,5.5)

	local beam =  script:FindFirstChild("attack2"):Clone()
	beam.Parent = effectsfolder
	beam.Model.MainBox.CFrame = pos.CFrame * CFrame.new(0,0,0)
	debris.AddItem(beam,5.5)

	local tpvfx =  script:FindFirstChild("tpvfx"):Clone()
	tpvfx.Parent = effectsfolder
	tpvfx.CFrame = rt.CFrame
	debris.AddItem(tpvfx,5.5)

	local tpvfx1 =  script:FindFirstChild("tpvfx"):Clone()
	tpvfx1.Parent = effectsfolder
	tpvfx1.CFrame = pos.CFrame * CFrame.new(0,9.5,0)
	debris.AddItem(tpvfx1,5.5)

	task.wait(0.1)


	emit.emitvfx(tpvfx)

	rt.CFrame = pos.CFrame * CFrame.new(0,9.5,.5)

	emit.emitvfx(tpvfx1)

	wait(0.3)


	emit.emitvfx(unit["Right Arm"].emitt)

	emit.enablevfx(unit["Right Arm"].Attachment,true)

	wait(.6)

	emit.emitvfx(unit["Right Arm"].emitt)
	emit.enablevfx(unit["Right Arm"].Attachment,false)


	emit.enablevfx(beam,true)


	for i,v in pairs(beam.beam.Start:GetDescendants()) do
		if v:IsA("Beam") then
			v.Enabled = true
		end
	end


	beam.beamend.Anchored = true

	task.wait(0.05)





	local shoottween = tween_service:Create(beam.beamend,TweenInfo.new(0.15,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,-1,0)}):Play()


	wait(0.15)


	emit.emitvfx(impact)

	task.wait(0.85)

	emit.emitvfx(impact)



	task.wait(0.05)

	emit.enablevfx(beam,false)

	for i,v in pairs(beam:GetDescendants()) do
		if v:IsA("Beam") then
			v.Enabled = false
		end
	end

	emit.emitvfx(tpvfx1)

	emit.emitvfx(tpvfx)

	rt.CFrame = summonPart.CFrame
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
