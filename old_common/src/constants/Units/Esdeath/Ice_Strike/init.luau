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
	HitDelay = 1.8, -- seconds
	HitCount = 2, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local charge = script:FindFirstChild("Esdeath2Charge"):Clone()
	charge.Parent = effectsfolder
	charge.CFrame = rt.CFrame
	debris.AddItem(charge, 4)
	emit.enablevfx(charge,true)
	
	task.wait(.6)
	
	emit.enablevfx(charge,false)

	local Slashfirst = script.Esdeath2Slash:Clone() 
	Slashfirst.Parent = workspace.Effects
	Slashfirst.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(Slashfirst)
	debris.AddItem(Slashfirst,3)
	
	local Mainslash = script.Esdeath2Projectile:Clone() 
	Mainslash.Parent = workspace.Effects
	Mainslash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(Mainslash)
	debris.AddItem(Mainslash,3)
	
	
	local TweenComplete = tween_service:Create(Mainslash,TweenInfo.new(.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0),{CFrame = rt.CFrame + (rt.CFrame.LookVector * 25)})
	TweenComplete:Play()
	
	task.wait(.05)
	
	local afterslash = script.Esdeath2AfterSlash:Clone() 
	afterslash.Parent = workspace.Effects
	afterslash.CFrame = rt.CFrame + (rt.CFrame.LookVector * 12.5) + Vector3.new(0,-1.3,0)
	emit.emitvfx(afterslash)
	debris.AddItem(afterslash,3)

	task.wait(.15)
	
	local endimpact = script.Esdeath2ProjectileEnd:Clone() 
	endimpact.Parent = workspace.Effects
	endimpact.CFrame = rt.CFrame + (rt.CFrame.LookVector * 1)
	emit.emitvfx(endimpact)
	debris.AddItem(endimpact,3)
	
	task.wait(.4)
	
	local wallappear = script.Icewallappear:Clone() 
	wallappear.Parent = workspace.Effects
	wallappear.CFrame = rt.CFrame + (rt.CFrame.LookVector * 12.5) + Vector3.new(0,-1.3,0)
	emit.emitvfx(wallappear)
	debris.AddItem(wallappear,5)
	
	local icewall = script.ICEWALL:Clone() 
	icewall.Parent = workspace.Effects
	icewall:SetPrimaryPartCFrame(rt.CFrame + (rt.CFrame.LookVector * 12.5) + Vector3.new(0,-1.3,0)) 
	debris.AddItem(icewall,3)
	
	task.wait(.7)
	
	icewall:Destroy()
	local walldissapear = script.IceWallShatter:Clone() 
	walldissapear.Parent = workspace.Effects
	walldissapear.CFrame = rt.CFrame + (rt.CFrame.LookVector * 12.5) + Vector3.new(0,-1.3,0)
	emit.emitvfx(walldissapear)
	debris.AddItem(walldissapear,3)
	emit.emitvfx(wallappear)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
