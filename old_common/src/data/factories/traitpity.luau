export type TraitPity = {
	["Mythical"]: number,
	["Secret"]: number,
}

local function createTraitPity(): TraitPity
	return {
		["Mythical"] = 0,
		["Secret"] = 0,
	}
end

return createTraitPity
