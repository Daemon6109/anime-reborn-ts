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
	HitDelay = 1.54, -- seconds
	HitCount = 5, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .14, -- delay between hits in a multi-hit move
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
	
	AnimModule.PlayAnim(script.Animation1, unit, 1.2, "", {Weight = 2, Fade = .15})
	
	task.spawn(function()
		task.wait(1.2)
		SoundWrapper:PlaySound(script["Move1sfx"], rt, Replicated.SoundGroups.UnitSFX)

	end)

	local Length = (rt.Position - pos.Position).magnitude
	local back = rt.CFrame
	
	task.wait(1.4)

	emit.enablevfx(unit["Right Arm"].frame1,true)
	spawn(function()
		for i = 1,12 do
			task.wait(.07)


			local kiblast = script.Attack1:FindFirstChild("balls"):Clone()
			kiblast.root.CFrame = unit["Right Arm"].frame1.CFrame
			kiblast.Parent = effectsfolder
			debris.AddItem(kiblast,4)


			local rocketpos = kiblast.root.Position
			local enemypos = pos.Position + Vector3.new(math.random(-7,7),math.random(-1,-1),math.random(-7,7))
			local magnitude = (rocketpos-enemypos).magnitude
			local Step = 12
			local LookAt = CFrame.new(rocketpos,enemypos)
			local Time = math.random(-45,45)/100
			local Time2 = math.random(-45,45)/200
			spawn(function()
				for i = 1,Step do
					kiblast.root.CFrame = LookAt* CFrame.new(math.sin(math.rad((i * -(180/Step))))* (15 * Time),math.sin(math.rad((i * (180/Step))))* (5 * Time2),-(magnitude/Step) * (i))
					game:GetService("RunService").Heartbeat:Wait()
				end
				kiblast.FireBall.Transparency = 1
				emit.enablevfx(kiblast,false)


				local EXP = script.Attack1:FindFirstChild("EXP"):Clone()
				EXP.CFrame = kiblast.root.CFrame
				EXP.Parent = effectsfolder
				debris.AddItem(EXP,4)
				EXP.Orientation = Vector3.new()

				EmitParticles(EXP)



			end)

		end

	end)

	task.wait(0.84)


	emit.enablevfx(unit["Right Arm"].frame1,false)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
