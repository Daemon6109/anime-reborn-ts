--------------------------------------------------------------------------------
-- leaderboard
--------------------------------------------------------------------------------

local Leaderboard = {}

local function setupLeaderboard(player: Player): Folder
	local leaderstats = Instance.new("Folder")
	-- 'leaderstats' is a reserved name Roblox recognizes for creating a leaderboard
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	return leaderstats
end

local function setupStat(leaderstats: Folder, statName: string): IntValue
	local stat = Instance.new("IntValue")
	stat.Name = statName
	stat.Value = 0
	stat.Parent = leaderstats
	return stat
end

function Leaderboard.setStat(player: Player, statName: string, value: any): ()
	local leaderstats = player:FindFirstChild("leaderstats") :: Folder?
	if not leaderstats then
		leaderstats = setupLeaderboard(player)
	end
	assert(leaderstats, "Leaderstats folder not found for player")

	local stat = leaderstats:FindFirstChild(statName) :: IntValue?
	if not stat then
		stat = setupStat(leaderstats, statName)
	end
	assert(stat, "Stat not found for player")

	stat.Value = value
end

return Leaderboard
