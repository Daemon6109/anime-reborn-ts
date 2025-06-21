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
	HitDelay = .35, -- seconds
	HitCount = 10, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .16, -- delay between hits in a multi-hit move
}

local effectsfolder = workspace.Effects

local function Sound(instance, parent, debrisTime)
	local audio = instance:Clone()
	audio.Parent = parent
	audio:Play()

	game.Debris:AddItem(audio, debrisTime)
end


local function EmitParticles(part)
	for i,v in part:GetDescendants() do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") then
			coroutine.wrap(function()
				task.wait(v:GetAttribute("EmitDelay"))
				if not v:IsA("Beam") then
					v:Emit(v:GetAttribute("EmitCount"))
				end 

				local _delay = v:GetAttribute("EmitDuration")
				if _delay then
					v.Enabled = true
					task.delay(_delay, function()
						v.Enabled = false
					end)
				end
			end)()
		end
	end
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation3, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)
	
	local Length = (rt.Position - pos.Position).magnitude - 2
	local back = rt.CFrame

	local dashg = script.Attack3:FindFirstChild("Dash"):Clone()
	dashg.CFrame = rt.CFrame * CFrame.new(0,-0.8,0)
	dashg.Parent = effectsfolder
	debris.AddItem(dashg,6)

	task.wait(0.1)

	EmitParticles(dashg)

	task.wait(0.05)

	local ttt = script.Attack3:FindFirstChild("Emits"):Clone()
	ttt.CFrame = rt.CFrame * CFrame.new(0,4,0)
	ttt.Parent = effectsfolder
	debris.AddItem(ttt,4)

	local initialCFrame = rt.CFrame -- Armazena a posição inicial uma vez

	local dashe = script.Attack3:FindFirstChild("Dashes"):Clone()
	dashe.CFrame = rt.CFrame
	dashe.Parent = effectsfolder
	debris.AddItem(dashe,4)


	local highlight = Instance.new("Highlight")
	highlight.Parent = unit
	debris.AddItem(highlight,6)
	highlight.FillColor = Color3.new(0.545098, 0.529412, 1)
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 1

	local clow = tween_service:Create(
		highlight, 
		TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 
		{FillTransparency = 0}
	)
	clow:Play()

	EmitParticles(dashe)

	spawn(function()

		for i = 1, 28 do
			-- Calcula o deslocamento alternando entre negativo e positivo
			local offsetX = (i % 2 == 0) and 3 or -3

			-- Dash para frente
			local dashForward = tween_service:Create(
				rt, 
				TweenInfo.new(0.03, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
				{CFrame = initialCFrame * CFrame.new(offsetX, 0, 0)}
			)
			dashForward:Play()

			task.wait(0.03)

			-- Retorna para a posição original
			local dashBack = tween_service:Create(
				rt, 
				TweenInfo.new(0.03, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
				{CFrame = initialCFrame}
			)
			dashBack:Play()

			task.wait(0.03)
		end

	end)

	EmitParticles(ttt)

	task.wait(1.3)

	local clow = tween_service:Create(
		highlight, 
		TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 
		{FillTransparency = 1}
	)
	clow:Play()

	task.wait(1)



	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
