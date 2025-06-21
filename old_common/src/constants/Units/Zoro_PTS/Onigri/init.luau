local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .85, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}
local function lerp(p0,p1,t)
	return p0*(1-t) + p1*t
end

local function quad(p0,p1,p2, t)
	local l1 = lerp(p0,p1,t)
	local l2 = lerp(p1,p2,t)
	local quad = lerp(l1,l2,t)
	return quad
end


local function tp(humrp,cf)

	local x = {humrp,cf}

	for i = 1,2 do
		local model = script.Blink:Clone()
		model.CFrame = x[i]
		model.Parent = workspace.Effects
		debris.AddItem(model,5)


		task.spawn(function()
			emit.enablevfx(model,true)
			task.wait(.25)
			emit.enablevfx(model,false)
		end)
	end

end

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	local newanim = AnimModule.PlayAnim(script.Onigirian, unit, 1, "", {Weight = 2, Fade = .15})
	
	local humrp = rt	
	local Enemy = pos
	humrp.CFrame = CFrame.lookAt(humrp.Position,Enemy.Position) 

	local o = humrp.CFrame


	wait(.35)

	SoundWrapper:PlaySound(script["Onigirisfx"], rt, Replicated.SoundGroups.UnitSFX)

	local model = script.Onigiri:Clone()
	model:SetPrimaryPartCFrame(humrp.CFrame * CFrame.new(0,0,-9) * CFrame.Angles(math.rad(90),0,0))
	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	model.Strike.CFrame *= CFrame.new(0,9,0)
	model.Shards.CFrame *= CFrame.new(0,9,0)
	model.Shards_.CFrame *= CFrame.new(0,9,0)
	
	for i,v in pairs(model.Strike:GetChildren()) do
		if v:IsA('ParticleEmitter') then
			v:Emit(5)
		elseif v:IsA('Attachment') then
			for i,v2 in pairs(v:GetChildren()) do
				v2:Emit(5)
			end

		end
	end

	task.spawn(function()
		emit.enablevfx(model.Strike,true)
		emit.enablevfx(model.Shards_,true)
		emit.enablevfx(model.Shards,true)
		task.wait(.35)
		emit.enablevfx(model.Strike,false)
		emit.enablevfx(model.Shards_,false)
		emit.enablevfx(model.Shards,false)
	end)

	tween_service:Create(model.Strike,TweenInfo.new(.15),{CFrame = model.Strike.CFrame * CFrame.new(0,-10.5,0)}):Play()
	tween_service:Create(model.Shards,TweenInfo.new(.15),{CFrame = model.Shards.CFrame * CFrame.new(0,-10.5,0)}):Play()
	tween_service:Create(model.Shards_,TweenInfo.new(.15),{CFrame = model.Shards_.CFrame * CFrame.new(0,-11.5,0)}):Play()

	tween_service:Create(model.Strike.PointLight,TweenInfo.new(.25),{Brightness = 3;Range = 8}):Play()
	delay(.35,function()
		tween_service:Create(model.Strike.PointLight,TweenInfo.new(.35),{Brightness = 0;Range = 0}):Play()
	end)

	tp(humrp.CFrame,humrp.CFrame * CFrame.new(0,0,-15))
	delay(.15,function()
		humrp.CFrame = humrp.CFrame * CFrame.new(0,0,-15)
	end)

	delay(.15,function()
		model.Burst.Wind_Explo:Emit(1)
		model.Burst.Fire:Emit(2)

		model.Burst.Dust:Emit(2)

		for i,v in pairs(model.Burst:GetChildren()) do
			if v:IsA('ParticleEmitter') then
				v:Emit(3)
			elseif v:IsA('Attachment') then
				for i,v2 in pairs(v:GetChildren()) do
					v2:Emit(3)
				end

			end
		end

		task.spawn(function()
			emit.enablevfx(model.Burst,true)
			task.wait(.65)
			emit.enablevfx(model.Burst,false)
		end)

		delay(.75,function()
			tp(humrp.CFrame,o)
			wait(.15)
			humrp.CFrame = o
		end)
	end)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
