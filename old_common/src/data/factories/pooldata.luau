export type CratePity = {
	ExclusivePity: number?,
	SecretPity: number?,
	MythicalPity: number?,
}

export type CratePool = {
	AutoSell: { [string]: boolean },
	Pity: CratePity?,
}

export type Pools = {
	NewYearCrate: CratePool,
	ValentineCrate: CratePool,
	SpecialCrate: CratePool,
}

export type PoolData = {
	[Pools]: CratePool,
}

local function createPoolData(): PoolData
	return {
		["NewYearCrate"] = {
			AutoSell = {},
			Pity = {
				ExclusivePity = 0,
				SecretPity = 0,
				MythicalPity = 0,
			},
		},
		["ValentineCrate"] = {
			AutoSell = {},
			Pity = {
				SecretPity = 0,
				MythicalPity = 0,
				LegendaryPity = 0,
			},
		},
		["SpecialCrate"] = {
			AutoSell = {},
		},
	}
end

return createPoolData
