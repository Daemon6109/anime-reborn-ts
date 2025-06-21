local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	CustomDelay = {
		[2] = 1,
	},
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local effectsfolder = workspace.Effects
	

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation4, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script.Parent.SFXs["Move4 Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(script.Parent.SFXs["Move4 Sfx New"], rt, Replicated.SoundGroups.UnitSFX)

	local hakieffect = script.Move4:FindFirstChild("hakieffect"):Clone()
	hakieffect.Parent = effectsfolder
	debris.AddItem(hakieffect,5.5)
	hakieffect.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)

	local ex = script.Move4:FindFirstChild("ExplosionImpact123"):Clone()
	ex.Parent = effectsfolder
	debris.AddItem(ex,6)

	local ex1 = script.Move4:FindFirstChild("ExplosionImpact12"):Clone()
	ex1.Parent = effectsfolder
	debris.AddItem(ex1,6)

	local a = script.Move4:FindFirstChild("a"):Clone()
	a.CFrame = rt.CFrame * CFrame.new(0,0,-0.5)
	a.Parent = effectsfolder
	debris.AddItem(a,7)

	local function createhighlight(parentpart,fillcolor,filltransparenc,outlinecolor,outlinetranspcnr)
		local highlight = Instance.new("Highlight")
		highlight.Parent = parentpart
		highlight.FillColor = fillcolor
		highlight.FillTransparency = filltransparenc
		highlight.OutlineColor = outlinecolor
		highlight.OutlineTransparency = outlinetranspcnr
		return highlight
	end


	wait(0.5)

	emit.emitvfx(hakieffect)

	unit["Right Arm"].a.aa:Emit(1)
	unit["Right Arm"].a.bb:Emit(1)

	unit["Left Arm"].a.aa:Emit(1)
	unit["Left Arm"].a.bb:Emit(1)

	local highlightsword1 = createhighlight(unit.sword1,Color3.fromRGB(47, 0, 0),1,Color3.fromRGB(0, 0, 0),1)
	local highlightsword2 = createhighlight(unit.sword1,Color3.fromRGB(47, 0, 0),1,Color3.fromRGB(0, 0, 0),1)
	local hakileft = createhighlight(unit.hakileft,Color3.fromRGB(47, 0, 0),.6,Color3.fromRGB(235, 40, 15),.2)
	local hakiright = createhighlight(unit.hakiright,Color3.fromRGB(47, 0, 0),.6,Color3.fromRGB(235, 40, 15),.2)
	unit.hakileft.Transparency = 0
	unit.hakiright.Transparency = 0

	wait(1)

	emit.enablevfx(unit.aa,true)

	wait(0.25)

	local slashs = script.Move4:FindFirstChild("slashs"):Clone()
	slashs.CFrame = rt.CFrame * CFrame.new(0,0,0)
	slashs.Parent = effectsfolder
	debris.AddItem(slashs,4)


	local tweeen = tween_service:Create(slashs,TweenInfo.new(0.3,Enum.EasingStyle.Linear, Enum.EasingDirection.In,0,false,0),{CFrame = pos.CFrame}):Play()
	task.spawn(function()
		for i = 1,14 do
			task.wait(0.03)
			slashs.Rot.Orientation = Vector3.new(math.random(0,0),math.random(0,0),math.random(-30,30))
			emit.emitvfx(slashs)
		end
	end)

	a.CFrame = CFrame.new(a.Position, pos.Position)

	emit.emitvfx(a)

	tween_service:Create(rt,TweenInfo.new(0.15),{CFrame = pos.CFrame}):Play()

	ex.CFrame = pos.CFrame * CFrame.new(0,-0.75,0)
	ex1.CFrame = pos.CFrame * CFrame.new(0,-0.75,0)

	local tweeen = tween_service:Create(ex.PointLight,TweenInfo.new(0.3,Enum.EasingStyle.Linear, Enum.EasingDirection.In,0,false,0),{Range = 16}):Play()

	wait(0.25)

	emit.enablevfx(unit.aa,false)

	ex.Rocks3.Enabled = true


	emit.emitvfx(ex)
	emit.emitvfx(ex1)

	wait(0.8)

	local emits = script.Move4:FindFirstChild("emits"):Clone()
	emits.Parent = effectsfolder
	debris.AddItem(emits,5)
	emits.CFrame = ex.CFrame

	emit.emitvfx(emits)

	tween_service:Create(emits, TweenInfo.new(2.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Rotation = Vector3.new(0,-600,0)}):Play()


	wait(0.15)

	emit.emitvfx(ex1)



	local tweeen = tween_service:Create(ex.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.In,0,false,0),{Range = 24}):Play()

	ex.Rocks3.Enabled = false

	emit.emitvfx(unit.Model.aa)

	tween_service:Create(rt,TweenInfo.new(.05),{CFrame = back.CFrame}):Play()


	highlightsword1:Destroy()
	highlightsword2:Destroy()
	hakiright:Destroy()
	hakileft:Destroy()

	unit.hakileft.Transparency = 1
	unit.hakiright.Transparency = 1

	wait(0.2)

	local tweeen = tween_service:Create(ex.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Linear, Enum.EasingDirection.In,0,false,0),{Range = 0}):Play()


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
