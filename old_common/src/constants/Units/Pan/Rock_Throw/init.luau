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
	HitDelay = .7, -- seconds
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



function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	local SavedDirection = rt.CFrame.LookVector
	
	AnimModule.PlayAnim(script.Animation1, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Move1"], rt, Replicated.SoundGroups.UnitSFX)
	
	local explode =  script:FindFirstChild("impact"):Clone()
	explode.Parent = effectsfolder
	explode.CFrame = pos.CFrame * CFrame.new(0,0,0)
	debris.AddItem(explode,5.5)



	local explode2 =  script:FindFirstChild("impact33"):Clone()
	explode2.Parent = effectsfolder
	explode2.RootFX.CFrame = rt.CFrame * CFrame.new(0,0,0)
	explode2.RootFX.Orientation = Vector3.new(90, -129.999, 0)

	debris.AddItem(explode2,5.5)


	local impactred =  script:FindFirstChild("impactred"):Clone()
	impactred.Parent = effectsfolder
	impactred.Impale.CFrame = pos.CFrame * CFrame.new(0,0,0)
	impactred.Impale.Orientation = Vector3.new(0, -129.999, 0)

	debris.AddItem(explode2,5.5)


	local throwvfx =  script:FindFirstChild("throwvfx"):Clone()
	throwvfx.Parent = effectsfolder
	throwvfx.CFrame = rt.CFrame * CFrame.new(0,0,-1)
	throwvfx.Orientation = Vector3.new(-90, 50.001, 180)
	debris.AddItem(throwvfx,5.5)


	task.wait(0.3)
	for i, v in pairs(explode2:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end
	for i, v in pairs(throwvfx:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.delay(v:GetAttribute("EmitDelay"),function()
				v:Emit(v:GetAttribute("EmitCount"))
			end)
		end
	end




	for i = 1,1 do
		local rocket = script:FindFirstChild("Rock"):Clone()
		rocket.Parent = workspace
		debris.AddItem(rocket,1)
		rocket.CFrame = unit["Left Arm"].CFrame


		local rocketpos = unit["Left Arm"].Position
		local enemypos = pos.Position

		local magnitude = (rocketpos-enemypos).magnitude
		local Step = 25

		local LookAt = CFrame.new(rocketpos,enemypos)

		local Time = math.random(-50,50)/25
		local Time2 = math.random(25,50)/100
		spawn(function()

			for i = 1,Step do
				rocket.CFrame = LookAt*CFrame.new(math.sin(math.rad((i * -(180/Step))))*(2.5 * Time),math.sin(math.rad((i * (180/Step))))*(0 * Time2),-(magnitude/Step) * (i))
				game:GetService("RunService").Heartbeat:Wait()
			end

			for i, v in pairs(explode:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					task.delay(v:GetAttribute("EmitDelay"),function()
						v:Emit(v:GetAttribute("EmitCount"))
					end)
				end
			end

			for i, v in pairs(impactred:GetDescendants()) do
				if v:IsA("ParticleEmitter") then
					task.delay(v:GetAttribute("EmitDelay"),function()
						v:Emit(v:GetAttribute("EmitCount"))
					end)
				end
			end
		end)

	end
	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
