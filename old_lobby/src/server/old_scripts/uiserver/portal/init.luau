local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local UiCommunication = ReplicatedStorage.Events.UiCommunication
local PortalClass = require(script.PortalClass)
local PortalRegistry = _G.Registry.registry.Portals
local ItemRegistry = _G.Registry.registry.Items

local http = game:GetService("HttpService")

local DataAccess = require(game.ServerScriptService.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()

local ActivePortals: {
	[string]: PortalClass.ActivePortal,
} = {}
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer

local Cooldown = {}

local MatchStats = {
	OpenPortal = function(player: Player, PortalUUID: string, Position: Vector3, FriendsOnly: boolean?)
		if Cooldown[player.UserId] then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "Chill out! You are on cooldown.",
			})
			return
		end
		local ItemManger = _G.serverServices.ItemManager
		local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		local PortalItem = PlayerProfileClass:GetField("Inventory").Items[PortalUUID]
		local _FoundInRegistry = PortalRegistry[PortalItem.Name]

		if PlayerProfileClass:GetField("Level") < _FoundInRegistry.configuration.LevelRequirement then
			return
		end
		if player:GetAttribute("Portal") then
			return
		end
		if player:GetAttribute("WindowsDisabled") then
			return
		end
		if
			_FoundInRegistry
			and ItemRegistry[PortalItem.Name]
			and table.find(ItemRegistry[PortalItem.Name].configuration.Sort, "Portal")
		then
			Cooldown[player.UserId] = true
			task.delay(20, function()
				Cooldown[player.UserId] = nil
			end)
			ItemManger:GiveItems(player, {
				[PortalUUID] = -1,
			})
			ActivePortals[PortalUUID] =
				PortalClass.new(player, PortalItem.Name, Position, FriendsOnly, PortalUUID, PortalItem.ExtraData)
		end
	end,
	StartGame = function(player: Player, UUID: string)
		local _PortalC = ActivePortals[UUID]
		if _PortalC then
			if not _PortalC.PortalModel.Parent or _PortalC.PortalModel:GetAttribute("Starting") then
				return
			end
			if player.UserId ~= _PortalC.Host.UserId then
				return
			end
			if not _PortalC:IsPortalActive() then
				return
			end
			_PortalC:StartGame(false)
		end
	end,
	Leave = function(player: Player, UUID: string)
		local _PortalC = ActivePortals[UUID]
		if _PortalC then
			if not _PortalC:IsPortalActive() then
				return
			end
			warn("_PortalC", _PortalC)
			if _PortalC.Removing then
				warn("Already removing")
				return
			else
				_PortalC.Removing = true
			end
			_PortalC:RemovePlayer(player)
		end
	end,
}

return MatchStats
