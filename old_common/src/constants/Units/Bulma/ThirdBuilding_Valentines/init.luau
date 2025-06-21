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
	HitDelay = .6, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
}


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end
local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end

local ids = {114328313060139, 97141783565445, 113730982465132, 87407124413579, 117924749222328, 87407124413579, 106080719123565, 93264263018418, 75616323642931,127041868448395, 90345106605134, 73837174276459, 117204583529202, 78213085515433, 115936899621811, 120074202676293, 97644474785571, 86074822789877, 101968291985982}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	--SoundWrapper:PlaySound(script["Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local oldbuilding = unit:FindFirstChild("SecondBuilding")
	
	local dissapearpart = script.BottompartDissapear:Clone()
	dissapearpart.Parent = workspace.Effects

	dissapearpart.Position = oldbuilding.Position + Vector3.new(0,-1.7,0)

	emit.enablevfx(dissapearpart,true)
	task.wait(.1)
	
	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(oldbuilding,info,{CFrame = oldbuilding.CFrame + Vector3.new(0,-3.5,0)}) -- making the building go down
	tween:Play()

	task.wait(1.15)
	task.wait(.25)
	oldbuilding:Destroy()
	
	
	--SoundWrapper:PlaySound(script["Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	
	local building = script["Bulma House 3"]:Clone()
	building.Name = "ThirdBuilding"
	building.Parent = unit
	building.CFrame = rt.CFrame + (rt.CFrame.LookVector * -4) + Vector3.new(0,-3.2,0) 
	emit.emitvfx(building,true)
	
	local POSPOS = building.CFrame	

	local smokepart = script.Smokepart:Clone()
	smokepart.Parent = workspace.Effects
	smokepart.Position = POSPOS.Position
	emit.enablevfx(smokepart,true)


	local caution = script.Caution:Clone()
	caution.Parent = workspace.Effects
	caution.Position = POSPOS.Position + Vector3.new(0,2.5,0)
	emit.enablevfx(caution,true)


	local bottompart = script.Bottomforbuilding:Clone()
	bottompart.Parent =building
	bottompart.CFrame = POSPOS + Vector3.new(0,1.8,0)
	emit.enablevfx(bottompart,true)
	emit.enablevfx(caution,true)

	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(building,info,{Position = building.Position + Vector3.new(0,4,0)})
	tween:Play()

	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)  
	local tween = tween_service:Create(smokepart,info,{Position = building.Position + Vector3.new(0,5.6,0)}) 
	tween:Play()

	local info = TweenInfo.new(1.4,Enum.EasingStyle.Sine,Enum.EasingDirection.Out)
	local tween = tween_service:Create(bottompart.circleactul,info,{WorldPosition = bottompart.circleactul.WorldPosition + Vector3.new(0,2.15,0)})
	tween:Play()


	for i, v in pairs(caution:GetDescendants()) do -- tween for making the beams appear smooth
		task.spawn(function()
			if v:IsA("Beam") then
				local oldbeamsize = v.Width0
				local oldbeamsize2 = v.Width1

				v.Width0 = 0
				v.Width1 = 0

				local TweenComplete = tween_service:Create(v,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width0 = oldbeamsize})
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.8,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{Width1 = oldbeamsize2})
				TweenComplete:Play()

				task.wait(1.2)


				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width0 = 0}) 
				TweenComplete:Play()
				local TweenComplete = tween_service:Create(v,TweenInfo.new(.5,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{Width1 = 0})
				TweenComplete:Play()

			end
		end)
	end	
	
	
	task.wait(.75)
	emit.enablevfx(dissapearpart,false)

	
	task.wait(.75)
	
	emit.emitvfx(building,false)
	emit.emitvfx(building)
	
	local highlight = Instance.new("Highlight")
	highlight.Parent = building
	highlight.FillColor = Color3.fromRGB(26, 186, 235)
	highlight.FillTransparency = 0.9
	highlight.OutlineColor = Color3.fromRGB(23, 104, 235)
	highlight.OutlineTransparency = 0
	highlight.Enabled = true

	local info = TweenInfo.new(.1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(building.Highlight,info,{FillTransparency = .1}) -- making the part flash orange
	tween:Play()
	task.wait(.1)
	local info = TweenInfo.new(.25,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	local tween = tween_service:Create(building.Highlight,info,{FillTransparency = 1}) -- making the part flash orange
	tween:Play()
	task.wait(.24)
	highlight:Destroy()


	emit.enablevfx(bottompart.circleactul,false)
	emit.enablevfx(smokepart,false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
