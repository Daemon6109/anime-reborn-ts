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
	HitDelay = 2, -- seconds
	Duration = .25,
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

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})

	--SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)


	task.wait(.2)

	local charge = script.KaidoCharge:Clone()  
	charge.Parent = workspace.Effects
	charge.Position = rt.Position + Vector3.new(0,-1,0)
	emit.enablevfx(charge,true)
	charge.Anchored = true

	task.spawn(function()
		for i=0,10,1 do
			emit.bezier(charge.CFrame,ColorSequence.new(Color3.fromRGB(114, 32, 255)),0.00000000005,.5,"Mid",true,5,.5,1.6)
			task.wait(.1)
		end
	end)
	
	task.wait(.2)
	
	local bolt = script.thunderboltKado:Clone()  
	bolt.Parent = workspace.Effects
	bolt.Position = pos.Position + Vector3.new(0,-1,0)	

	local bolta = script.KaidoBolt:Clone()  
	bolta.Parent = workspace.Effects
	bolta.Position = pos.Position + Vector3.new(0,-1,0)		
	bolt.Anchored = true

	bolta.Anchored = true
	
	task.wait(0.8)
	emit.enablevfx(charge,false)

	
	task.wait(.2)
	
	
	for i=0,5,1 do

		local grapos =  pos.Position + Vector3.new(math.random(-7,7),-1.45,math.random(-7,7))

		bolt.Position = grapos
		bolta.Position = grapos

		emit.emitvfx(bolt)
		emit.emitvfx(bolta)

		rocksmodule.Ground(pos.Position + Vector3.new(0,3.5,0),10, Vector3.new(1.25, 1.25, 1.25), nil, 8, false, .64) -- ground crack module
		task.wait(.15)
	end




	task.wait(1)


	debris.AddItem(bolt,1)
	debris.AddItem(charge,1)
	debris.AddItem(bolta,1)



end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
