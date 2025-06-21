export type NPCData = {
	ClaimedBuilderGems: boolean,
	ClaimedFreeTraitRerolls: boolean,
	ClaimedGroupPrize: boolean,
	ClaimedTutorial: boolean,
}

local function createNPCData(): NPCData
	return {
		ClaimedBuilderGems = false,
		ClaimedFreeTraitRerolls = false,
		ClaimedGroupPrize = false,
		ClaimedTutorial = false,
	}
end

return createNPCData
