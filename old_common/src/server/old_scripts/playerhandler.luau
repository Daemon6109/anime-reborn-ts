--!native
local module = {}
local Replicated = game:GetService("ReplicatedStorage")
local physicsService = game:GetService("PhysicsService")
local GameShutdowning = Replicated:WaitForChild("gameShutdowning")
local AnalyticsService = game:GetService("AnalyticsService")
local DataStoreService = game:GetService("DataStoreService")
local HTTP = game:GetService("HttpService")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local GiftInboxDataStore =
	DataStoreService:GetDataStore(game:GetService("ServerScriptService").GiftInboxDatastoreName.Value)

local services = _G.serverServices
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)

--// Attempts to fire a given method to a service
-- playerLoaded fires after the player joins for the first time is completely loaded
-- characterAdded fires after the player's character is added
local function RunServiceMethod(method: string, ...: any?)
	local args = { ... }

	task.spawn(function()
		if not game.ReplicatedStorage.ServerLoaded.Value then
			game.ReplicatedStorage.ServerLoaded.Changed:Wait()
		end

		for _, module in _G.serverServices do
			--print(method, module[method], _)
			if type(module[method]) == "function" then
				task.spawn(function()
					module[method](module, table.unpack(args)) -- Pass the module first to assign self
				end)
			end
		end
	end)
end

local function deepReconcile(template, data)
	local function reconcileTables(template, data)
		local reconciled = {}

		for key, templateValue in pairs(template) do
			if type(templateValue) == "table" then
				reconciled[key] = reconcileTables(templateValue, data[key] or {})
			else
				if data[key] ~= nil then
					reconciled[key] = data[key]
				else
					reconciled[key] = templateValue
				end
			end
		end

		for key, dataValue in pairs(data) do
			if reconciled[key] == nil then
				reconciled[key] = dataValue
			end
		end

		return reconciled
	end

	return reconcileTables(template, data)
end

local ReconcileSungJinWoo = {
	"Special1NPC",
	"Special2Unit",
	"Special3Unit",
	"Special4Unit",
	"Special5Unit",
	"Special6Tier6Dungeon",
	"Special7SecretPortal",
	"Special8DreamKey",
	"Special9NPC",
	"Special10NPC",
}

function module:start()
	local DataAPI = DataAccess:GetAPI()
	local whitelists = require(script.Parent.Parent.ServerLibs.PlaceWhitelist)

	local function plrAdded(player)
		AnalyticsService:LogOnboardingFunnelStepEvent(player, 1, "Player Joined")

		local profile = DataAPI:GetActivePlayerProfileClass(player)

		player:SetAttribute("LastPlayTimeRefresh", os.time())

		RunServiceMethod("playerLoaded", player)

		if player.Character then
			RunServiceMethod("characterAdded", player, player.Character)
		end

		player.CharacterAdded:Connect(function(newCharacter)
			RunServiceMethod("characterAdded", player, newCharacter)
		end)

		----Unit RollBack
		--local Quests = profile:GetField('Quests')
		--if Quests.FinishedQuests["Special10NPC"]  then

		--	for _,QuestName in ReconcileSungJinWoo do
		--		Quests.FinishedQuests[QuestName] = nil
		--		Quests.ActiveQuests[QuestName] = 0
		--	end
		--	profile:WriteField(`Quests`,Quests,true)
		--end

		--for _,QuestName in ReconcileSungJinWoo do
		--	if not Quests.ActiveQuests[QuestName] and not Quests.FinishedQuests[QuestName] then
		--		profile:WriteDirectory(`Quests/ActiveQuests/{QuestName}`,0,true)
		--	end
		--end

		warn("Quests", profile:GetField("Quests"))

		if table.find(whitelists.LobbyPlaces, game.PlaceId) then
			task.spawn(function()
				local RetryDelay = 2

				for i = 1, 10 do
					if not player.Parent then
						return
					end

					RetryDelay *= 2

					local loadedGiftInbox, err = pcall(function()
						local GiftInbox = GiftInboxDataStore:GetAsync("Player_" .. player.UserId)

						if not GiftInbox then
							GiftInboxDataStore:SetAsync("Player_" .. player.UserId, {})
						end
					end)

					if loadedGiftInbox then
						return
					end

					warn(`Failed to check Gift Inbox. Retrying. Error: {err}`)
					task.wait(RetryDelay)
				end
			end)

			profile:WriteDirectory("AFKData/SessionData/Uptime", 0)
			profile:WriteDirectory("AFKData/SessionData/GemsGained", 0)
			profile:WriteDirectory("AFKData/SessionData/TraitRerollsGained", 0)

			task.spawn(function()
				if not game.ReplicatedStorage.ServerLoaded.Value then
					game.ReplicatedStorage.ServerLoaded.Changed:Wait()
				end

				local SummonHandler = _G.serverServices.SummonHandler

				local HasPremium = player.MembershipType == Enum.MembershipType.Premium
				local HasVIP = profile:GetField("ProductsBought")["887686872"]

				for _, unit in profile:GetField("AFKData").SessionData.ObtainedUnits do
					local Chance = HasVIP or HasPremium and 2 or 1
					local ROLLED_SHINY_ODD = Random.new():NextInteger(1, 100 * 10)
					local CURRENT_LUCK_ODD_THRESHOLD = SummonHandler:CalculateShinyChance(player, Chance) * 10

					_G.serverServices.UnitManager:giveUnit(
						player,
						unit,
						1,
						ROLLED_SHINY_ODD <= CURRENT_LUCK_ODD_THRESHOLD and { Shiny = true }
					)
				end

				profile:WriteDirectory("AFKData/SessionData/ObtainedUnits", {})
			end)
		end
	end

	local function UpdatePlayTime(player)
		local LastPlayTimeRefresh = player:GetAttribute("LastPlayTimeRefresh")

		if LastPlayTimeRefresh then
			local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
			local PlayerStatistics = PlayerProfile:GetField("PlayerStatistics")

			player:SetAttribute("LastPlayTimeRefresh", os.time())

			PlayerProfile:WriteDirectory(
				"PlayerStatistics/PlayTime",
				PlayerStatistics.PlayTime + (os.time() - LastPlayTimeRefresh),
				true
			)
		end
	end

	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(plrAdded, player)
	end

	Players.PlayerAdded:Connect(plrAdded)

	task.spawn(function()
		while task.wait(60) do
			for _, player in Players:GetPlayers() do
				UpdatePlayTime(player)
			end
		end
	end)

	if table.find(whitelists.LobbyPlaces, game.PlaceId) then
		Replicated.Events.GetGiftInboxData.OnServerInvoke = function(player: Player)
			if player:GetAttribute("GiftInboxRequestCooldown") then
				return
			end --// Make sure to handle this on client too (checking if there's a cooldown)

			player:SetAttribute("GiftInboxRequestCooldown", true)

			local RetryDelay = 2

			for i = 1, 10 do
				if not player.Parent then
					return
				end

				RetryDelay *= 2

				local Loaded, GiftInbox = pcall(function()
					return GiftInboxDataStore:GetAsync("Player_" .. player.UserId)
				end)

				if Loaded then
					task.delay(2, function()
						if player.Parent then
							player:SetAttribute("GiftInboxRequestCooldown", nil)
						end
					end)

					return GiftInbox
				end

				warn(`Failed to get Gift Inbox. Retrying. Error: {GiftInbox}`)
				task.wait(RetryDelay)
			end

			task.delay(2, function()
				if player.Parent then
					player:SetAttribute("GiftInboxRequestCooldown", nil)
				end
			end)

			return
		end
	end
end

return module
