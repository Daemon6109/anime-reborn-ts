--// By @ThatOneTusk

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScripts = game:GetService("ServerScriptService")

local LeaderboardSeasons = _G.Registry.registry.LeaderboardSeasons
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local LeaderboardData = require(ReplicatedStorage.Registry.LeaderboardData)

local DataAPI = DataAccess:GetAPI()
local LeaderboardInfo = LeaderboardData.Info

local LeaderboardFolder = workspace.Map.Leaderboards
local PlayerModelStorage = workspace.Map.Leaderboards.PlayerModelStorage
local UILeaderboards = ReplicatedStorage.UILeaderboards
local AnimationFolder = ReplicatedStorage.Animations.Generic
local RequestRank = ReplicatedStorage.Events.GetLeaderboardRank

local DisplayTemplate = script.DisplayTemplate
local RigTemplate = script.RigTemplate

local CurrentRanking

local PlayerModelData =
	{ -- Index is the rank to display the model for. Automatically creates model displays for these positions
		[1] = {
			CFrame = CFrame.new(1214.942, -205.794, 55.91) * CFrame.Angles(0, math.rad(65), 0),
			Animation = AnimationFolder.FirstPlaceIdle,
		},

		[2] = {
			CFrame = CFrame.new(1214.942, -205.794, 55.91) * CFrame.Angles(0, math.rad(65), 0),
			Animation = AnimationFolder.SecondPlaceIdle,
		},

		[3] = {
			CFrame = CFrame.new(1214.942, -205.794, 55.91) * CFrame.Angles(0, math.rad(65), 0),
			Animation = AnimationFolder.ThirdPlaceIdle,
		},
	}

local LeaderboardsHandler = {}
local RequestRankCache = {} -- Cleared when UpdateLeaderboards is run
local NameCache = {} -- Cleared after 5 times of UpdateLeaderboards

local LeaderboardLength = 0

for _, _ in LeaderboardInfo do
	LeaderboardLength += 1
end

local LEADERBOARD_UPDATE_COOLDOWN = 15 * 60
local PLAYER_STATUES_UPDATE_COOLDOWN = (
	LEADERBOARD_UPDATE_COOLDOWN / (LeaderboardLength ~= 0 and LeaderboardLength or 1)
)
local MAX_PLAYERS = 100 -- Amount of players to display and give prizes to

local JustUpdatedModels

--//
local _abbreviations = { "K", "M", "B", "T", "Qa", "Qi" }

local pows = {}
for i = 1, #_abbreviations do
	table.insert(pows, 1000 ^ i)
end

--//
local function FormatNumber(number: number): string
	number = math.abs(number)

	if number < 1000 then
		return tostring(number)
	end

	local power = math.min(math.floor(math.log10(number) / 3), #_abbreviations)

	return (math.floor(number / pows[power] * 100) / 100) * math.sign(number) .. _abbreviations[power]
end

--// Runs RunOnUpdate even if it fails, replacing the name with "Loading", runs again once the name is obtained
local function GetPlayerNameFromUserId(UserId, RunOnUpdate: (PlayerName: string?) -> ()?)
	local function TryRunUpdate(PlayerName)
		if RunOnUpdate then
			local Ran, _er = pcall(RunOnUpdate, PlayerName)

			if not Ran then
				warn(`Failed to run RunOnUpdate for player {PlayerName}. Error: {_er}, traceback: {debug.traceback()}`)
			end
		end
	end

	if NameCache[UserId] then
		TryRunUpdate(NameCache[UserId])

		return
	end

	local RetryDelay = 2
	local RanOnce

	for i = 1, 3 do
		RetryDelay *= 2

		local Sucess, GotName = pcall(function()
			return PlayerService:GetNameFromUserIdAsync(UserId)
		end)

		if not RanOnce and not Sucess then
			RanOnce = true
			TryRunUpdate("Loading...")
		end

		if Sucess then
			TryRunUpdate(GotName)
			NameCache[UserId] = GotName
			return GotName
		end

		task.wait(RetryDelay)
	end
end

--// Updates all leaderboards
local UpdatedTimes = 0

function LeaderboardsHandler:UpdateLeaderboards()
	UpdatedTimes += 1

	for LeaderboardName, Data in LeaderboardInfo do
		if Data.Removed then
			continue
		end

		if
			not LeaderboardFolder:FindFirstChild(LeaderboardName) and not UILeaderboards:FindFirstChild(LeaderboardName)
		then
			--warn(`No list for {LeaderboardName}`)
			continue
		end

		local List = LeaderboardFolder:FindFirstChild(LeaderboardName)
			and LeaderboardFolder:FindFirstChild(LeaderboardName).SurfaceGui.List
		local UILeaderboard = UILeaderboards:FindFirstChild(LeaderboardName)
		local Datastore = LeaderboardData:GetDatastoreForLeaderboard(LeaderboardName)

		task.spawn(function()
			local DataPages = Datastore:GetSortedAsync(Data.Ascending, MAX_PLAYERS)
			local CurrentPage = DataPages:GetCurrentPage()

			if LeaderboardName == "Burned York" then
				print(CurrentPage, Datastore)
			end

			for Rank, PlayerData in CurrentPage do
				local UserId = PlayerData.key
				local Value = PlayerData.value

				UserId = tonumber(UserId)

				if UserId <= 0 then
					continue
				end

				local NewDisplay
				local NewObject
				local Stat = Data.CustomStatFormat and Data.CustomStatFormat(Value) or FormatNumber(Value)

				if List then
					NewDisplay = List:FindFirstChild(Rank) or DisplayTemplate:Clone()
					NewDisplay.LayoutOrder = Rank
					NewDisplay.Name = Rank
					NewDisplay.Rank.Text = `#{Rank}`
					NewDisplay.Stat.Text = Stat
				end

				if UILeaderboard then
					NewObject = UILeaderboard:FindFirstChild(Rank) or Instance.new("StringValue")
					NewObject.Name = Rank
					NewObject:SetAttribute("UserId", UserId)
					NewObject:SetAttribute("Stat", Stat)
				end

				GetPlayerNameFromUserId(UserId, function(PlayerName)
					if NewDisplay then
						NewDisplay.PlayerName.Text = PlayerName
					end

					if NewObject then
						NewObject.Value = PlayerName
					end
				end)

				if NewDisplay then
					NewDisplay.Parent = List
				end

				if NewObject then
					NewObject.Parent = UILeaderboard
				end
			end
		end)
	end

	if CurrentRanking and not JustUpdatedModels then
		LeaderboardsHandler:UpdatePlayerStatues(CurrentRanking)
	end

	table.clear(RequestRankCache)

	if UpdatedTimes >= 5 then
		UpdatedTimes = 0
		table.clear(NameCache)
	end
end

--// Updates player model displays
function LeaderboardsHandler:UpdatePlayerStatues(LeaderboardName: string)
	repeat
		task.wait()
		for _, model in PlayerModelStorage:GetChildren() do
			model:Destroy()
		end
	until #PlayerModelStorage:GetChildren() == 0

	JustUpdatedModels = true

	local Data = LeaderboardInfo[LeaderboardName]
	local Datastore = LeaderboardData:GetDatastoreForLeaderboard(LeaderboardName)

	CurrentRanking = LeaderboardName
	LeaderboardFolder.CurrentRanking.SurfaceGui.Header.Text = Data.RankingName

	task.spawn(function()
		local Updated, _Er = pcall(function()
			local DataPages, CurrentPage

			pcall(function()
				DataPages = Datastore:GetSortedAsync(Data.Ascending, #PlayerModelData)
				CurrentPage = DataPages:GetCurrentPage()
			end)

			if DataPages and CurrentPage then
				for Rank, PlayerData in CurrentPage do
					local UserId = PlayerData.key
					local Value = PlayerData.value

					UserId = tonumber(UserId)

					if UserId <= 0 then
						continue
					end

					local NewModel = RigTemplate:Clone()
					local ModelData = PlayerModelData[Rank]

					GetPlayerNameFromUserId(UserId, function(PlayerName)
						NewModel.NameDisplay.Label.Text = `#{Rank} {PlayerName}`
						NewModel.Name = PlayerName
					end)

					NewModel:PivotTo(ModelData.CFrame)
					NewModel.Parent = PlayerModelStorage

					NewModel:WaitForChild("Humanoid")
						:ApplyDescription(PlayerService:GetHumanoidDescriptionFromUserId(UserId))

					if ModelData.Animation then
						local AnimModule = require(game.ReplicatedStorage:WaitForChild("AnimModule"))
						NewModel.Humanoid.Animator:LoadAnimation(AnimModule.GetAnim(ModelData.Animation)):Play()
					end
				end
			end
		end)

		if not Updated then
			warn(`Updating models failed: {_Er}`)
		end

		JustUpdatedModels = false
	end)
end

--// Gets the player rank in the given datastore, only if they're within the top 100!
function LeaderboardsHandler:GetPlayerRank(
	player: Player,
	Datastore: OrderedDataStore,
	LeaderboardName: string,
	Requested: boolean
): number | string?
	local Data = LeaderboardInfo[LeaderboardName]
	local RetryDelay = 1

	for i = 1, 3 do
		RetryDelay *= 2

		local Obtained, Rank = pcall(function()
			local DataPages = Datastore:GetSortedAsync(Data.Ascending, MAX_PLAYERS)
			local CurrentPage = DataPages:GetCurrentPage()

			for Rank2, PlayerData in CurrentPage do
				local UserId = PlayerData.key

				UserId = tonumber(UserId)

				if UserId == player.UserId then
					return Requested and { Rank = Rank2, Value = PlayerData.value } or Rank2
				end
			end
		end)

		if Obtained then
			return Rank or "<100" --// We don't really need to know the player's actual rank, just their rank if they are within the top 100
		end

		task.wait(RetryDelay)
	end
end

--//
function LeaderboardsHandler:start()
	local LeaderboardCooldown = 0
	local IsUpdatingStatues = false

	LeaderboardsHandler:UpdateLeaderboards()

	RequestRank.OnServerInvoke = function(player, leaderboard)
		if not LeaderboardInfo[leaderboard] then
			return
		end

		local Datastore = LeaderboardData:GetDatastoreForLeaderboard(leaderboard)
		local CachedLeaderboard = RequestRankCache[leaderboard]

		if not CachedLeaderboard then
			RequestRankCache[leaderboard] = {}
			CachedLeaderboard = RequestRankCache[leaderboard]
		end

		if CachedLeaderboard[player.UserId] then
			return CachedLeaderboard[player.UserId]
		end

		CachedLeaderboard[player.UserId] = "Loading"
		CachedLeaderboard[player.UserId] = LeaderboardsHandler:GetPlayerRank(player, Datastore, leaderboard, true)
			or "Loading"

		return CachedLeaderboard[player.UserId]
	end

	RunService.Heartbeat:Connect(function(dt)
		LeaderboardCooldown += dt

		if LeaderboardCooldown > LEADERBOARD_UPDATE_COOLDOWN then
			LeaderboardCooldown = 0

			for _, player in PlayerService:GetPlayers() do
				DataAPI:SaveLeaderboardData(player)
			end

			LeaderboardsHandler:UpdateLeaderboards()
		end

		if not IsUpdatingStatues then
			IsUpdatingStatues = true

			for LeaderboardName, _data in LeaderboardInfo do
				while JustUpdatedModels do
					task.wait(2)
				end

				if not _data.Removed then
					LeaderboardsHandler:UpdatePlayerStatues(LeaderboardName)
					task.wait(PLAYER_STATUES_UPDATE_COOLDOWN)
				end
			end

			IsUpdatingStatues = false
		end
	end)
end

--//
function LeaderboardsHandler:playerLoaded(player: Player)
	local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
	local PlayerLeaderboardData = PlayerProfile:GetField("LeaderboardData")

	--//
	if PlayerLeaderboardData.LastSeasonUpdate ~= LeaderboardData.CurrentSeason then
		for i, info in LeaderboardInfo do
			if info.IsSeasonal and info.OnSeasonChanged then
				local run, _e = pcall(info.OnSeasonChanged, player, PlayerProfile)

				if not run then
					warn(`Failed to update leaderboard data for {i}, plr: {player}. {_e}`)
				end
			end
		end

		PlayerProfile:WriteDirectory("LeaderboardData/LastSeasonUpdate", LeaderboardData.CurrentSeason)
	end

	--// Update their prizes
	for _, Season in ReplicatedStorage.Registry.LeaderboardSeasons:GetChildren() do
		if not Season:IsA("ModuleScript") or Season.Name == "Default" then
			continue
		end

		local Name = Season.Name

		local Data = LeaderboardSeasons.Default
		if LeaderboardSeasons[tostring(Name)] then
			Data = LeaderboardSeasons[tostring(Name)]
		end

		if tonumber(Name) >= LeaderboardData.CurrentSeason then
			continue
		end

		for LeaderboardName, Info in LeaderboardInfo do
			local IsChecked = PlayerProfile:GetField("LeaderboardData").CheckedSeasons[Name] or {} --// Just incase the variable isn't updated

			if
				not Info.IsSeasonal
				or Info.NoSeasonRewards
				or IsChecked[LeaderboardName]
				or (Info.IgnoreSeasons and table.find(Info.IgnoreSeasons, tonumber(Name)))
			then
				continue
			end

			local Datastore = LeaderboardData:GetDatastoreForLeaderboard(LeaderboardName, tonumber(Name))
			local PlayerRank = LeaderboardsHandler:GetPlayerRank(player, Datastore, LeaderboardName, false)

			if PlayerRank then
				IsChecked = PlayerProfile:GetField("LeaderboardData").CheckedSeasons[Name] or {} --// Just incase the variable isn't updated
				IsChecked[LeaderboardName] = true

				PlayerProfile:WriteDirectory(`LeaderboardData/CheckedSeasons/{Name}`, IsChecked)

				if type(PlayerRank) == "number" and PlayerRank <= MAX_PLAYERS then --// Proofing just incase
					local NewUUID = HttpService:GenerateGUID(false)
					local PlayerPrizes = PlayerProfile:GetField("LeaderboardData").PendingRewards

					if PlayerPrizes[NewUUID] then --// Imagine
						repeat
							task.wait()
							NewUUID = HttpService:GenerateGUID(false)
						until not PlayerPrizes[NewUUID]
					end

					PlayerPrizes[NewUUID] = {
						Rank = PlayerRank,
						LeaderboardName = LeaderboardName,
						Season = Name,
					}

					PlayerProfile:WriteDirectory("LeaderboardData/PendingRewards", PlayerPrizes)
				end
			end
		end
	end

	PlayerProfile:ReplicateField("LeaderboardData")
end

return LeaderboardsHandler
