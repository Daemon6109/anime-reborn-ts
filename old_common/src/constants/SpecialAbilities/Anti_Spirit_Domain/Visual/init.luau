local module = {}

module.config = {
	HitDelay = 1, -- seconds
	HitCount = 1, -- amout of hits the skill does to split the damage visually on client
	MultihitDelay = .1, -- delay between hits in a multi-hit move
	Speed = 65,
	--CustomDelay = {
	--	[1] = .35,
	--},
	ScaleFactor = 1,
}

function module:Effect(Tab)
	local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
	local SoundWrapper = require(game.ReplicatedStorage.Libs.SoundWrapper)
	local BT = require(game.ReplicatedStorage.Libs.BoatTweenTyped)
	local effectsfolder = workspace.Effects
	
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	local BUffLib = require(game.ReplicatedStorage.Libs.BuffLib)
	local RawRange = 20; RawRange *= 2.5
	
	local EffectModel = script.Radius:Clone()
	EffectModel:PivotTo(rt.CFrame)
	EffectModel.Parent = effectsfolder
	
	SoundWrapper:PlaySound(script.SFX, EffectModel.Sphere, game.ReplicatedStorage.SoundGroups.UnitSFX)
	
	game.TweenService:Create(EffectModel.Sphere, TweenInfo.new(.66, Enum.EasingStyle.Sine), {Size = Vector3.new(RawRange, RawRange, RawRange)/2}):Play()
	
	local Emitter = EffectModel.Sphere.Particles.ring
	local Emitter2 = EffectModel.Sphere.Particles.Smoke3
	Emitter.Size = NumberSequence.new((RawRange/2)/1.60429067919)
	Emitter.Enabled = true
	Emitter2.Enabled = true
	Emitter2:Emit(Emitter2:GetAttribute("EmitCount"))
	Emitter:Emit(Emitter:GetAttribute("EmitCount"))
	
	
	task.delay(10, function()
		game.TweenService:Create(EffectModel.Sphere, TweenInfo.new(.66, Enum.EasingStyle.Sine), {Size = Vector3.new(0,0,0)}):Play()
		
		local Tweens = {}
		
		for i,v in EffectModel.Sphere:GetChildren() do
			if v:IsA("Beam") then
				table.insert(Tweens, BT:Create(v, {
					TweenInfo = TweenInfo.new(.33, Enum.EasingStyle.Sine),
					Goal = {
						Transparency = NumberSequence.new(1)
					}
				}))
			end
		end
		
		for i,v in Tweens do
			v.Play()
		end
		
		Emitter.Enabled = false
		Emitter2.Enabled = false
		task.wait(3)
		EffectModel:Destroy()
		for i,v in Tweens do
			v.Destroy()
		end
		Tweens = nil
		BT = nil
	end)
	
	
	debris.AddItem(EffectModel, 40)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
