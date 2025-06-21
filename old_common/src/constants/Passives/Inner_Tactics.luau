local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Inner Tactics",
	PassiveDescription = "After eliminating 20 basic enemies he gains 3% dmg up to 15%, for every 10 air enemies he eliminates his range increases by 2% up to 8%. (2s cd)",
}

Passive.callbacks = {
	
	onAnyKill = function(self, Unit: Model, Killer: Model, Enemy: {any}?)
		
		local Collection = game:GetService("CollectionService")
		local IUUID = Unit:GetAttribute("IUUID")
				
		local GroundStacks = Unit:GetAttribute("GroundStacks") or 0
		local AirStacks = Unit:GetAttribute("AirStacks") or 0
		
		local GroundStacksD = Unit:GetAttribute("GroundStacksD") or 0
		local AirStacksD = Unit:GetAttribute("AirStacksD") or 0
		
		if Killer == Unit then
			local IsClass = Enemy.Class == "Flying" or Enemy.NPC_Type == "Flying" or Enemy.Class == "Air" or Enemy.NPC_Type == "Air"
			if IsClass then
				if AirStacks >= 10 then
					Unit:SetAttribute("AirStacks", 0)
					if AirStacksD < 4 then
						Unit:SetAttribute("PermanentRangeMulti", Unit:GetAttribute("PermanentRangeMulti")+0.02)
						Unit:SetAttribute("AirStacksD", AirStacksD+1)
					end
				else
					Unit:SetAttribute("AirStacks", AirStacks+1)
				end
			else
				if GroundStacks >= 20 then
					Unit:SetAttribute("GroundStacks", 0)
					if GroundStacksD < 5 then
						Unit:SetAttribute("PermanentDamageMulti", Unit:GetAttribute("PermanentDamageMulti")+0.03)
						Unit:SetAttribute("GroundStacksD", GroundStacksD+1)
					end
				else
					Unit:SetAttribute("GroundStacks", GroundStacks+1)
				end
			end
		end
		
	end,
}

return Passive
