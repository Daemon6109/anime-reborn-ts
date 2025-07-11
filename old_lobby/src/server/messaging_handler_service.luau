--------------------------------------------------------------------------------
-- messaging_handler_service
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")

local Network = require("@network/server")

--[=[
Service for handling cross-server messaging with rate limiting.

@class MessagingHandlerService
]=]
local MessagingHandlerService = {
	version = version,
}

-- State tracking
local messagesSentCounter = 0
local currentMinute = 0
local delayedMessages: { [string]: { string } } = {}

--[=[
Gets the current messaging limit based on player count.

@return number -- The current message limit per minute
]=]
function MessagingHandlerService.getMessagesLimit(): number
	return 10 -- Conservative limit: 600 + 240 * #Players:GetPlayers()
end

--[=[
Gets the current minute timestamp.

@return number -- Current minute as Unix timestamp
]=]
function MessagingHandlerService.getCurrentMinute(): number
	return math.floor(DateTime.now().UnixTimestamp / 60)
end

--[=[
Refreshes the message counter if we're in a new minute.
]=]
function MessagingHandlerService.refreshCounter()
	local newMinute = MessagingHandlerService.getCurrentMinute()
	if newMinute == currentMinute then
		return
	end
	currentMinute = newMinute
	messagesSentCounter = 0
end

--[=[
Checks if we can publish a message without exceeding rate limits.

@return boolean -- Whether a message can be published
]=]
function MessagingHandlerService.canPublish(): boolean
	MessagingHandlerService.refreshCounter()
	local canPublish = (messagesSentCounter + 1) < MessagingHandlerService.getMessagesLimit()
	return canPublish
end

--[=[
Processes a value into a JSON string for messaging.

@param value any -- The value to process
@return string? -- The JSON encoded string, or nil if encoding failed
]=]
function MessagingHandlerService.processValue(value: any): string?
	if typeof(value) == "string" then
		return value
	end

	local success, encoded = pcall(function()
		return HttpService:JSONEncode(value)
	end)

	if success then
		return encoded
	else
		warn("MessagingHandlerService: Failed to encode value -", encoded)
		return nil
	end
end

--[=[
Adds a message to the delayed queue.

@param topic string -- The topic to publish to
@param message string -- The message to delay
]=]
function MessagingHandlerService.addDelayedMessage(topic: string, message: string)
	delayedMessages[topic] = delayedMessages[topic] or {}
	if not table.find(delayedMessages[topic], message) then
		table.insert(delayedMessages[topic], message)
	end
end

--[=[
Removes a message from the delayed queue.

@param topic string -- The topic the message belongs to
@param message string -- The message to remove
]=]
function MessagingHandlerService.removeDelayedMessage(topic: string, message: string)
	if not delayedMessages[topic] then
		return
	end

	local index = table.find(delayedMessages[topic], message)
	if index then
		table.remove(delayedMessages[topic], index)
	end

	if #delayedMessages[topic] <= 0 then
		delayedMessages[topic] = nil
	end
end

--[=[
Internal function to publish a message.

@param topic string -- The topic to publish to
@param message string -- The message to publish
@return boolean -- Whether the message was published successfully
]=]
local function internalPublish(topic: string, message: string): boolean
	if not MessagingHandlerService.canPublish() then
		MessagingHandlerService.addDelayedMessage(topic, message)
		return false
	end

	local success, error = pcall(function()
		return MessagingService:PublishAsync(topic, message)
	end)

	if success then
		messagesSentCounter += 1
		MessagingHandlerService.removeDelayedMessage(topic, message)
		return true
	else
		warn("MessagingHandlerService: Failed to publish message -", error)
		return false
	end
end

--[=[
Publishes delayed messages.

@return boolean -- Whether all delayed messages were published
]=]
function MessagingHandlerService.publishDelayedMessages(): boolean
	for topic, messages in delayedMessages do
		for _, message in messages do
			if not internalPublish(topic, message) then
				return false
			end
		end
	end
	return true
end

--[=[
Publishes a message to a topic with rate limiting.

@param topic string -- The topic to publish to
@param value any -- The value to publish (will be JSON encoded if not a string)
@return boolean -- Whether the message was published successfully
]=]
function MessagingHandlerService.publishAsync(topic: string, value: any): boolean
	local message = MessagingHandlerService.processValue(value)
	if not message then
		warn("MessagingHandlerService: Could not process value for publishing")
		return false
	end

	-- Try to publish delayed messages first
	if not MessagingHandlerService.publishDelayedMessages() then
		MessagingHandlerService.addDelayedMessage(topic, message)
		return false
	end

	-- Try to publish the new message
	return internalPublish(topic, message)
end

--[=[
Subscribes to a topic and calls the callback when messages are received.

@param topic string -- The topic to subscribe to
@param callback function -- The callback to call when messages are received
@return RBXScriptConnection -- The connection object
]=]
function MessagingHandlerService.subscribeAsync(topic: string, callback: (any) -> ()): RBXScriptConnection
	return MessagingService:SubscribeAsync(topic, function(message)
		local success, result = pcall(function()
			return HttpService:JSONDecode(message.Data)
		end)

		if success then
			callback(result)
		else
			-- If not JSON, pass the raw data
			callback(message.Data)
		end
	end)
end

-- Register network handlers
Network.registerHandler("PublishMessage", MessagingHandlerService.publishAsync)

return MessagingHandlerService
