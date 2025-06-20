export type Team = { [number]: string }
export type Teams = { [string]: Team }

local function createTeams(): Teams
	return {}
end

return createTeams
