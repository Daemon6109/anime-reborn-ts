local module = {}

local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local tween_service = game:GetService("TweenService") 
local Collection = game:GetService("CollectionService")
local Replicated = game:GetService("ReplicatedStorage")
local AnimModule = require(Replicated.AnimModule)

local emit = require(Replicated.Libs.emit)
local SoundWrapper = require(Replicated.Libs.SoundWrapper)

module.config = {
	HitDelay = 1.1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = 0, -- delay between hits in a multi-hit move
}

function module:Effect(Tab)
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local humanoid = unit:FindFirstChild("Humanoid")
	local startpos = rt.CFrame
	
	rt.CFrame = CFrame.lookAt(rt.Position, pos.Position)
	
	AnimModule.PlayAnim(script.Pistol, unit, 1, "", {Weight = 2, Fade = .15})
	SoundWrapper:PlaySound(script["PistolSFX"], rt, Replicated.SoundGroups.UnitSFX)
	task.wait(.5)
	
	
	local model = script.PistolA:Clone()
	
	model:SetPrimaryPartCFrame(rt.CFrame * CFrame.new(.5,0,-5) * CFrame.Angles(math.rad(90),0,0))

	model.Parent = workspace.Effects
	debris.AddItem(model,5)

	local dash = model
	local dur = .35
	local dl = .15

	emit.emitvfx(dash.Strike)
	emit.emitvfx(dash.Shards)
	emit.emitvfx(dash.Shards_)

	dash.Strike.CFrame *= CFrame.new(0,15,0)
	dash.Shards.CFrame *= CFrame.new(0,15,0)
	dash.Shards_.CFrame *= CFrame.new(0,15,0)
	dash.Hit.CFrame *= CFrame.new(0,15,0)

	tween_service:Create(dash.Hit,TweenInfo.new(.2),{CFrame = dash.Hit.CFrame * CFrame.new(0,-17.5,0) }):Play()
	tween_service:Create(dash.Strike,TweenInfo.new(.2),{CFrame = dash.Strike.CFrame * CFrame.new(0,-20,0) }):Play()
	tween_service:Create(dash.Shards,TweenInfo.new(.2),{CFrame = dash.Shards.CFrame * CFrame.new(0,-20,0) }):Play()
	tween_service:Create(dash.Shards_,TweenInfo.new(.2),{CFrame = dash.Shards_.CFrame * CFrame.new(0,-20,0) }):Play()

	tween_service:Create(dash.Strike.PointLight,TweenInfo.new(.15),{Brightness = 3;Range = 12}):Play()
	delay(dl,function()
		tween_service:Create(dash.Strike.PointLight,TweenInfo.new(.15),{Brightness = 0;Range = 0}):Play()
	end)

	delay(dl,function()

		-- Hit

		dash.Hit.B.Shards2:Emit(4)
		dash.Hit.B.Shard_Burst:Emit(4)
		dash.Hit.B.Burst2_:Emit(1)
		dash.Hit.B.Specs:Emit(4)

		for i,v in pairs(dash.Hit:GetChildren()) do
			if v:IsA('ParticleEmitter') then
				v:Emit(1)
			elseif v:IsA('Attachment') then
				for i,v2 in pairs(v:GetChildren()) do
					v2:Emit(1)
				end
			end
		end

		-- Burst

		dash.Burst.Wind_Explo:Emit(1)
		dash.Burst.Fire:Emit(2)

		for i,v in pairs(dash.Burst:GetChildren()) do
			if v:IsA('ParticleEmitter') then
				v:Emit(1)
			elseif v:IsA('Attachment') then
				for i,v2 in pairs(v:GetChildren()) do
					v2:Emit(1)
				end
			end
		end

		emit.enablevfx(dash.Strike,false)
		emit.enablevfx(dash.Shards_,false)
		emit.enablevfx(dash.Shards,false)
		
		emit.emitvfx(dash.Burst)	
	end)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
