--// By @Nahid

local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local MessagingService = game:GetService("MessagingService")
local PlayerService = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScripts = game:GetService("ServerScriptService")

local DataAccess = require(ServerScripts.ServerLibs.DataAccessAPI)
local PlaceWhitelist = require(ServerScripts.ServerLibs.PlaceWhitelist)
local ProfileService = require(ServerScripts.ServerLibs.ProfileStore)
local ProfileTemplate = require(ServerScripts.ServerLibs.ProfileTemplate)

local DataAPI = DataAccess:GetAPI()

local MessagingHandler = {}
MessagingHandler.__index = MessagingHandler

--// Get current messaging limit
function MessagingHandler:GetMessagesLimit()
	return 10 --600 + 240 * #PlayerService:GetPlayers()
end

--// Variables
local Minute = 0
local MessagesSentCounter = 0
local DelayedMessages = {}

function MessagingHandler:GetMinute()
	return math.floor(DateTime.now().UnixTimestamp / 60)
end

--// Refreshes the counter
function MessagingHandler:RefreshCounter()
	local CurrentMinute = self:GetMinute()
	if CurrentMinute == Minute then
		return
	end
	Minute = CurrentMinute
	MessagesSentCounter = 0
end

--// Check if can publish
function MessagingHandler:CanPublish()
	self:RefreshCounter()
	local CanPublish = (MessagesSentCounter + 1) < MessagingHandler:GetMessagesLimit()
	print("CanPublish:", CanPublish)
	return CanPublish
end

--// Returns encoded string
function MessagingHandler:ProcessString(String)
	print("ProcessString:", String)
	if typeof(String) == "string" then
		return String
	end
	local Success, EncodedString = pcall(function()
		return HttpService:JSONEncode(String)
	end)
	if Success and EncodedString then
		return EncodedString
	else
		warn(EncodedString)
	end
end

--// Publishing
function MessagingHandler:_Publish(Topic, String)
	if not self:CanPublish() then
		print("Delaying")
		self:AddDelayed(Topic, String)
		return
	end
	local Success, Error = pcall(function()
		print("Publishing")
		return MessagingService:PublishAsync(Topic, String)
	end)

	if not Success then
		warn(Error)
	else
		print("Removing")
		self:RemoveDelayed(Topic, String)
	end
	return Success
end

function MessagingHandler:PublishDelayedAsync(Topic, String)
	for Topic, Strings in DelayedMessages do
		for _, String in Strings do
			if not self:_Publish(Topic, String) then
				return
			end
		end
	end

	return true
end

function MessagingHandler:AddDelayed(Topic, String)
	DelayedMessages[Topic] = DelayedMessages[Topic] or {}
	if not table.find(DelayedMessages[Topic], String) then
		table.insert(DelayedMessages[Topic], String)
	end
end

function MessagingHandler:RemoveDelayed(Topic, String)
	if not DelayedMessages[Topic] then
		return
	end

	local FoundString = table.find(DelayedMessages[Topic], String)
	if FoundString then
		table.remove(DelayedMessages[Topic], FoundString)
	end
	if #DelayedMessages[Topic] <= 0 then
		DelayedMessages[Topic] = nil
	end
end

function MessagingHandler:PublishAsync(Topic, String)
	String = self:ProcessString(String)
	if not String then
		warn(`{script.Name}: Could not process string`)
		return
	end
	--warn('Encoded:',String)

	if not self:PublishDelayedAsync(Topic, String) then
		self:AddDelayed(Topic, String)
		return
	end

	local Success = self:_Publish(Topic, String)
	if Success then
		--print('Published!')
	end
end

function MessagingHandler:start() end

return MessagingHandler
