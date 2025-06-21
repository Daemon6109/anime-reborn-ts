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
	HitDelay = .8, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .25, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1"], rt, Replicated.SoundGroups.UnitSFX)
	
	local summonPart = Instance.new("Part")
	summonPart.Anchored = true
	summonPart.Parent = effectsfolder
	summonPart.CFrame = rt.CFrame
	summonPart.CanTouch = false
	summonPart.CanCollide = false
	summonPart.Transparency = 1
	summonPart.CFrame = CFrame.new(summonPart.Position, pos.Position)
	debris.AddItem(summonPart,10)

	local tpvfx =  script:FindFirstChild("dash"):Clone()
	tpvfx.Parent = effectsfolder
	tpvfx.mainpart1.CFrame = rt.CFrame * CFrame.new(0,0,0)
	debris.AddItem(tpvfx,5)


	local tpvfx1 =  script:FindFirstChild("tpvfx"):Clone()
	tpvfx1.Parent = effectsfolder
	tpvfx1.CFrame = rt.CFrame * CFrame.new(0,0,0)
	debris.AddItem(tpvfx1,5)


	local impact =  script:FindFirstChild("impact"):Clone()
	impact.Parent = effectsfolder
	impact.CFrame = pos.CFrame * CFrame.new(0,0,0)
	impact.Orientation = Vector3.new(0,-39.999, 0)

	debris.AddItem(impact,5.5)

	local impact1 =  script:FindFirstChild("impact2"):Clone()
	impact1.Parent = effectsfolder
	impact1.CFrame = pos.CFrame * CFrame.new(0,0,-1)
	impact1.Orientation = Vector3.new(-90, 50.001, 180)

	debris.AddItem(impact,5.5)

	wait(0.4)

	emit.emitvfx(tpvfx1)

	emit.emitvfx(unit.tpvfx1)




	local shoottween = tween_service:Create(rt,TweenInfo.new(0.35,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame * CFrame.new(0,0,0)}):Play()

	emit.emitvfx(tpvfx)

	wait(0.35)

	local tpvfx12 =  script:FindFirstChild("tpvfx"):Clone()
	tpvfx12.Parent = effectsfolder
	tpvfx12.CFrame = rt.CFrame * CFrame.new(0,0,0)
	debris.AddItem(tpvfx12,5)

	local tpvfx =  script:FindFirstChild("dash"):Clone()
	tpvfx.Parent = effectsfolder
	tpvfx.mainpart1.CFrame = rt.CFrame * CFrame.new(0,0,0)
	debris.AddItem(tpvfx,5)

	for i, v in pairs(impact:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end

	for i, v in pairs(impact1:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end

	emit.emitvfx(tpvfx)


	wait(0.5)
	emit.emitvfx(tpvfx1)
	emit.emitvfx(tpvfx12)


	rt.CFrame = summonPart.CFrame
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
