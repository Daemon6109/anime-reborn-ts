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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["move1"], rt, Replicated.SoundGroups.UnitSFX)

	
	
	local move1 = script.Move1:FindFirstChild("move1"):Clone()
	move1.Parent = effectsfolder
	debris.AddItem(move1,5)
	move1.jump.CFrame = rt.CFrame * CFrame.new( 0 , -1.25 , 0 )


	local emits = script.Move1:FindFirstChild("emits"):Clone()
	emits.Parent = effectsfolder
	debris.AddItem(move1,5)
	emits.Part.CFrame = rt.CFrame * CFrame.new( 0 , 0 , -3 )


	emit.emitvfx(move1)

	wait(0.9)

	emit.enablevfx(unit["Right Arm"],true)

	wait(0.54)

	local shoottween = tween_service:Create(emits.Part.PointLight, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 15}):Play()


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
			--ShakeScreen(0.2, 0.04, 0.175)
		end)
	end)

	emit.emitvfx(emits)



	wait(.15)

	emit.enablevfx(unit["Right Arm"],false)

	wait(0.2)

	local shoottween = tween_service:Create(emits.Part.PointLight, TweenInfo.new(1.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {Range = 0}):Play()


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
