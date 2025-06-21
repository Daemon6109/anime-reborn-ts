local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.5, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local effectsfolder = workspace.Effects
	
	local function createhighlight(parentpart,fillcolor,filltransparenc,outlinecolor,outlinetranspcnr)
		local highlight = Instance.new("Highlight")
		highlight.Parent = parentpart
		highlight.FillColor = fillcolor
		highlight.FillTransparency = filltransparenc
		highlight.OutlineColor = outlinecolor
		highlight.OutlineTransparency = outlinetranspcnr
		return highlight
	end
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script.Parent.SFXs["Move2 Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(script.Parent.SFXs["Move2 Sfx New"], rt, Replicated.SoundGroups.UnitSFX)
	local slsh = script.Move1:FindFirstChild("slashs"):Clone()
	debris.AddItem(slsh,4)
	slsh.root.CFrame = rt.CFrame * CFrame.new(0,-1.1,-1)

	local root = script.Move1:FindFirstChild("root"):Clone()
	debris.AddItem(root,4)
	root.CFrame = rt.CFrame * CFrame.new(0,0,-1)
	root.Parent = effectsfolder

	local slashexp1 = script.Move1:FindFirstChild("slashexp1"):Clone()
	debris.AddItem(slashexp1,4)
	slashexp1.CFrame = rt.CFrame * CFrame.new(0,-1.1,-5.5)
	slashexp1.Parent = effectsfolder

	wait(0.2)



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

	task.wait(0.55)

	tween_service:Create(slashexp1.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 16}):Play()

	emit.emitvfx(slashexp1)

	emit.emitvfx(root)

	slsh.Parent = effectsfolder

	tween_service:Create(slsh.root,TweenInfo.new(.65),{CFrame = CFrame.lookAt(rt.Position, Vector3.new(pos.Position.X, rt.Position.Y, pos.Position.Z)) * CFrame.new(0,-1.1,-22)}):Play()


	task.wait(0.55)

	tween_service:Create(slashexp1.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 0}):Play()

	local slashexp = script.Move1:FindFirstChild("slashexp"):Clone()
	debris.AddItem(slashexp,4)
	slashexp.CFrame = rt.CFrame * CFrame.new(0,-1.1,-22)
	slashexp.Parent = effectsfolder

	tween_service:Create(slashexp.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 16}):Play()

	emit.emitvfx(slashexp)

	for _, v in ipairs(slsh.root:GetDescendants()) do
		if v:IsA("Beam") then
			tween_service:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Width0 = 0,Width1 = 0}):Play()
		end
	end

	emit.enablevfx(slsh,false)

	wait(0.3)
	
	highlightsword1:Destroy()
	highlightsword2:Destroy()

	hakiright:Destroy()
	hakileft:Destroy()

	unit.hakileft.Transparency = 1
	unit.hakiright.Transparency = 1

	tween_service:Create(slashexp.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Range = 0}):Play()



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
