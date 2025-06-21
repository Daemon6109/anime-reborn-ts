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



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	--SoundWrapper:PlaySound(script["move1Charge"], rt, Replicated.SoundGroups.UnitSFX)

	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame

	local ee = 0	
	local a1 = 1.5
	local a2 = 5
	local a3 = 1.5

	local glow = script.Attack1:FindFirstChild("Glowing"):Clone()
	glow.CFrame = rt.CFrame * CFrame.new(0,1,0)
	glow.Parent = effectsfolder
	debris.AddItem(glow,4)

	EmitParticles(glow)

	spawn(function()

		for i = 1,10 do

			a1 = a1 * 1.105
			a2 = a2 * 1.105
			a3 = a3 * 1.105

			spawn(function()
				for i = 1,math.random(2,3) do

					spawn(function()

						local meshes = {'a1','a2','a3','a4','a5','a6','a7'}

						local function cloneMesh(meshName)
							local mesh = script.Attack1["MiniRocks"]:FindFirstChild(meshName):Clone()
							mesh.Parent = effectsfolder
							debris.AddItem(mesh,5)
							return mesh
						end

						local function chooseAndCloneRandomMesh()
							local randomIndex = math.random(#meshes)
							local meshToClone = meshes[randomIndex]
							return cloneMesh(meshToClone)
						end

						local target = chooseAndCloneRandomMesh()

						target.CFrame = rt.CFrame * CFrame.new(math.random(-1,1), -0.7, -ee + 2)
						target.Orientation = Vector3.new(math.random(-45,45), rt.Orientation.y + math.random(-150, 45), math.random(0, 25))
						target.Parent = unit
						target.Transparency = math.random(0,2)/10

						debris.AddItem(target, 3)

				

						EmitParticles(target)
						local shoottween = tween_service:Create(
							target, 

							TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
							{Size = Vector3.new(a1 + math.random(1, 2)/10, a2 + math.random(5, 10)/10, a3 + math.random(1, 2)/10)}
						)
						shoottween:Play()

						wait(0.1)

						for _, v in pairs(target:GetChildren()) do
							if v:IsA("ParticleEmitter") then
								v:Emit(v:GetAttribute("EmitCount"))
							end
						end

						wait(1.35)
						target.Material = Enum.Material.Neon

						local colorTween = tween_service:Create(
							target, 
							TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
							{Color = Color3.new(0.686275, 0.647059, 1)}
						)
						colorTween:Play()

						local explodeTween = tween_service:Create(
							target, 
							TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
							{
								Size = target.Size * 1.2
							}
						)
						explodeTween:Play()

						task.wait(0.1)

			

						local fadeTween = tween_service:Create(
							target, 
							TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
							{Transparency = 1}
						)
						fadeTween:Play()
					end)

				end			
			end)

			task.wait(0.01)					

			ee = ee + 2.5 / 1.5
		end

	end)

	task.wait(0.7)

	local connect = script.Attack1:FindFirstChild("Connect"):Clone()
	connect.CFrame = rt.CFrame * CFrame.new(0,-0.9,0)
	connect.Parent = effectsfolder
	debris.AddItem(connect,6)

	local connect2 = script.Attack1:FindFirstChild("Silver Shatter"):Clone()
	connect2.CFrame = rt.CFrame * CFrame.new(0,3,-11)
	connect2.Parent = effectsfolder
	debris.AddItem(connect2,6)

	EmitParticles(connect)
	task.wait(0.2)

	EmitParticles(connect2)
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
