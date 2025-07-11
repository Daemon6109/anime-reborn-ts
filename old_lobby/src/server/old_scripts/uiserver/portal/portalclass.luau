--// @bravobravo909
local Class = {}
Class.__index = Class

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local TeleportService = game:GetService("TeleportService")

local Registry = _G.Registry.registry
local PortalRegistry = Registry.Portals

local DataAccess = require(ServerScriptService.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
local HTTP = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Events = ReplicatedStorage.Events
local Maid = require(ReplicatedStorage.Maid).new()
local UICommunication = Events.UiCommunication
local TeleportingToggle_RE = ReplicatedStorage.Events.TeleportingToggle

export type ActivePortal = {
	Host: Player,
	PortalName: string,
	CountdownThread: thread,
	PortalModel: Model,
	UUID: string,
	Data: table?,
} & typeof(Class)

local function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end
local NotifyPlayer = ReplicatedStorage.Events.NotifyPlayer

function Class.new(
	Host: Player,
	PortalName: string,
	Position: Vector3,
	FriendsOnly: boolean,
	UUID: string,
	Data: table?
): ActivePortal
	local _FoundPortal = PortalRegistry[PortalName]
	if not _FoundPortal then
		return
	end

	local self = setmetatable({}, Class)
	local _model = script.PortalHolderTemplate:Clone()

	_model.Name = UUID
	_model:PivotTo(Position)
	_model:SetAttribute("Players", HTTP:JSONEncode({ Host.UserId }))
	_model:SetAttribute("Host", Host.UserId) --host.userid
	_model:SetAttribute("Countdown", 60)
	_model:SetAttribute("PortalName", PortalName)
	_model:SetAttribute("UniqueData", HTTP:JSONEncode(Data))
	_model.Parent = workspace.Portals
	Host:SetAttribute("Portal", true)

	self.Host = Host
	self.PortalModel = _model :: Model
	self.PortalName = PortalName :: string
	self.FriendsOnly = FriendsOnly :: boolean
	self.Data = Data :: table
	Maid:StartTree(UUID)

	Maid:GiveTreeTask(UUID, "Listener", _model.ProximityPrompt.Triggered, function(player)
		local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
		--_model.ProximityPrompt.ObjectText = `Players: ({#CurrentPlayers}/6)`

		if player:GetAttribute("Portal") then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = `You are already in a portal!`,
			})
			return
		end
		if self.PortalModel:GetAttribute("Starting") then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = `Game is starting!`,
			})
			return
		end
		if #CurrentPlayers >= _FoundPortal.configuration.MaxPlayers then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = `Queue is full! [{#CurrentPlayers}/{_FoundPortal.configuration.MaxPlayers}]`,
			})
			return
		end

		local _ProfileClass = DataAPI:GetActivePlayerProfileClass(player)
		local Level = _ProfileClass:GetField("Level")

		if _FoundPortal.configuration.LevelRequirement and Level < _FoundPortal.configuration.LevelRequirement then
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = `You don't meet level requirement [Lvl {Level}+]`,
			})
			return
		end

		if not table.find(CurrentPlayers, player.UserId) then
			if self.FriendsOnly then
				local Success, IsFriends = pcall(function()
					return self.Host:IsFriendsWith(player.UserId)
				end)

				if not IsFriends then
					NotifyPlayer:FireClient(player, {
						color = "Error",
						text = "Only friends of the host can join this portal!",
					})
					return
				end
			end

			self:AddPlayer(player)
			local _CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
			NotifyPlayer:FireClient(player, {
				color = "Success",
				text = `Joined the queue! [{#_CurrentPlayers}/{_FoundPortal.configuration.MaxPlayers}]`,
			})
		else
			NotifyPlayer:FireClient(player, {
				color = "Error",
				text = "You are already in the queue!",
			})
		end

		local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
		_model.ProximityPrompt.ObjectText = `Players: ({#CurrentPlayers}/6)`
	end)
	Maid:GiveTreeTask(UUID, "PlayerLeft", Players.PlayerRemoving, function(plr: Player)
		local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
		if plr.UserId == self.Host.UserId then
			self:_Dispose(false, false)
			return
		end
		if table.find(CurrentPlayers, plr.UserId) then
			table.remove(CurrentPlayers, table.find(CurrentPlayers, plr.UserId))
		end
		local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
		_model.ProximityPrompt.ObjectText = `Players: ({#CurrentPlayers}/6)`
	end)

	self.UUID = UUID :: string
	UICommunication:FireAllClients("Portal/PortalOpened", PortalName, UUID)

	self.CountdownThread = task.spawn(function()
		while task.wait(1) do
			local CurrentCountDown = _model:GetAttribute("Countdown")
			_model:SetAttribute("Countdown", CurrentCountDown - 1)
			if CurrentCountDown - 1 <= 0 then
				self:StartGame(true)
				break
			end
		end
	end) :: thread
	return self
end

function Class:IsPortalActive(): boolean
	return self.PortalModel:GetAttribute("Countdown") > 0
end

function Class:AddPlayer(Player: Player)
	local _FoundPortal = PortalRegistry[self.PortalName]
	local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)

	if _FoundPortal then
		local Level = PlayerProfileClass:GetField("Level")
		local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
		if Level < _FoundPortal.configuration.LevelRequirement then
			return
		end
		if
			#CurrentPlayers < _FoundPortal.configuration.MaxPlayers
			and not table.find(CurrentPlayers, Player.UserId)
			and self:IsPortalActive()
		then
			table.insert(CurrentPlayers, Player.UserId)
			self.PortalModel:SetAttribute("Players", HTTP:JSONEncode(CurrentPlayers))
			Player:SetAttribute("Portal", true)
		end
	end
end

function Class:_TeleportPlayers(): boolean?
	local _FoundInRegistry = PortalRegistry[self.PortalName]
	if not _FoundInRegistry then
		return
	end
	local AllPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
	if #AllPlayers < 1 then
		return
	end
	local GameType, MapName, GameScenarioID, Difficulty = "Portal", self.Data.Map, self.Data.Act, "Normal"
	local PlaceId = (game.GameId == 6717025335 and 127759625243990) or (game.GameId == 5844593548 and 87213590469285) -- _G.Registry.registry.Maps[MapName].PlaceId
	local PlayerList = {}

	for _, playerID in AllPlayers do
		local _plr = Players:GetPlayerByUserId(playerID)
		if _plr then
			TeleportingToggle_RE:FireClient(_plr, true, {
				GameType = GameType,
				MapName = MapName,
				GameScenarioID = GameScenarioID,
				Difficulty = Difficulty,
			})
			table.insert(PlayerList, _plr)
		end
	end

	local TeleportOptions = Instance.new("TeleportOptions")
	TeleportOptions.ShouldReserveServer = true
	TeleportOptions:SetTeleportData({
		MapName = MapName,
		Difficulty = Difficulty,
		GameType = GameType, -- "Story", "Infinity", "Challenge"
		GameScenarioId = GameScenarioID, -- story chapter if story, some challenge name if challenge when we add it later
		Host = self.Host and self.Host.UserId,
		Challenges = { self.Data.Challenge },
		ElementBuff = self.Data.Buff,
		ElementDebuff = self.Data.Debuff,
		ForcedElements = self.Data.ForcedElements,
		PortalName = self.PortalName,
	})

	local Success, TeleportResult = pcall(function()
		return TeleportService:TeleportAsync(PlaceId, PlayerList, TeleportOptions)
	end)
	if not Success then
		for _, Player in PlayerList do
			TeleportingToggle_RE:FireClient(Player, false, {
				GameType = GameType,
				MapName = MapName,
				GameScenarioID = GameScenarioID,
				Difficulty = Difficulty,
			})
			if Player.UserId == self.Host.UserId then
				if not self.Given then
					_G.serverServices.ItemManager:GiveItems(Player, {
						[self.PortalName] = 1,
					})

					NotifyPlayer:FireClient(Player, {
						color = "Error",
						text = "Error occurred when teleporting. Portal was given back.",
					})
					self.Given = true
				end
			else
				NotifyPlayer:FireClient(Player, {
					color = "Error",
					text = "Error occurred when teleporting",
				})
			end
		end
		return
	end

	--local Server, ServerId = TeleportResult.ReservedServerAccessCode, TeleportResult.PrivateServerId

	--TeleportService:TeleportPartyAsync(PlaceId, ZoneData.Players, )

	--TeleportService:TeleportToPrivateServer(PlaceId, Server, ZoneData.Players,
	return true
end

function Class:_Dispose(Timeout: boolean, Start: boolean)
	local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
	self.PortalModel:SetAttribute("Starting", true)
	if not Timeout then
		task.cancel(self.CountdownThread)
	end
	Maid:EndTree(self.UUID)
	if not Start then
		for _, UserId in CurrentPlayers do
			local _player = Players:GetPlayerByUserId(tonumber(UserId))
			if _player then
				_player:SetAttribute("Portal", nil)
			end
		end
		self.PortalModel:Destroy()

		_G.serverServices.ItemManager:GiveItems(self.Host, {
			[self.PortalName] = 1,
		}, nil, nil, self.Data)

		print("Cancelled")
	else
		if self:_TeleportPlayers() then
			for _, UserId in CurrentPlayers do
				local _player = Players:GetPlayerByUserId(tonumber(UserId))
				if _player then
					_player:SetAttribute("Portal", nil)
				end
			end
			self.PortalModel:Destroy()
		else
			for _, UserId in CurrentPlayers do
				local _player = Players:GetPlayerByUserId(tonumber(UserId))
				if _player then
					_player:SetAttribute("Portal", nil)
				end
			end
			self.PortalModel:Destroy()
		end
	end
end

function Class:StartGame(Timeout: boolean)
	self:_Dispose(Timeout, true)
end

function Class:RemovePlayer(Player: Player)
	local CurrentPlayers = HTTP:JSONDecode(self.PortalModel:GetAttribute("Players"))
	if Player.UserId == self.Host.UserId then
		if Player:GetAttribute("RemovingPortal") then
			return
		else
			Player:SetAttribute("RemovingPortal", true)
		end
		self:_Dispose(false, false)
		Player:SetAttribute("RemovingPortal", nil)
		return
	end

	if table.find(CurrentPlayers, Player.UserId) then
		table.remove(CurrentPlayers, table.find(CurrentPlayers, Player.UserId))
		Player:SetAttribute("Portal", nil)
		self.PortalModel:SetAttribute("Players", HTTP:JSONEncode(CurrentPlayers))
	end
end

return Class
