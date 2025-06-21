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
	HitDelay = 3.5, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
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
	
	local TargetCFrame = pos.CFrame
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1.75, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move3SFx"], rt, Replicated.SoundGroups.UnitSFX, {PlaybackSpeed = 1.75})


	local emitsmovement = script.Move3:FindFirstChild("emitsmovement"):Clone()
	emitsmovement.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	emitsmovement.Orientation = Vector3.new()
	emitsmovement.Parent = effectsfolder
	debris.AddItem(emitsmovement,5)

	emit.emitvfx(emitsmovement)


	task.wait(0.8/2)

	local grdash = script.Move3:FindFirstChild("grdash"):Clone()
	grdash.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	grdash.Orientation = Vector3.new()
	grdash.Parent = effectsfolder
	debris.AddItem(grdash,4)

	local MainBox = script.Move3:FindFirstChild("MainBox"):Clone()
	MainBox.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	MainBox.Parent = effectsfolder
	debris.AddItem(MainBox,5)



	emit.emitvfx(grdash)

	task.wait(1/2)

	local ExplosionImpact1234 = script.Move3:FindFirstChild("ExplosionImpact1234"):Clone()
	ExplosionImpact1234.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	ExplosionImpact1234.Orientation = Vector3.new()
	ExplosionImpact1234.Parent = effectsfolder
	debris.AddItem(ExplosionImpact1234,4)

	emit.emitvfx(ExplosionImpact1234)

	local spiritbomb1 = script.Move3:FindFirstChild("spiritbomb1"):Clone()
	spiritbomb1.CFrame = rt.CFrame * CFrame.new(0,12,0)
	spiritbomb1.Parent = effectsfolder
	debris.AddItem(spiritbomb1,8)



	emit.emitvfx(spiritbomb1)

	task.wait(0.2/2)

	emit.enablevfx(spiritbomb1,true)


	emit.enablevfx(MainBox,true)

	task.wait(0.3/1.5)

	local ExplosionImpact123 = script.Move3:FindFirstChild("ExplosionImpact123"):Clone()
	ExplosionImpact123.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	ExplosionImpact123.Orientation = Vector3.new()
	ExplosionImpact123.Parent = effectsfolder
	debris.AddItem(ExplosionImpact123,4)

	emit.emitvfx(ExplosionImpact123)



	emit.emitvfx(spiritbomb1,false)

	local spiritbomb = script.Move3:FindFirstChild("spiritbomb"):Clone()
	spiritbomb.spiritbomb.CFrame = rt.CFrame * CFrame.new(0,11,0)
	spiritbomb.Parent = effectsfolder
	debris.AddItem(spiritbomb,12)
	emit.enablevfx(spiritbomb,true)
	local a = tween_service:Create(spiritbomb.spiritbomb.PointLight,TweenInfo.new(.5,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 16}):Play()

	emit.emitvfx(spiritbomb1)


	local a = tween_service:Create(spiritbomb.spiritbomb,TweenInfo.new(.7,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{CFrame = spiritbomb.spiritbomb.CFrame * CFrame.new(0,1.25,0)}):Play()

	task.spawn(function()
		local maxSize = 5
		-- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = .4 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^1 * maxSize -- Função de interpolação cúbica
			spiritbomb:ScaleTo(smoothScale)
			task.wait(interval/1.5)
		end
	end)

	task.wait(1/1.5)

	emit.enablevfx(spiritbomb.spiritbomb.disablethis,false)  

	task.spawn(function()

		task.wait(1/1.5)

		local dashspirit = script.Move3:FindFirstChild("dashspirit"):Clone()
		dashspirit.CFrame = spiritbomb.spiritbomb.CFrame
		dashspirit.Parent = effectsfolder
		debris.AddItem(dashspirit,4.5)
		dashspirit.CFrame = CFrame.new(dashspirit.Position, TargetCFrame.Position)

		emit.enablevfx(MainBox,false)


		emit.emitvfx(dashspirit)
		local shoottween = tween_service:Create(spiritbomb.spiritbomb, TweenInfo.new(.75, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = TargetCFrame}):Play()

		local shoottween = tween_service:Create(spiritbomb1, TweenInfo.new(.75, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = TargetCFrame}):Play()

		local ex = script.Move3:FindFirstChild("explosion"):Clone()
		ex.CFrame = TargetCFrame * CFrame.new(0,-1,0)
		ex.Parent = effectsfolder
		debris.AddItem(ex,7)

		local beam = script.Move3:FindFirstChild("beam"):Clone()
		beam.Folder.RootPart.CFrame = TargetCFrame * CFrame.new(0,-1,0)
		debris.AddItem(beam,6)

		task.wait(1/1.5)
		emit.enablevfx(spiritbomb,false)  
		emit.enablevfx(spiritbomb1,false)  

		beam.Parent = effectsfolder

		task.spawn(function()
			local maxSize = 2 -- Defina o tamanho máximo desejado
			local step = 0.01
			local duration = 0.2 -- Defina a duração total do crescimento em segundos

			local numSteps = maxSize / step
			local interval = duration / numSteps

			for i = 1, numSteps do
				local t = i / numSteps
				local smoothScale = t^0.2 * maxSize -- Função de interpolação cúbica
				beam:ScaleTo(smoothScale)
				task.wait(interval/1.5)
			end

		end)


		local a = tween_service:Create(ex.PointLight,TweenInfo.new(.1,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 22}):Play()

		emit.emitvfx(ex)


		local a = tween_service:Create(spiritbomb.spiritbomb.PointLight,TweenInfo.new(.1,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 0}):Play()

		task.wait(0.1/1.5)



		spiritbomb:Destroy()

		task.wait(1.7/1.5)

		emit.emitvfx(ex)





		beam:Destroy()



		local a = tween_service:Create(ex.PointLight,TweenInfo.new(.1,Enum.EasingStyle.Linear, Enum.EasingDirection.Out,0,false,0),{Range = 0}):Play()

	end)

	task.wait(1.8/1.5)


	local tp = script.Move3:FindFirstChild("tp"):Clone()
	tp.CFrame = rt.CFrame * CFrame.new(0,6,0)
	tp.Parent = effectsfolder
	debris.AddItem(tp,4)

	emit.emitvfx(tp)


	local grdash1 = script.Move3:FindFirstChild("grdash"):Clone()
	grdash1.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	grdash1.Orientation = Vector3.new()
	grdash1.Parent = effectsfolder
	debris.AddItem(grdash1,4)

	task.wait(0.05/1.5)


	emit.emitvfx(grdash1)




	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
