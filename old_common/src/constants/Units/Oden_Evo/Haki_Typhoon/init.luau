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
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local back = unit.back

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	local effectsfolder = workspace.Effects	

	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script.Parent.SFXs["Move3 Sfx"], rt, Replicated.SoundGroups.UnitSFX)
	SoundWrapper:PlaySound(script.Parent.SFXs["Move3 Sfx New"], rt, Replicated.SoundGroups.UnitSFX)

	local Slsh = script.Move2:FindFirstChild("slashrotation"):Clone()
	debris.AddItem(Slsh,4)
	Slsh.Parent = effectsfolder
	Slsh.Part.CFrame = rt.CFrame

	local aa = script.Move2:FindFirstChild("aa"):Clone()
	debris.AddItem(aa,4)
	aa.Parent = effectsfolder
	aa.CFrame = rt.CFrame * CFrame.new(0,-0.75,0)

	local aaa = script.Move2:FindFirstChild("aaa"):Clone()
	debris.AddItem(aaa,4)
	aaa.Parent = effectsfolder
	aaa.CFrame = rt.CFrame * CFrame.new(0,0,0)
	
	local function createhighlight(parentpart,fillcolor,filltransparenc,outlinecolor,outlinetranspcnr)
		local highlight = Instance.new("Highlight")
		highlight.Parent = parentpart
		highlight.FillColor = fillcolor
		highlight.FillTransparency = filltransparenc
		highlight.OutlineColor = outlinecolor
		highlight.OutlineTransparency = outlinetranspcnr
		return highlight
	end
	
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

	wait(0.2)

	emit.emitvfx(aaa)

	wait(0.43)

	emit.emitvfx(aa)

	spawn(function()
		local maxSize = 0.85
		-- Defina o tamanho máximo desejado
		local step = 0.03
		local duration = 0.15 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.15 * maxSize -- Função de interpolação cúbica
			Slsh:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	emit.enablevfx(Slsh,true)

	emit.enablevfx(unit.Model.Model,true)

	wait(.9)

	local ex = script.Move2:FindFirstChild("ExplosionImpact12"):Clone()
	debris.AddItem(ex,4)
	ex.Parent = effectsfolder
	ex.CFrame = rt.CFrame * CFrame.new(0,0,-0.5)

	local ex1 = script.Move2:FindFirstChild("ExplosionImpact123"):Clone()
	debris.AddItem(ex1,4)
	ex1.Parent = effectsfolder
	ex1.CFrame = rt.CFrame * CFrame.new(0,-0.7,-22)

	local Model = script.Move2:FindFirstChild("Model"):Clone()
	debris.AddItem(Model,4)
	Model.Parent = effectsfolder
	Model.PrimaryPart.CFrame = rt.CFrame * CFrame.new(0,0,-0.5)
	


	emit.enablevfx(Model,true)

	tween_service:Create(Model.PrimaryPart,TweenInfo.new(1),{CFrame = CFrame.lookAt(rt.Position, Vector3.new(pos.Position.X, rt.Position.Y, pos.Position.Z)) * CFrame.new(0,0,-22)}):Play()

	wait(0.1)

	local Part = script.Move2:FindFirstChild("Part"):Clone()
	debris.AddItem(Part,4)
	Part.Parent = effectsfolder
	Part.CFrame = rt.CFrame * CFrame.new(0,-0.8,-2)

	emit.emitvfx(Part)

	emit.emitvfx(ex)

	emit.enablevfx(Slsh,false)

	emit.enablevfx(unit.Model.Model,false)

	task.wait(0.7)

	emit.emitvfx(unit.Model.aa)

	task.wait(0.1)


	highlightsword1:Destroy()
	highlightsword2:Destroy()


	unit.hakileft.Transparency = 1
	unit.hakiright.Transparency = 1
	hakiright:Destroy()
	hakileft:Destroy()
	emit.emitvfx(ex1)

	emit.enablevfx(Model,false)


end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
