local module = {}
local http = game:GetService("HttpService")
local replicated = game.ReplicatedStorage
local events = replicated.Events
local mapRegistry = _G.Registry.registry.Maps
local playerActions = {
	Teleport = events.PlayerAction_Teleport,
}

local tpService = game:GetService("TeleportService")

local DEBUG = true

local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

function module:Teleport(plr, data)
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(plr)
	local GameType, MapName, GameScenarioID, difficulty =
		data.GameType, data.MapName, data.GameScenarioID, data.Difficulty

	local missions = PlayerProfileClass:GetField("MissionCompletionData")
	if plr:GetAttribute("Teleporting") then
		return
	end

	if
		missions[GameType]
			and missions[GameType][MapName]
			and (GameScenarioID == 1 or missions[GameType][MapName][GameScenarioID - 1])
		or DEBUG
	then
		local placeID = (game.GameId == 6717025335 and 127759625243990)
			or (game.GameId == 5844593548 and 87213590469285) -- mapRegistry[MapName].PlaceId

		local succ, server, serverid = pcall(function()
			return tpService:ReserveServer(placeID)
		end)

		--local succ, err = pcall(function()
		--	hashMap:SetAsync("GameStart_"..serverid, , 240)
		--end)

		if not succ then
			print("errr occurred")
			return
		end

		plr:SetAttribute("Teleporting", true)
		tpService:TeleportToPrivateServer(placeID, server, game:GetService("Players"):GetPlayers(), nil, {
			MapName = MapName,
			Difficulty = difficulty,
			GameType = GameType, -- "Story", "Infinity", "Challenge"
			GameScenarioId = GameScenarioID, -- story chapter if story, some challenge name if challenge when we add it later
		})
	else
		plr:Kick("False request initiated")
	end
end

function module:start()
	playerActions.Teleport.OnServerEvent:Connect(function(...)
		module:Teleport(...)
	end)
end

return module
