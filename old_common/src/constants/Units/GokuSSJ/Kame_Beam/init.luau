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
	HitDelay = 1.5, -- seconds
	HitCount = 8, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation2, unit, 1.4, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move2SFX"], rt, Replicated.SoundGroups.UnitSFX, {PlaybackSpeed = 1.4})



	local kamehameha = script.Move2:FindFirstChild("kamehameha"):Clone()
	kamehameha.rootpart.CFrame = rt.CFrame * CFrame.new(0,0,-2.5)
	kamehameha.Parent = effectsfolder
	debris.AddItem(kamehameha,4.5)
	kamehameha.rootpart.CFrame = CFrame.new(kamehameha.rootpart.Position, pos.Position)


	local ex = script.Move2:FindFirstChild("ExplosionImpact12"):Clone()
	ex.CFrame = rt.CFrame * CFrame.new(0,0,-1.5)
	ex.Parent = effectsfolder
	debris.AddItem(ex,5.5)

	local aa = script.Move2:FindFirstChild("a"):Clone()
	aa.CFrame = rt.CFrame * CFrame.new(0,0,-2.5)
	aa.Parent = effectsfolder
	debris.AddItem(aa,5.5)

	local bb = script.Move2:FindFirstChild("bb"):Clone()
	bb.CFrame = rt.CFrame * CFrame.new(0,0,-0.5)
	bb.Parent = effectsfolder
	debris.AddItem(bb,5.5)

	wait(0.5)

	emit.emitvfx(bb)

	emit.enablevfx(unit.end1,true)

	local movbeam = tween_service:Create(kamehameha.end1,TweenInfo.new(0.5,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{CFrame = pos.CFrame + (rt.CFrame.LookVector * 2)}):Play()


	wait(.75)

	emit.enablevfx(unit.end1,false)



	spawn(function()
		local maxSize = 1 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.2 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.2 * maxSize -- Função de interpolação cúbica
			kamehameha:ScaleTo(smoothScale)
			task.wait(interval)
		end

	end)

	wait(0.1)

	emit.emitvfx(aa)


	wait(1.15)

	emit.emitvfx(aa)

	emit.enablevfx(kamehameha,false)

	for i, v in pairs(kamehameha.end1.beam:GetChildren()) do
		if v:IsA("Beam") then
			local Transparencyshoottween = tween_service:Create(v,TweenInfo.new(0.2,Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0),{Width0 = 0,Width1 = 0}):Play()
		end
	end

	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
