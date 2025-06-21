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
	HitDelay = 1.4, -- seconds
	HitCount = 3, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .035, -- delay between hits in a multi-hit move
}
function Bezier(t, p0, p1, p2)
	return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2 
end

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

	AnimModule.PlayAnim(script.firstattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["1"], rt, Replicated.SoundGroups.UnitSFX)

	

	task.wait(.13)
	
	
	task.spawn(function()
		unit.Weapon.Beams1.RIGHT.BeamR.Attachment1 = unit["Right Arm"].Forbeam
		unit.Weapon.Beams.LEFT.Beam.Attachment1 = unit["Right Arm"].Forbeam
		unit.UssopBall.Transparency = 0
		emit.emitvfx(unit.UssopBall)
		
		task.wait(.6)
		unit.UssopBall.Transparency = 1
	
		task.wait(.3)

		unit.Weapon.Beams.LEFT.Beam.Attachment1 = unit.Weapon.Beams.LEFT
		unit.Weapon.Beams1.RIGHT.BeamR.Attachment1 = unit.Weapon.Beams1.RIGHT
	end)
	
	task.wait(.6)
	
	emit.emitvfx(unit.Torso.jump)

	
	local function ball(endpos, plusend)
		local Projectile = script.UssopBall:Clone() -- vfx
		Projectile.Parent = workspace.Effects
		Projectile.CFrame = rt.CFrame + (rt.CFrame.LookVector * .3) + Vector3.new(0,0.3,0)
		Projectile.Emit.Flare:Emit(1)
		emit.enablevfx(Projectile,true)
		debris.AddItem(Projectile,3)

		Sound(script:FindFirstChild("impc"),Projectile, 2)	


		local PointA = Projectile.CFrame 
		local PointB = Projectile.CFrame + (rt.CFrame.LookVector * (plusend + 3)) + Vector3.new(0,6,0)
		local PointC = endpos

		task.spawn(function()
			for d=0,1,.1 do
				Projectile.CFrame = CFrame.new(Bezier(d,PointA.Position,PointB.Position,PointC.Position))
				wait(0.00000000000000055)
			end			

			emit.enablevfx(Projectile,false)

			local impact = script.Ussopatk1impact:Clone() -- vfx
			impact.Parent = workspace.Effects
			impact.Position = Projectile.Position
			emit.emitvfx(impact)
			debris.AddItem(impact,3)

			rocksmodule.Ground(impact.Position + Vector3.new(0,-1,0),5, Vector3.new(0.45, 0.45, 0.45), nil, 5, false, 1.55)
		end)
	end

	local plus = 0
	
	local plusend = 3

	for i=0,2,1 do

		plus = plus + 3


		plusend = plusend + 1.5

		local endpos = rt.CFrame + (rt.CFrame.LookVector * plus) + Vector3.new(0,-2.3,0)

		task.wait(.035)
	
		task.spawn(function()
			ball(endpos,plusend)
		end)
	end
	



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
