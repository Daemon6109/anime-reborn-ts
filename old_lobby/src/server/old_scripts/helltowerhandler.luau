local module = {}

local Maid = require(game.ReplicatedStorage.Maid).new()
local RewardLibrary = require(game.ReplicatedStorage.Libs.RewardLibrary)

local AnalyticsService = game:GetService("AnalyticsService")
local HTTP = game:GetService("HttpService")

local Events = game.ReplicatedStorage.Events
local TeleportingToggle_RE = game.ReplicatedStorage.Events.TeleportingToggle
local NotifyPlayer = game.ReplicatedStorage.Events.NotifyPlayer
local GameVariables = game.ReplicatedStorage.GameVariables

local Registry = _G.Registry.registry
local MapOrder = Registry.MapOrder
local MapRegistry = Registry.Maps
local MilestoneRegistry = require(game.ReplicatedStorage.Registry.HellTowerData)

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local function trackEngagement(player, featureName)
	AnalyticsService:LogCustomEvent(player, "Engagement_" .. featureName)
end

local function GiveRewards(Player)
	local HostClass = DataAPI:GetActivePlayerProfileClass(Player)
	local TowerData = HostClass:GetField("HellTowerData")
	local CurrentSeason = MilestoneRegistry.Season
	local OldSeason = TowerData.Season

	if CurrentSeason ~= OldSeason then
		TowerData = {
			HighestRoom = 0,
			Season = CurrentSeason,
			RoomCompletionData = {
				["1"] = {
					["ClearAmount"] = 0,
					["FastestTime"] = 0,
				},
			},
			ClaimData = {},
		}

		HostClass:WriteField("HellTowerData", TowerData)
	else
		local RewardsToGive = {}

		for floor, milestoneData in MilestoneRegistry.MilestoneRewards do
			if not TowerData.ClaimData[tostring(floor)] and TowerData.HighestRoom >= floor then
				TowerData.ClaimData[tostring(floor)] = true

				table.insert(RewardsToGive, milestoneData.Rewards)
			end
		end

		local floor = TowerData.HighestRoom

		if floor >= 100 then
			local amount = math.floor((floor - 100) / 10)

			for i = 1, amount do
				local newFloor = 100 + (10 * i)

				if not TowerData.ClaimData[tostring(newFloor)] and TowerData.HighestRoom >= newFloor then
					TowerData.ClaimData[tostring(newFloor)] = true

					table.insert(RewardsToGive, {
						Currencies = {},

						Items = {
							["TraitCrystal"] = 10,
							["GoldenMarble"] = 1,
						},

						Units = {},
					})
				end
			end
		end

		HostClass:WriteField("HellTowerData", TowerData)

		for i, v in RewardsToGive do
			RewardLibrary:RewardPlayer(Player, v)
		end
	end
end

function module:start()
	Events.HellTower.OnServerEvent:Connect(function(Player, Floor, Difficulty)
		if
			not Difficulty
			or typeof(Difficulty) ~= "string"
			or (Difficulty ~= "Normal" and Difficulty ~= "Nightmare")
		then
			warn("Wrong diffuclity?")
			return
		end

		local HostClass = DataAPI:GetActivePlayerProfileClass(Player)
		local TowerData = HostClass:GetField("HellTowerData")

		if Floor > TowerData.HighestRoom + 1 then
			return
		end

		local FloorData = MilestoneRegistry:GenerateFloor(Floor)

		if not FloorData then
			warn("Error generating floor data.")
			return
		end

		local GameType, MapName, GameScenarioID = "Tower", FloorData.Map, FloorData.Act
		local PlaceId = (game.GameId == 6717025335 and 127759625243990)
			or (game.GameId == 5844593548 and 87213590469285) --  _G.Registry.registry.Maps[MapName].PlaceId
		local PlayerList = { Player }

		TeleportingToggle_RE:FireClient(Player, true, {
			GameType = GameType,
			MapName = MapName,
			GameScenarioID = GameScenarioID,
			Difficulty = Difficulty,
		})

		local TeleportOptions = Instance.new("TeleportOptions")
		TeleportOptions.ShouldReserveServer = true
		TeleportOptions:SetTeleportData({
			MapName = MapName,
			Difficulty = Difficulty,
			GameType = GameType, -- "Story", "Infinity", "Challenge"
			GameScenarioId = GameScenarioID, -- story chapter if story, some challenge name if challenge when we add it later
			Host = Player.UserId,
			TowerFloor = Floor,
			ForcedElements = FloorData.Elements,
		})
		local Success, TeleportResult = pcall(function()
			return game["Teleport Service"]:TeleportAsync(PlaceId, PlayerList, TeleportOptions)
		end)

		if not Success then
			for _, Player in PlayerList do
				TeleportingToggle_RE:FireClient(Player, false, {
					GameType = GameType,
					MapName = MapName,
					GameScenarioID = GameScenarioID,
					Difficulty = Difficulty,
				})

				NotifyPlayer:FireClient(Player, {
					color = "Error",
					text = "Error occurred when teleporting",
				})
			end

			print(TeleportResult)

			return
		end

		local Engagement = `{GameType}:{MapName}:{Difficulty}`

		trackEngagement(Player, Engagement)
	end)

	Events.HellTowerClaimRewards.OnServerEvent:Connect(function(Player)
		GiveRewards(Player)
	end)
end

function module:playerLoaded(player)
	GiveRewards(player)
end

return module
