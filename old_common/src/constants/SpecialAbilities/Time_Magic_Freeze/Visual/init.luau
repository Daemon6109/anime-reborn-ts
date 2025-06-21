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
local run_service = game:GetService("RunService")

module.config = {
	HitDelay = 1.7, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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


function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart

	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame

	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	local Mnainanim = AnimModule.PlayAnim(script.Animation1, unit, 1, "Mainanim", {Weight = 2, Fade = .15})

	SoundWrapper:PlaySound(script.Sound, rt, Replicated.SoundGroups.UnitSFX)
 	--AnimModule.PlayAnim(script.Animation1, unit, 1, "Mainaim", {Weight = 2, Fade = .15})

	local magic = script.Ability:FindFirstChild("Magic"):Clone()
	magic.root.CFrame = rt.CFrame * CFrame.new(0,33,0)
	magic.Parent = effectsfolder
	debris.AddItem(magic,10)

	emit.emitvfx(magic)

	local ata = script.Ability:FindFirstChild("ata"):Clone()
	ata.CFrame = rt.CFrame * CFrame.new(0,32,0)
	ata.Parent = effectsfolder
	debris.AddItem(ata,10)
	
	local book = script.Ability:FindFirstChild("Julius Spiral Book Thing [ Anime Reborn ]"):Clone()
	book.root.CFrame = rt.CFrame * CFrame.new(0,10,3)
	book.Parent = effectsfolder
	debris.AddItem(book,10)


	local ata1 = script.Ability:FindFirstChild("ata1"):Clone()
	ata1.CFrame = rt.CFrame * CFrame.new(0,10,3)
	ata1.Parent = effectsfolder
	debris.AddItem(ata1,10)


	local Part = script.Ability:FindFirstChild("Part"):Clone()
	Part.Part.CFrame = rt.CFrame * CFrame.new(0,-1,0)
	Part.Parent = effectsfolder
	debris.AddItem(Part,10)

	EmitParticles(ata1)

	spawn(function()
		local maxSize = 1 -- Tamanho máximo desejado
		local step = 0.1 -- Aumente o passo para menos iterações
		local growthDuration = 0.4 -- Duração total do crescimento em segundos
		local numSteps = maxSize / step
		local growthInterval = growthDuration / numSteps

		-- Crescimento do modelo
		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.4 * maxSize -- Interpolação cúbica
			book:ScaleTo(smoothScale)
			task.wait(growthInterval)
		end
	end)


	local camera = workspace.CurrentCamera

	local part = script.Ability:FindFirstChild("Delay0.3"):Clone()
	part.Parent = effectsfolder
	debris.AddItem(Part,8)



	local con = run_service.RenderStepped:Connect(function()
		local cameraCFrame = camera.CFrame
		part.Position = cameraCFrame.Position + cameraCFrame.LookVector * 1 -- Ajuste a distância (aqui está 5 studs)
	end)


	wait(0.4)



	book.Book.Anchored = true


	tween_service:Create(book.root, TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), { CFrame = book.root.CFrame * CFrame.new(0,3,0)}):Play()

		


	task.wait(0.001)


--tween_service:Create(book.Book, TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), { Orientation = Vector3.new(0,800,0)}):Play()

	EmitParticles(ata)

	spawn(function()
		local maxSize = 1.35 -- Tamanho máximo desejado
		local step = 0.1 -- Aumente o passo para menos iterações
		local growthDuration = 0.4 -- Duração total do crescimento em segundos
		local numSteps = maxSize / step
		local growthInterval = growthDuration / numSteps

		-- Crescimento do modelo
		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^0.4 * maxSize -- Interpolação cúbica
			magic:ScaleTo(smoothScale)
			task.wait(growthInterval)
		end
	end)




	wait(0.75)

	emit.enablevfx(part,true)
	
	magic.root.Hora:Destroy()
	magic.root.Minuto:Destroy()

	magic.Hora.Anchored = true
	magic.Minuto.Anchored = true

	task.wait(0.001)


	--tween_service:Create(magic.Hora, TweenInfo.new(5.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), { Rotation = Vector3.new(0,800,0)}):Play()
	--tween_service:Create(magic.Minuto, TweenInfo.new(5.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), { Rotation = Vector3.new(0,5000,0)}):Play()
	task.wait(.5)

	spawn(function()
		local maxSize = 1 -- Tamanho máximo desejado
		local step = 0.1 -- Aumente o passo para menos iterações
		local growthDuration = 1 -- Duração total do crescimento em segundos
		local numSteps = maxSize / step
		local growthInterval = growthDuration / numSteps

		-- Crescimento do modelo
		for i = 1, numSteps do
			local t = i / numSteps
			local smoothScale = t^1 * maxSize -- Interpolação cúbica
			Part:ScaleTo(smoothScale)
			task.wait(growthInterval)
		end
	end)

	emit.enablevfx(Part,true)


	task.wait(4)
	
	con:Disconnect()

	emit.enablevfx(part,false)

	emit.enablevfx(book,false)

	--tween_service:Create(magic.Hora, TweenInfo.new(5.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), { Rotation = Vector3.new(0,800,0)}):Play()
	tween_service:Create(book.Book, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Size = Vector3.new(0,0,0)}):Play()

	EmitParticles(ata)

	emit.enablevfx(Part,false)
	emit.enablevfx(magic,false)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
