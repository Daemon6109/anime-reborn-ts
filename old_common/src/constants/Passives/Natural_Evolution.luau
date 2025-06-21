local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Natural Evolution",
	PassiveDescription = "After eliminating 50 enemies, all future upgrades cost 50% less.",
}

Passive.callbacks = {

	onAnyKill = function(self, Unit: Model, Killer: Model, Enemy: {any}?)

		local Collection = game:GetService("CollectionService")
		local IUUID = Unit:GetAttribute("IUUID")

		local GroundStacks = Unit:GetAttribute("GroundStacks") or 0
		local Applied = Unit:GetAttribute("AppliedBuff") or false

		if Killer == Unit then
			if GroundStacks >= 50 then
				Unit:SetAttribute("GroundStacks", 0)
				if not Applied  then
					Unit:SetAttribute("AppliedBuff", true)
					Unit:SetAttribute("PermanentPriceMulti", Unit:GetAttribute("PermanentPriceMulti")-0.5)
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
