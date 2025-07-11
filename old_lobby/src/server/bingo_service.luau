--------------------------------------------------------------------------------
-- bingo_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Analytics = require("@commonserver/analytics")
local Network = require("@network/server")
local Person = require("@commonserver/person")
local Shingo = require("@pkgs/shingo")

local createBingoData = require("@data/factories/bingodata")

-- Bingo constants
local GRID_SIZE = 3
local MAX_ROWS = 9
local REFRESH_INTERVAL = 604800 -- 1 week in seconds

-- Create signals for bingo events
local questProgressUpdatedEvent = Shingo.new() :: Shingo.Signal<Player, string, number>
local squareClaimedEvent = Shingo.new() :: Shingo.Signal<Player, string>
local rowClaimedEvent = Shingo.new() :: Shingo.Signal<Player, string, number>

type BingoQuest = {
	questName: string,
	progress: number,
	claimed: boolean,
}

-- Use the BingoData type from the data factory
type BingoData = createBingoData.BingoData

type QuestConfiguration = {
	displayName: string,
	description: string,
	minProgress: number,
	maxProgress: number,
	category: string,
}

--[=[
	Bingo system for managing daily/weekly quest grids.

	@class BingoService
]=]
local BingoService = {
	version = version,
	-- Events
	questProgressUpdated = questProgressUpdatedEvent,
	squareClaimed = squareClaimedEvent,
	rowClaimed = rowClaimedEvent,
}

--[=[
	Initializes bingo data for a player

	@within BingoService

	@param person Person -- The person to initialize data for

	@return BingoData -- The initialized bingo data

	```lua
	local bingoData = BingoService.initializeBingoData(person)
	```
]=]
function BingoService.initializeBingoData(person: Person.Person): BingoData
	local bingoData: BingoData = {
		NextBingoIn = os.time() + REFRESH_INTERVAL,
		Quests = {},
		Claimed = {},
		TotalClaimedRows = 0,
	}
	-- Generate random quests for the grid
	-- This would use the bingo quest registry in a real implementation
	local availableQuests = {
		"WinGames",
		"SummonUnits",
		"UpgradeUnits",
		"CompleteStages",
		"DefeatBosses",
		"CollectCoins",
		"UseAbilities",
		"LoginDaily",
		"SpendMoney",
	}
	-- Fill 3x3 grid with random quests
	for row = 1, GRID_SIZE do
		for col = 1, GRID_SIZE do
			local questIndex = (row - 1) * GRID_SIZE + col
			local questName = availableQuests[math.random(1, #availableQuests)]
			bingoData.Quests[questIndex] = {
				questName = questName,
				progress = 0,
				claimed = false,
			}
		end
	end
	-- Store the data
	person.dataCache(function(dataCache)
		dataCache.BingoData = bingoData
		return dataCache
	end)
	return bingoData
end

--[=[
	Gets or initializes bingo data for a player

	@within BingoService

	@param person Person -- The person to get data for

	@return BingoData -- The player's bingo data

	```lua
	local bingoData = BingoService.getBingoData(person)
	```
]=]
function BingoService.getBingoData(person: Person.Person): BingoData
	local cache = person.dataCache()
	local bingoData = cache.BingoData
	if not bingoData or not bingoData.NextBingoIn or os.time() > bingoData.NextBingoIn then
		bingoData = BingoService.initializeBingoData(person)
	end
	return bingoData
end

--[=[
	Adds progress to a specific quest

	@within BingoService

	@param person Person -- The person making progress
	@param questName string -- The name of the quest
	@param count number -- The amount of progress to add

	```lua
	BingoService.addProgress(person, "WinGames", 1)
	```
]=]
function BingoService.addProgress(person: Person.Person, questName: string, count: number): ()
	local bingoData = BingoService.getBingoData(person)
	local updated = false
	-- Find and update matching quests
	for questIndex, questData in pairs(bingoData.Quests) do
		if questData.questName == questName and not questData.claimed then
			-- This would use the actual quest configuration from registry
			local maxProgress = 10 -- Mock value
			local newProgress = math.clamp(questData.progress + count, 0, maxProgress)
			if newProgress ~= questData.progress then
				person.dataCache(function(dataCache)
					dataCache.BingoData.Quests[questIndex].progress = newProgress
					return dataCache
				end)
				questProgressUpdatedEvent:fire(person.player, questName, newProgress)
				updated = true
			end
		end
	end
	if updated then
		Network.BingoProgressUpdated.fire(person.player, {
			questName = questName,
			progress = count,
		})
	end
end

--[=[
	Claims a completed bingo square

	@within BingoService

	@param person Person -- The person claiming the square
	@param questIndex number -- The quest index in the grid (1-9)

	@return boolean -- Whether the square was successfully claimed

	```lua
	local claimed = BingoService.claimSquare(person, 5)
	```
]=]
function BingoService.claimSquare(person: Person.Person, questIndex: number): boolean
	local bingoData = BingoService.getBingoData(person)
	local questData = bingoData.Quests[questIndex]
	if not questData or questData.claimed then
		return false
	end
	-- Check if quest is complete (would use registry for max progress)
	local maxProgress = 10 -- Mock value
	if questData.progress < maxProgress then
		return false
	end
	-- Claim the square
	person.dataCache(function(dataCache)
		dataCache.BingoData.Quests[questIndex].claimed = true
		return dataCache
	end)
	-- Track engagement
	Analytics.trackEvent(person.player, "BingoSquareClaimed", {
		questName = questData.questName,
		progress = questData.progress,
	})
	-- Fire events
	squareClaimedEvent:fire(person.player, tostring(questIndex))
	Network.BingoSquareClaimed.fire(person.player, {
		location = tostring(questIndex),
		reward = "SpecialCrate", -- Would come from configuration
	})
	return true
end

--[=[
	Checks if a row is completed and claims it

	@within BingoService

	@param person Person -- The person checking the row
	@param rowType string -- "H" for horizontal, "V" for vertical, "D" for diagonal
	@param rowNumber number -- The row/column number (1-3)

	@return boolean -- Whether the row was successfully claimed

	```lua
	local claimed = BingoService.claimRow(person, "H", 1)
	```
]=]
function BingoService.claimRow(person: Person.Person, rowType: string, rowNumber: number): boolean
	local bingoData = BingoService.getBingoData(person)
	if bingoData.TotalClaimedRows >= MAX_ROWS then
		return false
	end
	local rowId = rowNumber -- Use rowNumber directly as the array index
	if bingoData.Claimed[rowId] then
		return false
	end
	-- Check if row is complete
	local completedSquares = 0
	local requiredIndices = {}
	-- Calculate which quest indices make up this row
	if rowType == "H" then -- Horizontal
		for col = 1, GRID_SIZE do
			table.insert(requiredIndices, (rowNumber - 1) * GRID_SIZE + col)
		end
	elseif rowType == "V" then -- Vertical
		for row = 1, GRID_SIZE do
			table.insert(requiredIndices, (row - 1) * GRID_SIZE + rowNumber)
		end
	elseif rowType == "D" then -- Diagonal
		if rowNumber == 1 then -- Top-left to bottom-right
			for i = 1, GRID_SIZE do
				table.insert(requiredIndices, (i - 1) * GRID_SIZE + i)
			end
		else -- Top-right to bottom-left
			for i = 1, GRID_SIZE do
				table.insert(requiredIndices, (i - 1) * GRID_SIZE + (GRID_SIZE - i + 1))
			end
		end
	else
		return false -- Invalid row type
	end
	-- Check if all squares in the row are claimed
	for _, questIndex in ipairs(requiredIndices) do
		local questData = bingoData.Quests[questIndex]
		if questData and questData.claimed then
			completedSquares += 1
		end
	end
	if completedSquares < #requiredIndices then
		return false
	end
	-- Claim the row
	person.dataCache(function(dataCache)
		dataCache.BingoData.Claimed[rowId] = true
		dataCache.BingoData.TotalClaimedRows += 1
		return dataCache
	end)
	-- Track engagement
	Analytics.trackEvent(person.player, "BingoRowClaimed", {
		rowType = rowType,
		rowNumber = rowNumber,
		rewardTier = bingoData.TotalClaimedRows + 1,
	})
	-- Fire events
	rowClaimedEvent:fire(person.player, rowType, rowNumber)
	Network.BingoRowClaimed.fire(person.player, {
		rowType = rowType,
		rowNumber = rowNumber,
		rewardTier = bingoData.TotalClaimedRows + 1,
	})
	return true
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   BingoService.start()
   ```
]=]
function BingoService.start()
	Network.ClaimBingoSquare.on(function(player, data)
		local person = Person.getForPlayer(player):Unwrap()
		if person then
			BingoService.claimSquare(person, tonumber(data.location) or 1)
		end
	end)
	Network.ClaimBingoRow.on(function(player, data)
		local person = Person.getForPlayer(player):Unwrap()
		if person then
			BingoService.claimRow(person, data.rowType, data.rowNumber)
		end
	end)
end

return BingoService
