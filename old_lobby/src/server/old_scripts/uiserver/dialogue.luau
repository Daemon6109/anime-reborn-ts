--// Used for general responses for dialogues

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")
local TeleportService = game:GetService("TeleportService")
local NotifyPlayer_RE = ReplicatedStorage.Events.NotifyPlayer_2
local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local TeamEventInfo = require(ReplicatedStorage.Registry.TeamEventData)

local DataAPI = DataAccess:GetAPI()

local TeamEvent_Mod = require(ServerScripts.Services.TeamEvent)

local PlaceIdTab = {
	["17046374415"] = 72761785039317,
	["132521906070053"] = 72761785039317,
	["87542414930759"] = 110856386419404,
}

local AFK_PLACE_ID = PlaceIdTab[tostring(game.PlaceId)] or 72761785039317
local EarlyBirdRoles = {
	"Early Bird",
	"Owner",
	"Co-Owner",
	"Project Leader",
	"Veteran",
	"Lead-Developer",
	"Developer+",
	"developerX",
	"Developer",
	"Tester",
	"[CLOSED] Tester",
	"[CLOSED] Tester",
	"Content Creator",
}

local MessagingService = game:GetService("MessagingService")
local http = game:GetService("HttpService")

local Dialogue = {
	TeleportToAFK = function(player: Player)
		if player:GetAttribute("TeleportingToAFK") then
			return
		end

		player:SetAttribute("TeleportingToAFK", true)

		local success, _err = pcall(function()
			local Code = TeleportService:ReserveServer(AFK_PLACE_ID)

			TeleportService:TeleportToPrivateServer(AFK_PLACE_ID, Code, { player })
		end)

		if not success then
			player:SetAttribute("TeleportingToAFK", nil)
			warn(`Error occured while tping to AFK: {_err}`)
		end
	end,

	ClaimBuilderGems = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if not PlayerProfile:GetField("NPCData").ClaimedBuilderGems then
			PlayerProfile:WriteDirectory("NPCData/ClaimedBuilderGems", true, true)
			PlayerProfile:WriteDirectory("NPCZonesData/GoodBuilder", false, true)

			_G.serverServices.PlayerService:GiveCurrency(player, "Gems", 100)
		end
	end,

	SoloWoo = function(player: player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		local HasUnit
		local UnitInventory = PlayerProfile:GetField("Inventory").Units

		local UnitRegistry = _G.Registry.registry.Units
		for id, v in UnitInventory do
			--warn(v.UnitName, UnitRegistry[v.UnitName])
			if v.UnitName == "Sung Jinwoo [Evo2]" then
				HasUnit = true
			end
		end
		warn("Okay")
		if not HasUnit then
			return
		end
		warn("Please bro")
		warn(PlayerProfile:GetField("NPCZonesData"))
		if PlayerProfile:GetField("NPCZonesData").SoloWooZone then
			_G.serverServices.QuestHandler:GivePoints(player, "Special1NPC", 1)
		end

		PlayerProfile:WriteDirectory("NPCZonesData/SoloWooZone", false, true)
	end,

	SoloWooFinal = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		local Quests = PlayerProfile:GetField("Quests")
		local FinishedQuests = Quests and Quests.FinishedQuests
		local Special7SecretPortal = FinishedQuests and FinishedQuests.Special7SecretPortal
		if not Special7SecretPortal then
			return
		end

		_G.serverServices.QuestHandler:GivePoints(player, "Special9NPC", 1)
	end,

	RebornQuester = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local QuestData = PlayerProfile:GetField("Quests")

		if not QuestData.ActiveQuests["RebornQuest1"] and not QuestData.FinishedQuests["RebornQuest1"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "RebornQuest1" })
		end
		if not QuestData.ActiveQuests["RebornQuest2"] and not QuestData.FinishedQuests["RebornQuest2"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "RebornQuest2" })
		end
		if not QuestData.ActiveQuests["RebornQuest3"] and not QuestData.FinishedQuests["RebornQuest3"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "RebornQuest3" })
		end
		if not QuestData.ActiveQuests["RebornQuest4"] and not QuestData.FinishedQuests["RebornQuest4"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "RebornQuest4" })
		end
		if not QuestData.ActiveQuests["RebornQuest6"] and not QuestData.FinishedQuests["RebornQuest6"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "RebornQuest6" })
		end
		if not QuestData.ActiveQuests["RebornQuest7"] and not QuestData.FinishedQuests["RebornQuest7"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "RebornQuest7" })
		end

		if not QuestData.FinishedQuests["RebornQuest1"] then
			return
		end
		if not QuestData.FinishedQuests["RebornQuest2"] then
			return
		end
		if not QuestData.FinishedQuests["RebornQuest3"] then
			return
		end
		if not QuestData.FinishedQuests["RebornQuest4"] then
			return
		end
		if not QuestData.FinishedQuests["RebornQuest6"] then
			return
		end

		_G.serverServices.QuestHandler:GivePoints(player, "RebornQuest7", 1)
	end,

	HallowQuest = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local QuestData = PlayerProfile:GetField("Quests")

		if QuestData.FinishedQuests["HallowSpecial4"] then
			if not QuestData.ActiveQuests["HallowSpecial5"] and not QuestData.FinishedQuests["HallowSpecial5"] then
				_G.serverServices.QuestHandler:GiveQuest(player, { "HallowSpecial5" })
			end
			return
		end

		if not QuestData.ActiveQuests["HallowSpecial1"] and not QuestData.FinishedQuests["HallowSpecial1"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "HallowSpecial1" })
		end
		if not QuestData.ActiveQuests["HallowSpecial2"] and not QuestData.FinishedQuests["HallowSpecial2"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "HallowSpecial2" })
		end
		if not QuestData.ActiveQuests["HallowSpecial3"] and not QuestData.FinishedQuests["HallowSpecial3"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "HallowSpecial3" })
		end
		if not QuestData.ActiveQuests["HallowSpecial4"] and not QuestData.FinishedQuests["HallowSpecial4"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "HallowSpecial4" })
		end

		if not QuestData.FinishedQuests["HallowSpecial1"] then
			return
		end
		if not QuestData.FinishedQuests["HallowSpecial2"] then
			return
		end
		if not QuestData.FinishedQuests["HallowSpecial3"] then
			return
		end
		--if not QuestData.FinishedQuests["HallowSpecial4"] then return end

		_G.serverServices.QuestHandler:GivePoints(player, "HallowSpecial4", 1)
	end,

	OrihimeDialogue = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local QuestData = PlayerProfile:GetField("Quests")

		if not QuestData.FinishedQuests["HallowSpecial1"] then
			return
		end
		if not QuestData.FinishedQuests["HallowSpecial2"] then
			return
		end
		if not QuestData.FinishedQuests["HallowSpecial3"] then
			return
		end
		if not QuestData.FinishedQuests["HallowSpecial4"] then
			return
		end

		if QuestData.ActiveQuests["HallowSpecial5"] then
			_G.serverServices.QuestHandler:GivePoints(player, "HallowSpecial5", 1)
		end
	end,

	ReaperParts = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		local TED = PlayerProfile:GetField("TeamEventData")
		local data = PlayerProfile:GetField("Inventory").Items
		local ContributedRP = TED.ContributedReaperParts
		local itemService = _G.serverServices.ItemManager
		local QuestData = PlayerProfile:GetField("Quests")

		if not QuestData.ActiveQuests["HallowSpecial1"] and not QuestData.FinishedQuests["HallowSpecial1"] then
			_G.serverServices.QuestHandler:GiveQuest(player, { "HallowSpecial1" })
		end

		if ContributedRP >= 30 then
			--warn("Giving", ContributedRP, ReaperPartCount)
			--itemService:GiveItems(player, {["Lanzar"] = 1}, nil, true)
			PlayerProfile:WriteDirectory("TeamEventData/ContributedReaperParts", 0, true)
			_G.serverServices.QuestHandler:GivePoints(player, "HallowSpecial1", 1)
		else
			local ReaperPartCount = data["ReaperPart"] and data["ReaperPart"].Count or 0
			if not ReaperPartCount or ReaperPartCount <= 0 then
				return
			end
			if not itemService then
				return
			end
			local Required = 30 - tonumber(ContributedRP)
			local Subtract = ReaperPartCount
			if Required < ReaperPartCount then
				Subtract = Required
			end
			warn(Required)
			warn(Subtract)
			warn(ReaperPartCount)
			warn("To Subtract", Required, Subtract)
			--PlayerProfile:WriteDirectory("TeamEventData/ContributedReaperParts", 0, true)
			itemService:GiveItems(player, { ["ReaperPart"] = -Subtract }, nil, true)
			PlayerProfile:WriteDirectory("TeamEventData/ContributedReaperParts", ContributedRP + Subtract, true)
			warn(
				"Write Directory",
				ContributedRP + Subtract,
				PlayerProfile:GetField("TeamEventData").ContributedReaperParts
			)
		end
	end,

	SoloWooFinalFinal = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		local Quests = PlayerProfile:GetField("Quests")
		local FinishedQuests = Quests and Quests.FinishedQuests
		local Special7SecretPortal = FinishedQuests and FinishedQuests.Special7SecretPortal
		if not Special7SecretPortal then
			return
		end

		if not FinishedQuests.Special1NPC then
			return
		end
		if not FinishedQuests.Special2Unit then
			return
		end
		if not FinishedQuests.Special3Unit then
			return
		end
		if not FinishedQuests.Special4Unit then
			return
		end
		if not FinishedQuests.Special5Unit then
			return
		end
		if not FinishedQuests.Special6Tier6Dungeon then
			return
		end
		if not FinishedQuests.Special7SecretPortal then
			return
		end
		if not FinishedQuests.Special8DreamKey then
			return
		end
		if not FinishedQuests.Special9NPC then
			return
		end
		if FinishedQuests.Special10NPC then
			warn("Quest Complete")
			return
		end

		_G.serverServices.QuestHandler:GivePoints(player, "Special10NPC", 1)
	end,

	ConsumeEaster = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Easter2025Score = PlayerProfile:GetField("Easter2025Score") or 0

		if Easter2025Score >= 20 then
			if Easter2025Score >= 100 then
				_G.serverServices.ItemManager:GiveItems(player, { ["100% Egg"] = 1 })
			else
				local PossibleItems = {}
				for _, Amount in { 20, 40, 60, 80 } do
					if Easter2025Score >= Amount then
						PossibleItems[#PossibleItems + 1] = `{tostring(Amount)}% Egg`
					end
				end

				local Chosen = PossibleItems[math.random(#PossibleItems)]
				_G.serverServices.ItemManager:GiveItems(player, { [Chosen] = 1 })
			end

			PlayerProfile:WriteField("Easter2025Score", 0, true)
		end
	end,

	BuyEasterPortal = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Currencies = PlayerProfile:GetField("Currencies")
		local Gems = Currencies.Gems

		if Gems >= 100 then
			_G.serverServices.PlayerService:GiveCurrency(player, "Gems", -100)
			_G.serverServices.ItemManager:GiveItems(player, { ["T1_BunnyVillagePortal"] = 1 })
		end
	end,

	SacrificeSouls = function(player: Player, amount: number)
		local Day = os.date("!*t").wday
		local Double = (Day == 1 or Day == 6 or Day == 7)
		warn("Doubling:", Double)

		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if DateTime.now().UnixTimestamp > TeamEventInfo.EndsIn then
			return
		end
		if
			amount ~= amount
			or not tonumber(amount)
			or (
				player:GetAttribute("SacrificeSoulsCooldown")
				and (workspace:GetServerTimeNow() - player:GetAttribute("SacrificeSoulsCooldown")) < 30
			)
		then
			return
		end

		amount = math.floor(math.abs(tonumber(amount)))
		amount = math.clamp(amount, 1, math.huge)

		if not _G.serverServices.ItemManager:HasItem(player, "Soul", amount) then
			return
		end

		player:SetAttribute("SacrificeSoulsCooldown", workspace:GetServerTimeNow())

		_G.serverServices.ItemManager:GiveItems(player, { Soul = -amount })

		if Double then
			amount *= 2
		end

		PlayerProfile:WriteDirectory(
			"TeamEventData/ContributedSouls",
			PlayerProfile:GetField("TeamEventData").ContributedSouls + amount,
			true
		)
		TeamEvent_Mod:Increment(PlayerProfile:GetField("TeamEventData").Team, amount)
	end,

	ClaimGroupPrize = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Success, Role = pcall(function()
			return player:GetRoleInGroup(33820338)
		end)

		if not PlayerProfile:GetField("NPCData").ClaimedGroupPrize and Success and Role ~= "Guest" then
			PlayerProfile:WriteDirectory("NPCData/ClaimedGroupPrize", true, true)
			PlayerProfile:WriteDirectory("NPCZonesData/GroupZone", false, true)
			_G.serverServices.PlayerService:GiveCurrency(player, "Gems", 500)
			_G.serverServices.ItemManager:GiveItems(player, { TraitCrystal = 1 })
			if table.find(EarlyBirdRoles, Role) then
				local ExtraData = {
					Shiny = (
						(
								math.random(1, 100) == 1
								or Role == "[CLOSED] Tester"
								or Role == "Developer+"
								or "developerX"
							)
							and true
						or nil
					),
				}
				local ChosenUUID = _G.serverServices.UnitManager:giveUnit(player, "Tanjiro Bloodlust", 1, ExtraData)[1]
				if ExtraData.Shiny then
					local IsShiny = ExtraData.Shiny
					local String =
						`{player.DisplayName} (@{player.Name}) has obtained a {IsShiny and "Shiny " or ""}Exclusive Sun Prodigy [Blazing]`

					local Success, EncodedString = pcall(function()
						return http:JSONEncode(String)
					end)

					local Success, Error = pcall(function()
						return _G.serverServices.MessagingHandler:PublishAsync("Chat", EncodedString)
					end)
				end
				ReplicatedStorage.Events.InspectLib:FireClient(player, { ChosenUUID })
			end
		end
	end,

	ClaimCCPrize = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)
		local Success, Role = pcall(function()
			return player:GetRoleInGroup(33820338)
		end)

		if Role ~= "Developer+" and Role ~= "Content Creator" then
			return
		end
		warn("Claiming CC Prize")
		if not PlayerProfile:GetField("NPCData").ClaimedCCPrize and Success and Role ~= "Guest" then
			PlayerProfile:WriteDirectory("NPCData/ClaimedCCPrize", true, true)
			PlayerProfile:WriteDirectory("NPCData/ClaimedGroupPrize", true, true)
			PlayerProfile:WriteDirectory("NPCZonesData/GroupZone", false, true)
			_G.serverServices.PlayerService:GiveCurrency(player, "Gems", 500)
			_G.serverServices.ItemManager:GiveItems(player, { TraitCrystal = 1 })
			if table.find(EarlyBirdRoles, Role) then
				local ExtraData = {
					Shiny = (
						(math.random(1, 100) == 1 or Role == "[CLOSED] Tester" or Role == "Developer+") and true or nil
					),
				}
				local ChosenUUID = _G.serverServices.UnitManager:giveUnit(player, "Tanjiro Bloodlust", 1, ExtraData)[1]
				if ExtraData.Shiny then
					local IsShiny = ExtraData.Shiny
					local String =
						`{player.DisplayName} (@{player.Name}) has obtained a {IsShiny and "Shiny " or ""}Exclusive Sun Prodigy [Blazing]`

					local Success, EncodedString = pcall(function()
						return http:JSONEncode(String)
					end)

					local Success, Error = pcall(function()
						return _G.serverServices.MessagingHandler:PublishAsync("Chat", EncodedString)
					end)
				end
				ReplicatedStorage.Events.InspectLib:FireClient(player, { ChosenUUID })
			end
		end
	end,

	ClaimFreeTraitRerolls = function(player: Player)
		local PlayerProfile = DataAPI:GetActivePlayerProfileClass(player)

		if not PlayerProfile:GetField("NPCData").ClaimedFreeTraitRerolls then
			PlayerProfile:WriteDirectory("NPCData/ClaimedFreeTraitRerolls", true, true)
			PlayerProfile:WriteDirectory("NPCZonesData/TraitRerollZone", false, true)

			_G.serverServices.ItemManager:GiveItems(player, { TraitCrystal = 1 })
		end
	end,
}

return Dialogue
