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
	HitDelay = .5, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .35, -- delay between hits in a multi-hit move
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
	
	local explode =  script.attack1:FindFirstChild("Bomb"):Clone()
	explode.Parent = effectsfolder
	explode.CFrame = pos.CFrame * CFrame.new(0,0,0)
	debris.AddItem(explode,5.5)



	for i = 1,4 do
		local rocket = script.attack1:FindFirstChild("Part"):Clone()
		rocket.Parent = workspace
		debris.AddItem(rocket,2)
		rocket.CFrame = unit["Left Arm"].startpart.CFrame

		wait(0.3)
		local rocketpos = unit["Left Arm"].startpart.Position
		local enemypos = pos.Position

		local magnitude = (rocketpos-enemypos).magnitude
		local Step = 25

		local LookAt = CFrame.new(rocketpos,enemypos)

		local Time = math.random(-50,50)/25
		local Time2 = math.random(25,50)/100
		spawn(function()

			for i = 1,Step do
				rocket.CFrame = LookAt*CFrame.new(math.sin(math.rad((i * -(180/Step))))*(2.5 * Time),math.sin(math.rad((i * (180/Step))))*(0.5 * Time2),-(magnitude/Step) * (i))
				game:GetService("RunService").Heartbeat:Wait()
			end

			for i, v in pairs(explode:GetDescendants()) do
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
