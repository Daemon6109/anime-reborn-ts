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
	HitDelay = 1.75, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
}


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	AnimModule.PlayAnim(script.Animation2, unit, 1, "", {Weight = 2, Fade = .15})


	SoundWrapper:PlaySound(Sounds["cape2"], rt, Replicated.SoundGroups.UnitSFX)

	local mv2 = script.hellblaze:Clone()    
	mv2.hellblaze.CFrame = unit["Left Arm"].position1.CFrame
	mv2.Parent = workspace.Effects
	debris.AddItem(mv2,5)

	local flames2 = script.flames2:Clone()
	flames2.CFrame = pos.CFrame * CFrame.new(0,-1,0)
	flames2.Parent = workspace.Effects
	debris.AddItem(flames2,6.5)

	local darkexplosion = script:FindFirstChild("darkexplosion"):Clone()
	darkexplosion.Part.CFrame = pos.CFrame * CFrame.new(0,-0.5,0)
	debris.AddItem(darkexplosion,6)


	local a = script:FindFirstChild("a"):Clone()
	a.CFrame = rt.CFrame * CFrame.new(0,0,-0.5)
	a.Parent = workspace.Effects
	debris.AddItem(a,6)

	local Flames = script:FindFirstChild("Flames"):Clone() -- MOVE 3 VFX
	Flames.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	Flames.Parent = workspace.Effects
	debris.AddItem(Flames,5)

	mv2.hellblaze.Anchored = false

	local part1 = unit["Left Arm"].position1 -- Altere para o caminho da sua primeira parte
	local part2 = mv2.hellblaze -- Altere para o caminho da sua segunda parte


	wait(0.2)

	SoundWrapper:PlaySound(Sounds["Flame Licks 6 (SFX)"], rt, Replicated.SoundGroups.UnitSFX)

	unit["Left Arm"].position1.emit:Emit(1)

	tween_service:Create(mv2.hellblaze.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Range = 12}):Play()
	darkexplosion.Parent = workspace.Effects

	spawn(function()
		local maxSize = 1.5 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.25 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.25 * maxSize -- Função de interpolação cúbica
			mv2:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)


	local weld = Instance.new("Weld")
	weld.Part0 = part1
	weld.Part1 = part2
	weld.Parent = part1
	debris.AddItem(weld,4)


	wait(0.7)

	SoundWrapper:PlaySound(Sounds["earthpass1"], mv2.hellblaze, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(Flames,true)

	tween_service:Create(Flames, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = darkexplosion.Part.CFrame * CFrame.new(0,0.75,0)}):Play()
	emit.emitvfx(a)

	mv2.hellblaze.Anchored = true

	tween_service:Create(mv2.hellblaze, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {CFrame = darkexplosion.Part.CFrame * CFrame.new(0,1,0)}):Play()



	wait(0.325)

	SoundWrapper:PlaySound(Sounds["fire-ignite1"], mv2.hellblaze, Replicated.SoundGroups.UnitSFX)

	emit.enablevfx(Flames,false)

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
			rock.Parent = game.Workspace

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
				wait(3)
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

		CreateImpact(target.Position + Vector3.new(0, -1.7, 0), 16)
	end)

	SoundWrapper:PlaySound(Sounds["Explosion Sound"], mv2.hellblaze, Replicated.SoundGroups.UnitSFX)
	
	spawn(function()
		local maxSize = .5 -- Defina o tamanho máximo desejado
		local step = 0.01
		local duration = 0.1 -- Defina a duração total do crescimento em segundos

		local numSteps = maxSize / step
		local interval = duration / numSteps

		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.1 * maxSize -- Função de interpolação cúbica
			darkexplosion:ScaleTo(smoothScale)
			task.wait(interval)
		end
	end)

	tween_service:Create(darkexplosion.Part.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Range = 20}):Play()
	emit.emitvfx(flames2)

	tween_service:Create(mv2.hellblaze.PointLight, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0), {Range = 0}):Play()
	emit.enablevfx(mv2,false)

	darkexplosion.InnerParticleDome.Anchored = true

	task.wait()

	tween_service:Create(darkexplosion.InnerParticleDome,TweenInfo.new(1.6,Enum.EasingStyle.Linear,Enum.EasingDirection.Out),{Orientation = Vector3.new(0,1000,0)}):Play()


	task.wait(1)

	SoundWrapper:PlaySound(Sounds["earthburst1"], darkexplosion, Replicated.SoundGroups.UnitSFX)

	emit.emitvfx(flames2)

	emit.enablevfx(darkexplosion,false)

	for i ,v in ipairs(darkexplosion.beam.beams:GetDescendants()) do
		if v.Name == "Beam"  then
			tween_service:Create(v,TweenInfo.new(.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Width0 = 0,Width1 = 0}):Play()
		end
	end

	tween_service:Create(darkexplosion.Part.PointLight,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Range = 0}):Play()

	tween_service:Create(darkexplosion.InnerParticleDome,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{Transparency = 1}):Play()

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
