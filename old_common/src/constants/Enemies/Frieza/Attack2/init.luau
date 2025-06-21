local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)
local Sounds = script

module.config = {
	HitDelay = 1, -- seconds
	Duration = 2,
	TurnTime = .7,
	StunTime = 5,
	AttackRange = 35,
	AttackSize = 15,
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	--rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(Sounds["Dragon-Ball-Z-Punch-Sound-Effect-N°9"], rt, Replicated.SoundGroups.UnitSFX)

	local lightning = script.lightning:Clone()
	lightning.rootpart.CFrame = pos.CFrame * CFrame.new(0,-0.9,0)
	lightning.Parent = workspace.Effects
	debris.AddItem(lightning,4)

	local lightning1 = script.lightning1:Clone()
	lightning1.CFrame = rt.CFrame * CFrame.new(-0.5,1,0)
	lightning1.Parent = workspace.Effects
	debris.AddItem(lightning1,4)

	wait(0.1)

	emit.enablevfx(unit.Torso.ativ3,true)

	emit.enablevfx(unit["Left Arm"].enable,true)

	SoundWrapper:PlaySound(Sounds["lightningstrike1"], rt, Replicated.SoundGroups.UnitSFX)

	wait(0.4)

	emit.emitvfx(lightning1)

	wait(0.2)

	SoundWrapper:PlaySound(Sounds["explosion3"], lightning.rootpart, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(unit.Torso.ativ3,false)

	emit.enablevfx(unit["Left Arm"].enable,false)

	SoundWrapper:PlaySound(Sounds["small lightning"], lightning.rootpart, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(lightning)


	wait(0.05)


	spawn(function()
		local target = pos

		-- Função para criar uma pedra (rock)
		local function SpawnRock(position)
			local rock = Instance.new("Part")
			rock.Name = "Rock"
			rock.Size = Vector3.new(0, 0, 0) -- Começa com tamanho 0
			rock.Anchored = true
			rock.CanCollide = false
			rock.Position = position
			rock.Parent = game.Workspace.Effects

			-- Função para detectar o material e a cor das partes abaixo
			local function DetectMaterialAndColor(pos)
				local rayOrigin = pos + Vector3.new(0, 1, 0)
				local rayDirection = Vector3.new(0, -5, 0)
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {rock}
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local raycastResult = game.Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

				if raycastResult then
					local hitPart = raycastResult.Instance
					if hitPart and hitPart:IsA("BasePart") then
						return hitPart.Material, hitPart.BrickColor
					end
				end

				return Enum.Material.Slate, BrickColor.new("Dark stone grey")
			end

			-- Detecta o material e a cor da parte abaixo
			local material, color = DetectMaterialAndColor(position)
			rock.Material = material
			rock.BrickColor = color

			local randomRotation = Vector3.new(math.random(-180, 180), math.random(-180, 180), math.random(-180, 180))
			rock.Orientation = randomRotation

			local growTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out) -- Duração da animação e estilo
			local growEndSize = Vector3.new(math.random(1, 2.4), math.random(1, 5.4), math.random(1, 2.4)) -- Tamanho final da pedra
			local growTween = tween_service:Create(rock, growTweenInfo, {Size = growEndSize}) -- Criar a animação

			local shrinkTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In) -- Duração da animação e estilo
			local shrinkEndSize = Vector3.new(0, 0, 0)
			local shrinkTween = tween_service:Create(rock, shrinkTweenInfo, {Size = shrinkEndSize}) -- Criar a animação

			growTween:Play()

			spawn(function()
				wait(2.3)
				shrinkTween:Play()
			end)
			shrinkTween.Completed:Connect(function()
				rock:Destroy()
			end)
		end

		local function CreateImpact(targetPosition, numRocks)
			local radius = 8 -- Raio de dispersão das pedras
			for i = 1, numRocks do
				local angle = math.random() * 2 * math.pi -- Ângulo aleatório
				local offsetX = radius * math.cos(angle)
				local offsetY = radius * math.sin(angle)
				local rockPosition = targetPosition + Vector3.new(offsetX, 0, offsetY)
				SpawnRock(rockPosition)
			end
		end

		CreateImpact(target.Position + Vector3.new(0, -1.6, 0), 16)
	end)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
