local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local LevelData = require(ReplicatedStorage.Registry.LevelData)
local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

local DataAPI = DataAccess:GetAPI()

local NPCNotifications = {
	Toggle = function(player: Player, ZoneName, Boolean)
		--warn('got here',player,ZoneName,Boolean)
		if typeof(ZoneName) ~= "string" then
			warn("returning 1")
			return
		end
		if typeof(Boolean) ~= "boolean" then
			warn("returning 2")
			return
		end
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local NPCZonesData = PlayerProfile:GetField("NPCZonesData")

		if NPCZonesData[ZoneName] == nil then
			warn("returning 3")
			return
		end

		NPCZonesData[ZoneName] = Boolean

		PlayerProfile:WriteDirectory(`NPCZonesData/{ZoneName}`, Boolean, true)
		--warn('NPCZonesData',NPCZonesData)
	end,
}

return NPCNotifications
