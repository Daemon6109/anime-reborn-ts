local replicated = game:GetService("ReplicatedStorage")
local Enums = require(replicated.Libs.Enums)
local Passive = setmetatable({}, {__index = require(replicated.Registry.PassiveBaseMethods)}) :: Enums.PassiveStructure

Passive.configuration = {
	PassiveName = "Wild Momentum I",
	PassiveDescription = "Each time she eliminates a speedster enemy her spa decreases by -1% up to -8%.",
}

Passive.callbacks = {

	onAnyKill = function(self, Unit: Model, Killer: Model, Enemy: {any}?)

		local Collection = game:GetService("CollectionService")
		local IUUID = Unit:GetAttribute("IUUID")

		local GroundStacks = Unit:GetAttribute("GroundStacks") or 0

		if Killer == Unit then
			if Enemy then
				local IsClass = Enemy.Class == "Speedster" or Enemy.NPC_Type == "Speedster"
				if IsClass then
					if GroundStacks < 8 then
						Unit:SetAttribute("GroundStacks", GroundStacks+1)
						Unit:SetAttribute("PermanentAttackSpeedMulti", Unit:GetAttribute("PermanentAttackSpeedMulti")-.01) 
					end
				end
			end
		end

	end,
}

return Passive
