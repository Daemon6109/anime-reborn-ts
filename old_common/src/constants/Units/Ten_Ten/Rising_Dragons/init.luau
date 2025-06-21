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
	HitDelay = 1, -- seconds
	HitCount = 7, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
}





function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	--local animation = humanoid:LoadAnimation(script.secondattack)
	--animation:Play()

	AnimModule.PlayAnim(script.secondattack, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["2"], rt, Replicated.SoundGroups.UnitSFX)

	wait(.45)
	
	task.spawn(function()
		task.wait(.15)
		unit["Left Arm"].SmokeEmit.Smoke:Emit(11)
		unit["Left Arm"].SmokeEmit.flare:Emit(1)

	end)

	
	wait(.6)

	emit.emitvfx(unit.Torso.jump)

	local info = TweenInfo.new(.8,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(rt,info,{CFrame = rt.CFrame + Vector3.new(0,10,0)})
	tween:Play()

	wait(.1)
	
	
	
	local Air = script.Tentenatk2goup:Clone() 
	Air.Parent = workspace.Effects
	Air.Position = rt.Position
	emit.enablevfx(Air,true)
	local info = TweenInfo.new(.7,Enum.EasingStyle.Quart,Enum.EasingDirection.In)
	local tween = tween_service:Create(Air,info,{Position = rt.Position + Vector3.new(0,10,0)})
	tween:Play()
	debris.AddItem(Air,2.5)


	task.spawn(function()
		task.wait(.14)
		local Wind1 = script.Wind1:Clone()
		Wind1.Parent = workspace.Effects
		Wind1.CFrame = startpos * CFrame.Angles(0,math.rad(-90),-90)
		Wind1.Mesh.Scale = Vector3.new(1,0,0)
		debris.AddItem(Wind1,2.5)

		tween_service:Create(Wind1.Mesh, 
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{
				Scale = Vector3.new(.15,.3,.3),
			}
		):Play()
		tween_service:Create(Wind1, 
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{
				CFrame = Wind1.CFrame * CFrame.Angles(0,0,0)
			}
		):Play()
		tween_service:Create(Wind1.Decal, 
			TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{Transparency = 1}
		):Play()
		
		task.wait(.3)
		Wind1:Destroy()
	
	end)

	wait(.7)
	
	local info = TweenInfo.new(.8,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local tween = tween_service:Create(rt,info,{CFrame = rt.CFrame + Vector3.new(0,1.5,0)})
	tween:Play()
	emit.enablevfx(Air,false)
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	for i=0,7,1  do
		task.wait(0.04)
		task.spawn(function()
			local kunai = script.Kunai:Clone() 
			kunai.Parent = workspace.Effects
			kunai.CFrame = rt.CFrame + (rt.CFrame.LookVector * math.random(-3,3)) + Vector3.new(math.random(-2,2),math.random(-2,2),math.random(2,2))
			emit.emitvfx(kunai)
			debris.AddItem(kunai,2.5)


			kunai.CFrame = kunai.CFrame * CFrame.Angles(math.rad(-111),0,0)
			SoundWrapper:PlaySound(script["KunaiSFx"], kunai, Replicated.SoundGroups.UnitSFX)

			task.wait(.2)
			
			task.wait(.2)
			
			local info = TweenInfo.new(.35,Enum.EasingStyle.Back,Enum.EasingDirection.In)
			local tween = tween_service:Create(kunai,info,{Position = pos.Position + Vector3.new(math.random(-4,4),-1,math.random(-4,4)) })
			tween:Play()
			
			task.wait(.35)	
			
			kunai.Transparency = 1
			local impact = script.KunaiHit:Clone() 
			impact.Parent = workspace.Effects
			impact.Position = kunai.Position
			emit.emitvfx(impact)
			debris.AddItem(impact,2.5)

		

		end)	
	end

	wait(1)
	unit.Torso.tp:Emit(25)
	unit.Torso.Smoke:Emit(13)

	wait(.12)
	rt.CFrame = startpos
	wait(.03)
	unit.Torso.tp:Emit(25)
	unit.Torso.Smoke:Emit(13)


	
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
