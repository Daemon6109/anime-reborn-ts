local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Saiyan Blood",
	PassiveDescription = "After every 2 waves goku powers up and transforms, each transformation increasing his dmg by 5%, his range by 3% and decreasing his spa by -3%.",
} 

Passive.callbacks = {

	onWave = function(self, Unit: Model)

		local Stacks = Unit:GetAttribute("GokuStacks") or 0
		local StacksD = Unit:GetAttribute("GokuStacksD") or 0
		local UnitIndividualID = Unit:GetAttribute("IUUID")
		local LastTransformation = Unit:GetAttribute("LastTransform") or 1

		if Stacks >= 1 then
			Unit:SetAttribute("GokuStacks", 0)
			if LastTransformation < 5 then
				replicated.Events.VisualEffects:FireAllClients("TriggerClientonWave", replicated.Registry.Units["Goku [Evo]"], Unit, LastTransformation, nil, nil)
				Unit:SetAttribute("LastTransform", LastTransformation+1)
				Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.05)
				Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.03)
				Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.03) 
			elseif LastTransformation >= 5 then
				Unit:AddTag("InnateNonTarget")
				Unit:AddTag("InnateNoStun")
			end
		else
			Unit:SetAttribute("GokuStacks", Stacks+1)
		end

	end,

}

return Passive
