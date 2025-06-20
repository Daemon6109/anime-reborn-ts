--------------------------------------------------------------------------------
-- leaderboards
--------------------------------------------------------------------------------

local MockDataStoreService = require("@pkgs/mockdatastoreservice")

local USER_ICON_TEMPLATE = "rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"
local ROBUX_TEMPLATE = utf8.char(0xE002) .. " %s"

local CONSTANTS = require("./data_constants")

local formatLargeNumber = require("@commonutils/formatLargeNumber")
local retryAsync = require("@commonutils/retryAsync")

local Players = game:GetService("Players")

local userIdUsernameCache: { string } = {}

--[=[
    Return the username associated with a userId, caching the results
    Returns <unknownXXXXXXXX> if GetNameFromUserIdAsync fails, which can happen when the specified user is banned
]=]
local function getUsernameFromUserIdAsync(userId: number): string
	if userIdUsernameCache[userId] then
		return userIdUsernameCache[userId]
	else
		local success, result = pcall(function()
			return Players:GetNameFromUserIdAsync(userId)
		end)
		if success then
			userIdUsernameCache[userId] = result
			return result
		else
			return string.format("<unknown%d>", userId)
		end
	end
end

-- Update a display frame with the specified userId and robuxAmount
local function updateDisplayFrameInfoAsync(displayFrame: any, userId: number?, robuxAmount: number?): ()
	if userId and robuxAmount then
		local displayUsername = getUsernameFromUserIdAsync(userId)
		local displayRobuxAmount = string.format(ROBUX_TEMPLATE, formatLargeNumber(robuxAmount))
		local displayIcon = string.format(USER_ICON_TEMPLATE, userId)

		displayFrame.UserDisplay.NameLabel.Text = displayUsername
		displayFrame.UserDisplay.IconLabel.Image = displayIcon
		displayFrame.RobuxLabel.Text = displayRobuxAmount

		displayFrame.Visible = true
	else
		displayFrame.Visible = false
	end
end

-- Create necessary display frames to be used on the leaderboard
local function createDisplayFrames(): ()
	for i = 1, CONSTANTS.DISPLAY_COUNT do
		local isEven = i % 2 == 0
		local displayFrame = instances.DisplayFrame:Clone()
		displayFrame.BackgroundTransparency = if isEven then 0.9 else 1
		displayFrame.LayoutOrder = i
		displayFrame.UserDisplay.RankLabel.Text = tostring(i)
		displayFrame.Visible = false
		displayFrame.Parent = leaderboard.Display.LeaderboardGui.DonorList :: any

		displayFrames[i] = displayFrame
	end
end

-- Retreive the top <DISPLAY_COUNT> donors and display their information on the leaderboard
local function refreshLeaderboardAsync(): ()
	local success, result = retryAsync(
		function()
			-- DataStorePages support up to 100 items per page, so page size must be clamped in the case of DISPLAY_COUNT > 100
			local data = DATA_STORE:GetSortedAsync(false, math.min(CONSTANTS.DISPLAY_COUNT, 100))
			return data
		end,
		CONSTANTS.UPDATE_MAX_ATTEMPTS,
		CONSTANTS.UPDATE_RETRY_PAUSE_CONSTANT,
		CONSTANTS.UPDATE_RETRY_PAUSE_EXPONENT_BASE
	)

	if not success then
		warn(string.format("Failed to retrieve leaderboard data because: %s", result))
		return
	end

	local pages = result :: DataStorePages
	local topDonors = {}

	-- Pull items from the pages object until we have enough to satisfy DISPLAY_COUNT or run out of pages
	repeat
		local currentPage = pages:GetCurrentPage()
		for _, data in currentPage do
			table.insert(topDonors, data)
		end
		if pages.IsFinished then
			break
		else
			pages:AdvanceToNextPageAsync()
		end
	until #topDonors >= CONSTANTS.DISPLAY_COUNT

	for i = 1, CONSTANTS.DISPLAY_COUNT do
		local donorData = topDonors[i]
		local displayFrame = displayFrames[i]

		if donorData then
			local userId = donorData.key
			local robuxAmount = donorData.value
			updateDisplayFrameInfoAsync(displayFrame, userId, robuxAmount)
		else
			updateDisplayFrameInfoAsync(displayFrame, nil, nil)
		end
	end
end
