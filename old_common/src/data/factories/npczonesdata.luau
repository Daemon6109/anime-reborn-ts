export type NPCZonesData = {
	AlchemyZone: boolean,
	CraftingZone: boolean,
	GoodBuilder: boolean,
	SoloWooZone: boolean,
	GroupZone: boolean,
	SecretPresent: boolean,
	LevelRewards: boolean,
	MerchantZone: boolean,
	SummonZone: boolean,
	TraitRerollZone: boolean,
	UnitIndexZone: boolean,
}

local function createNPCZonesData(): NPCZonesData
	return {
		AlchemyZone = true,
		CraftingZone = true,
		GoodBuilder = true,
		SoloWooZone = true,
		GroupZone = true,
		SecretPresent = true,
		LevelRewards = true,
		MerchantZone = true,
		SummonZone = true,
		TraitRerollZone = true,
		UnitIndexZone = false,
	}
end

return createNPCZonesData
