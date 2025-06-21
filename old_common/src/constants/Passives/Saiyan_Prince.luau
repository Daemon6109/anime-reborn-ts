local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Saiyan Prince",
	PassiveDescription = "After every 50 eliminations, he powers up and transforms, gaining +6% damage, +5% range, and -4% SPA on each transformation ",
}

Passive.callbacks = {

	onAnyKill = function(self, Unit: Model, Killer: Model, Enemy: {any}?)

		local Collection = game:GetService("CollectionService")
		local IUUID = Unit:GetAttribute("IUUID")

		local GroundStacks = Unit:GetAttribute("GroundStacks") or 0
		local LastTransformation = Unit:GetAttribute("LastTransform") or 1

		if Killer == Unit then
			if GroundStacks >= 50 then
				Unit:SetAttribute("GroundStacks", 0)
				if LastTransformation < 4 then
					replicated.Events.VisualEffects:FireAllClients("TriggerClientonWave", replicated.Registry.Units["Vegeta [Evo]"], Unit, LastTransformation, nil, nil)
					Unit:SetAttribute("LastTransform", LastTransformation+1)
					Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.06)
					Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.05)
					Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.04) 
				else
					Unit:SetAttribute("SecondPassiveUnlocked", true)
				end	
			end
			Unit:SetAttribute("GroundStacks", GroundStacks+1)
		end

	end,

	--onWave = function(self, Unit: Model)

	--	local Collection = game:GetService("CollectionService")
	--	local IUUID = Unit:GetAttribute("IUUID")

	--	local GroundStacks = Unit:GetAttribute("GroundStacks") or 0
	--	local LastTransformation = Unit:GetAttribute("LastTransform") or 1

	--	if LastTransformation < 4 then
	--		replicated.Events.VisualEffects:FireAllClients("TriggerClientonWave", replicated.Registry.Units["Vegeta [Evo]"], Unit, LastTransformation, nil, nil)
	--		Unit:SetAttribute("LastTransform", LastTransformation+1)
	--	else
	--		Unit:SetAttribute("SecondPassiveUnlocked", true)
	--	end	

	--end,
}

return Passive
