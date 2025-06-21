local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 2.5, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	CustomDelay = {
		[1] = .1,
	},
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local effectsfolder = workspace.Effects

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local back = unit.back

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script.Parent.SFXs["Move1 Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(script.Parent.SFXs["Move1 Sfx New"], rt, Replicated.SoundGroups.UnitSFX)
	local ex = script.Move3:FindFirstChild("ExplosionImpact12"):Clone()
	ex.Parent = effectsfolder
	debris.AddItem(ex,7)


	local hakieffect = script.Move3:FindFirstChild("hakieffect"):Clone()
	hakieffect.Parent = effectsfolder
	debris.AddItem(hakieffect,4)
	hakieffect.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)

	local grdash = script.Move3:FindFirstChild("grdash"):Clone()
	grdash.Parent = effectsfolder
	debris.AddItem(grdash,4)
	grdash.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	
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


	local dash1 = script.Move3:FindFirstChild("dash1"):Clone()
	dash1.Parent = effectsfolder
	debris.AddItem(dash1,4)
	dash1.CFrame = rt.CFrame

	emit.emitvfx(hakieffect)


	tween_service:Create(unit["Right Arm"], TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	tween_service:Create(unit["Left Arm"], TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()

	unit["Right Arm"].bluespecs:Emit(15)
	unit["Left Arm"].bluespecs:Emit(15)

	emit.emitvfx(unit["Right Arm"].b)

	emit.emitvfx(unit["Left Arm"].b)

	wait(0.05)

	emit.emitvfx(hakieffect)

	tween_service:Create(unit["Right Arm"], TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()
	tween_service:Create(unit["Left Arm"], TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 0}):Play()


	unit["Right Arm"].red:Emit(15)
	unit["Left Arm"].red:Emit(15)

	emit.emitvfx(unit["Right Arm"].a)

	emit.emitvfx(unit["Left Arm"].a)

	local highlightsword1 = createhighlight(unit.sword1,Color3.fromRGB(47, 0, 0),1,Color3.fromRGB(0, 0, 0),1)
	local highlightsword2 = createhighlight(unit.sword1,Color3.fromRGB(47, 0, 0),1,Color3.fromRGB(0, 0, 0),1)
	local hakileft = createhighlight(unit.hakileft,Color3.fromRGB(47, 0, 0),.6,Color3.fromRGB(235, 40, 15),.2)
	local hakiright = createhighlight(unit.hakiright,Color3.fromRGB(47, 0, 0),.6,Color3.fromRGB(235, 40, 15),.2)

	unit.hakileft.Transparency = 0
	unit.hakiright.Transparency = 0


	wait(0.8)

	dash1.CFrame = CFrame.new(dash1.Position, pos.Position + Vector3.new(0,8,0))

	emit.emitvfx(dash1)

	emit.emitvfx(grdash)


	local dash = script.Move3:FindFirstChild("dash"):Clone()
	dash.Parent = effectsfolder
	debris.AddItem(dash,4)


	tween_service:Create(rt, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = pos.CFrame * CFrame.new(0,8,0)}):Play()


	wait(0.4)

	emit.enablevfx(unit.Torso.Attachment,true)

	wait(0.2)



	ex.CFrame = rt.CFrame * CFrame.new(0,-8.7,-1)

	dash.CFrame = rt.CFrame * CFrame.new(0,0,0)

	task.wait(0.01)

	emit.emitvfx(dash)


	tween_service:Create(ex.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 16}):Play()

	tween_service:Create(rt, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {CFrame = rt.CFrame * CFrame.new(0,-8,0)}):Play()



	emit.enablevfx(unit.Torso.Attachment,false)

	wait(0.2)


	emit.emitvfx(ex)


	tween_service:Create(ex.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 24}):Play()

	wait(.2)



	tween_service:Create(ex.PointLight, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Range = 0}):Play()

	wait(0.6)



	highlightsword1:Destroy()
	highlightsword2:Destroy()
	hakiright:Destroy()
	hakileft:Destroy()
	
	tween_service:Create(unit.hakileft, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()
	tween_service:Create(unit.hakiright, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Transparency = 1}):Play()

	rt.CFrame = back.CFrame

	emit.emitvfx(unit.Model.aa)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
