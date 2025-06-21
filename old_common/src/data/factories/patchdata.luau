export type PatchData = {
	BundleUseReset: boolean,
	RaidShopResetUnix: number,
	DungeonShopResetUnix: number,
}

local function createPatchData(): PatchData
	return {
		BundleUseReset = false,
		RaidShopResetUnix = 1735408800,
		DungeonShopResetUnix = 1735408800,
	}
end

return createPatchData
