local module = {}
local debris = require(game.ReplicatedStorage.Libs.DebrisSystemV2)
local Animations = script.Parent.Animations
local Mesh = script.Mesh
local effectsfolder = workspace.Effects

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
	local unit, rt, pos = table.unpack(Tab) -- rt = unit rootpart, pos = enemy rootpart
	
	local EffectPart = Mesh.Part:Clone()
	EffectPart:PivotTo(rt.CFrame)
	EffectPart.Parent = effectsfolder
	
	local Emitter = EffectPart.ParticleEmitter
	
	Emitter:Emit(Emitter:GetAttribute("EmitCount"))
	
	debris.AddItem(EffectPart, 3)
end

-- Calling the method gonna look like VFXModule:Effect({Unit, Unit.HumanoidRootPart.CFrame})
-- You could make it use multiple arguments from the table, just add the needed ones onto 11th line
-- Like local Unit, UnitCFrame, Color, Etc, Etc = table.unpack(Tab)

return module
