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
	HitDelay = 2, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .05, -- delay between hits in a multi-hit move
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
	SoundWrapper:PlaySound(script["move2"], rt, Replicated.SoundGroups.UnitSFX)


	
	local move2 = script.Move2:FindFirstChild("move2"):Clone()

	move2.jump.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	move2.Parent = effectsfolder
	debris.AddItem(move2,5)

	local MainBox = script.Move2:FindFirstChild("MainBox"):Clone()

	MainBox.CFrame = rt.CFrame * CFrame.new(0,0.8,0)
	MainBox.Parent = effectsfolder
	debris.AddItem(MainBox,5)

	local Part = script.Move2:FindFirstChild("Part"):Clone()

	Part.CFrame = rt.CFrame * CFrame.new(0,0,-3.35)
	Part.Parent = effectsfolder
	debris.AddItem(Part,5)

	local a = script.Move2:FindFirstChild("a"):Clone()

	a.CFrame = rt.CFrame * CFrame.new(0,0,-2.35)
	a.Parent = effectsfolder
	debris.AddItem(a,5.5)


	local emits = script.Move2:FindFirstChild("emits"):Clone()

	emits.Part.CFrame = rt.CFrame * CFrame.new(0,0,-2.35)
	emits.Parent = effectsfolder
	debris.AddItem(emits,5.5)

	emit.emitvfx(move2)

	wait(.75)


	emit.enablevfx(MainBox,true)



	wait(0.6)


	emit.enablevfx(unit.Bisento.Handle.enablethis,true)

	emit.enablevfx(MainBox,false)

	wait(0.5)

	emit.emitvfx(emits)

	spawn(function()

		local unit = rt -- Supondo que rt seja uma parte ou instância da sua unidade
		local unitPosition = unit.Position -- Acessa a propriedade Position da unidade
		local tremorDistance = 25 -- Distância máxima para causar o tremor (em studs)

		-- Função para calcular a distância entre o player e a unidade
		
		-- THIS IS FOR A POTENTIAL CAMERA SHAKE
		
		local function isPlayerNear()
			
			
			--local playerPosition = character:WaitForChild("HumanoidRootPart").Position THIS IS FOR A POTENTIAL CAMERA 
			
			
--			local distance = (playerPosition - unitPosition).Magnitude
		--	return distance <= tremorDistance
		end
		
		-- THIS IS FOR A POTENTIAL CAMERA SHAKE
		
		
		local function ShakeScreen(intensity, frequency, duration)
			if not isPlayerNear() then return end -- Se o player estiver longe, não treme

			local startTime = tick()

			local function onRenderStep()
				if tick() - startTime < duration then
					local offset = Vector3.new(
						math.random() * intensity - intensity / 2,
						math.random() * intensity - intensity / 2,
						math.random() * intensity - intensity / 2
					)
					--humanoid1.CameraOffset = offset
				else
					--humanoid1.CameraOffset = Vector3.new() -- Parar o tremor
					--RunService:UnbindFromRenderStep("CameraShake")
				end
			end

--			RunService:BindToRenderStep("CameraShake", Enum.RenderPriority.Camera.Value, onRenderStep)
		end


		-- THIS IS FOR A POTENTIAL CAMERA SHAKE

		task.spawn(function()
			-- Exemplo: Apenas um ataque especial causa tremor
			--ShakeScreen(0.2, 0.04, 0.2)
		end)

	end)


	emit.emitvfx(a)

	emit.emitvfx(Part)

	local Handle = script.Move2:FindFirstChild("Handle"):Clone()

	Handle.CFrame = rt.CFrame * CFrame.new(0,0,-1.5)
	Handle.Parent = effectsfolder
	debris.AddItem(Handle,5)

	emit.enablevfx(Handle,true)

	emit.enablevfx(unit.Bisento.Handle.enablethis,false)



	local shoottween = tween_service:Create(Handle, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {CFrame = rt.CFrame * CFrame.new(0,0,-15)}):Play()



	wait(0.3)

	Handle.enablethis.Emit:Emit(1)


	emit.enablevfx(Handle,false)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
