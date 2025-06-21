local module = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Collection = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Events = ReplicatedStorage.Events
local IsServer = RunService:IsServer()
local CollectionService = game:GetService("CollectionService")

--_G.UnitSkillModulesCache = {}

--function module:ApplyEffectToModel(ModelToApply:Model)
--	local Effect:Model = self.raw:FindFirstChild("Effect")
	
--	if Effect then
--		for index, Part in pairs(Effect:GetChildren()) do
--			if ModelToApply:FindFirstChild(Part.Name) then
--				for index2, Effect in pairs(Part:GetChildren()) do
--					if Effect:IsA("Attachment") or Effect:IsA("ParticleEmitter") then
--						if Effect:IsA("Attachment") and #Effect:GetChildren() == 0 then continue end
--						local Clone = Effect:Clone()
--						Clone:AddTag(`TraitAura {self.configuration.Name}`)
--						Clone.Parent = ModelToApply:FindFirstChild(Part.Name)
--					end
--				end
--			elseif Part:FindFirstChildOfClass("Weld") or Part:FindFirstChildOfClass("WeldConstraint") or Part:FindFirstChildOfClass("Motor6D") then
--				local Clone = Part:Clone()
--				Clone:AddTag(`TraitAura {self.configuration.Name}`)
--				local Weld = Clone:FindFirstChildOfClass("Weld") or Clone:FindFirstChildOfClass("WeldConstraint") or Clone:FindFirstChildOfClass("Motor6D")
--				local OriginalWeld = Clone:FindFirstChildOfClass("Weld") or Part:FindFirstChildOfClass("WeldConstraint") or Part:FindFirstChildOfClass("Motor6D")
				
--				local Part0 = OriginalWeld.Part0.Name
--				local Part1 = OriginalWeld.Part1.Name
--				Clone.Anchored = true
--				Clone.Parent = ModelToApply

--				Weld.Part0 = ModelToApply:FindFirstChild(Part0)
--				Weld.Part1 = ModelToApply:FindFirstChild(Part1)
--				Clone.Anchored = false
--			end
--		end
		
--		return true --aka effect was applied on the model, it's mostly if you need a check that the trait has an effect at all or if you want to limit how many auras can unit have
--	else
--		return false --aka effect for this trait wasn't found and wasn't applied on the model, it's mostly if you need a check that the trait has an effect at all or if you want to limit how many auras can unit have
--	end
--end

function module:Apply(ModelToApply:Model, Effect)
	print(ModelToApply.Parent.Name)
	for index, Part in pairs(Effect:GetChildren()) do
		if ModelToApply:FindFirstChild(Part.Name) then
			for index2, Effect in pairs(Part:GetChildren()) do
				if Effect:IsA("Attachment") or Effect:IsA("ParticleEmitter") then
					if Effect:IsA("Attachment") and #Effect:GetChildren() == 0 then continue end
					local Clone = Effect:Clone()
					Clone:AddTag(`TraitAura {self.configuration.Name}`)
					Clone.Parent = ModelToApply:FindFirstChild(Part.Name)
				end
			end
		elseif Part:FindFirstChildOfClass("Weld") or Part:FindFirstChildOfClass("WeldConstraint") or Part:FindFirstChildOfClass("Motor6D") then
			local Clone = Part:Clone()
			Clone:AddTag(`TraitAura {self.configuration.Name}`)
			local Weld = Clone:FindFirstChildOfClass("Weld") or Clone:FindFirstChildOfClass("WeldConstraint") or Clone:FindFirstChildOfClass("Motor6D")
			local OriginalWeld = Clone:FindFirstChildOfClass("Weld") or Part:FindFirstChildOfClass("WeldConstraint") or Part:FindFirstChildOfClass("Motor6D")

			local Part0 = OriginalWeld.Part0.Name
			local Part1 = OriginalWeld.Part1.Name
			Clone.Anchored = true
			Clone.Parent = ModelToApply

			Weld.Part0 = ModelToApply:FindFirstChild(Part0)
			Weld.Part1 = ModelToApply:FindFirstChild(Part1)
			Clone.Anchored = false
		end
	end

end

function module:ApplyEffectToModel(ModelToApply:Model)
	local Effect:Model = self.raw:FindFirstChild("Effect")

	if Effect then
		if CollectionService:HasTag(ModelToApply, "DoubleModel") then

			for _,v in ModelToApply:GetChildren() do
				if v:GetAttribute("DoubleModel") then
					self:Apply(v, Effect)
				end
			end
		else
			self:Apply(ModelToApply, Effect)
		end


		return true --aka effect was applied on the model, it's mostly if you need a check that the trait has an effect at all or if you want to limit how many auras can unit have
	else
		return false --aka effect for this trait wasn't found and wasn't applied on the model, it's mostly if you need a check that the trait has an effect at all or if you want to limit how many auras can unit have
	end
end

function module:HasEffect()
	local Effect:Model = self.raw:FindFirstChild("Effect")
	
	if Effect then
		return true
	else
		return false
	end
end


return module
