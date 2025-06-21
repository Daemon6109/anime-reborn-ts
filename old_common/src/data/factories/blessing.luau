export type Blessing = {
	["Name"]: string,
	["UUID"]: string,
}

local function createBlessing(): Blessing
	return {
		["Name"] = "",
		["UUID"] = "",
	}
end

return createBlessing
