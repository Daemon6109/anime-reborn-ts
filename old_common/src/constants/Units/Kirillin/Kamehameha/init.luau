local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = .2, -- seconds
	HitCount = 4, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .15, -- delay between hits in a multi-hit move
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


function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)

	local newanim = AnimModule.PlayAnim(script.KameAn, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["Charge"], rt, Replicated.SoundGroups.UnitSFX)

	local Enemy = pos

	local o = rt.CFrame

	local hum = humanoid


	wait(.2)
	AnimModule.ChangeAnimSpeed(newanim,.1)

	local dur = .5

	tween_service:Create(unit.Kame,TweenInfo.new(.25),{Size = Vector3.new(.7,.7,.7)}):Play()
	tween_service:Create(unit.Kame.PointLight,TweenInfo.new(.25),{Brightness = 1;Range = 8}):Play()

	unit.Kame.B.Shards2:Emit(4)		
	unit.Kame.B.Specs:Emit(4)

	for i,v in pairs(unit.Kame:GetChildren()) do
		if v:IsA('ParticleEmitter') then
			v:Emit(1)
		elseif v:IsA('Attachment') then
			for i,v2 in pairs(v:GetChildren()) do
				v2:Emit(1)
			end

		end
	end

	task.spawn(function()
		emit.enablevfx(unit.Kame,true)
		task.wait(.6)
		emit.enablevfx(unit.Kame,false)
	end)

	delay(dur,function()
		tween_service:Create(unit.Kame,TweenInfo.new(.15),{Size = Vector3.new(0,0,0)}):Play()
		tween_service:Create(unit.Kame.PointLight,TweenInfo.new(.15),{Brightness = 0;Range = 0}):Play()
	end)

	wait(.35)
	AnimModule.ChangeAnimSpeed(newanim,1)
	wait(.15)

	SoundWrapper:PlaySound(script["KameE"], rt, Replicated.SoundGroups.UnitSFX)

	local model = script.Kame:Clone()
	model.CFrame = rt.CFrame * CFrame.new(0,.15,-12.5) * CFrame.Angles(math.rad(-90),0,0)
	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	local dur_kame = .75

	delay(dur,function()
		model.Burst.Aura.Enabled = false
		model.Burst.Aura_.Enabled = false
	end)

	
	task.spawn(function()
		emit.enablevfx(model,true)
		task.wait(dur_kame)
		emit.enablevfx(model,false)
	end)
	
	tween_service:Create(model.Origin.PointLight,TweenInfo.new(.35),{Brightness = 3;Range = 12}):Play()
	delay(dur_kame,function()
		tween_service:Create(model.Origin.PointLight,TweenInfo.new(.5),{Brightness = 0;Range = 0}):Play()
	end)

end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
