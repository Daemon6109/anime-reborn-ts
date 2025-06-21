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
	HitDelay = 3.15, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .3, -- delay between hits in a multi-hit move
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
	
	local G_1 = unit.Gamma1
	local G_2 = unit.Gamma2

	local rtG1 = unit.Gamma1:WaitForChild("HumanoidRootPart")
	local rtG2 = unit.Gamma2:WaitForChild("HumanoidRootPart")

		
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script["Animation3(G1)"], G_1, 1, "", {Weight = 2, Fade = .15})
	AnimModule.PlayAnim(script["Animation3(G2)"], G_2, 1, "", {Weight = 2, Fade = .15})	
	
	SoundWrapper:PlaySound(script["Move3"], rt, Replicated.SoundGroups.UnitSFX)
	
	G_1.Blast1.Transparency = 0
	G_2.Blast1.Transparency = 0

	task.wait(0.9)

	local prk = script.Attack3:FindFirstChild("Prk"):Clone()
	prk.CFrame = unit.HumanoidRootPart.CFrame * CFrame.new(0,0.5,0)
	prk.Parent = effectsfolder
	debris.AddItem(prk,4)

	local tep = script.Attack3:FindFirstChild("Shoty"):Clone()
	tep.CFrame = rtG2.CFrame * CFrame.new(0,0.4,-2)
	tep.Parent =effectsfolder
	debris.AddItem(tep,4)

	EmitParticles(tep)

	EmitParticles(prk)

	task.wait(1.3)

	local fakepos = Instance.new("Part")
	fakepos.Anchored = true
	fakepos.Size = Vector3.new(0.2,0.2,0.2)
	fakepos.Transparency = 1
	fakepos.Parent = effectsfolder
	fakepos.CFrame = pos.CFrame 
	debris.AddItem(fakepos,4)

	fakepos.CFrame = CFrame.new(fakepos.Position, rtG2.Position)

	task.wait(0.25)

	local beam = script.Attack3:FindFirstChild("Special"):Clone()
	beam.Parent = workspace.Camera
	beam.Final.Orientation = rtG2.Orientation

	beam.Final.CFrame = CFrame.new(rtG2.Position, fakepos.Position)
	beam.Start.CFrame = CFrame.new(rtG2.Position, fakepos.Position)

	beam.Final.CFrame = rtG2.CFrame * CFrame.new(0,0.3,-2)
	beam.Start.CFrame = rtG2.CFrame * CFrame.new(0,0.3,-2)

	debris.AddItem(beam,6)

	local midpoint = (rtG2.Position + fakepos.Position) / 2

	beam.MeshPart.CFrame = rtG2.CFrame * CFrame.new(0,0.3,-2)
	beam.MeshPart.Orientation = rtG2.Orientation

	task.wait(0.3)

	EmitParticles(beam)

	local shoottween = tween_service:Create(beam.Final,TweenInfo.new(0.3,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{CFrame = beam.Final.CFrame * CFrame.new(0,0,-15)}):Play()

	local shoottween = tween_service:Create(beam.MeshPart,TweenInfo.new(0.3,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Size = Vector3.new(3.118, 3.118,8)}):Play()
	local shoottween = tween_service:Create(beam.MeshPart,TweenInfo.new(0.3,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{CFrame = beam.MeshPart.CFrame * CFrame.new(0,0,-8)}):Play()

	local bb1 = script.Attack3:FindFirstChild("MainBox"):Clone()
	bb1.CFrame = rtG2.CFrame * CFrame.new(0,-0.9,0)
	bb1.Parent = effectsfolder
	debris.AddItem(bb1,5)

	EmitParticles(bb1)

	for _, v in pairs(beam.Start.Folder:GetChildren()) do
		if v:IsA("Beam") then
			spawn(function()
				local w0 = v.Width0 + 0.3
				local w1 = v.Width1 + 0.3
				local c0 = v.CurveSize0 + 0.3
				local c1 = v.CurveSize1 + 0.3
				local vv = v.TextureSpeed 

				v.Width0 = 0
				v.Width1 = 0
				v.CurveSize0 = 0
				v.CurveSize0 = 0

				-- Primeiro tween para expandir o Width
				local tween1 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Width0 = w0, Width1 = w1})
				tween1:Play()

				local tween2 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CurveSize0 = c0, CurveSize1 = c1})
				tween2:Play()

				local tween2 = tween_service:Create(v, TweenInfo.new(0.6, Enum.EasingStyle.Linear), {TextureSpeed = vv * 1.6})
				tween2:Play()

				task.wait(1.4)

				local tween1 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Width0 = w0 * 2.2, Width1 = w1 * 2.2})
				tween1:Play()

				local tween2 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CurveSize0 = c0 * 2.7, CurveSize1 = c1 * 2.7})
				tween2:Play()

				local tween2 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {TextureSpeed = vv * 2.2})
				tween2:Play()

				task.wait(0.2)

				-- Segundo tween para reduzir o Width gradualmente
				local tween2 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {Width0 = 0, Width1 = 0})
				tween2:Play()

				local tween2 = tween_service:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CurveSize0 = 0, CurveSize1 = 0})
				tween2:Play()

			end)
		end
	end

	task.wait(1.4)


	local shoottween = tween_service:Create(beam.MeshPart,TweenInfo.new(0.3,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Size = Vector3.new(6.518, 6.518, 8)}):Play()

	task.wait(0.2)

	local shoottween = tween_service:Create(beam.Final,TweenInfo.new(0.3,Enum.EasingStyle.Linear, Enum.EasingDirection.InOut,0,false,0),{CFrame = beam.Final.CFrame * CFrame.new(0,0,-8)}):Play()

	local shoottween = tween_service:Create(beam.MeshPart,TweenInfo.new(0.2,Enum.EasingStyle.Back, Enum.EasingDirection.InOut,0,false,0),{Size = Vector3.new(0,0,0)}):Play()

	G_1.Blast1.Transparency = 1
	G_2.Blast1.Transparency = 1
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
