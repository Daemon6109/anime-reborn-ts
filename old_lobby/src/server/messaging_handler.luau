--------------------------------------------------------------------------------
-- messaging_handler
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local HttpService = game:GetService("HttpService")
local MessagingService = game:GetService("MessagingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Messaging constants
local BASE_LIMIT = 10 -- Base messages per minute
local PLAYER_MULTIPLIER = 4 -- Additional messages per player

-- State tracking
local currentMinute = 0
local messagesSent = 0
local delayedMessages: { [string]: { string } } = {}
local isProcessingDelayed = false

--[=[
   Messaging service handler for managing cross-server communication.

   @class MessagingHandler
]=]
local MessagingHandler = {
	version = version,
}

--[=[
   Gets the current messaging limit based on player count

   @within MessagingHandler

   @return number -- The current messaging limit per minute

   ```lua
   local limit = MessagingHandler.getMessagesLimit()
   ```
]=]
function MessagingHandler.getMessagesLimit(): number
	return BASE_LIMIT + (PLAYER_MULTIPLIER * #Players:GetPlayers())
end

--[=[
   Gets the current minute timestamp

   @within MessagingHandler

   @return number -- The current minute

   ```lua
   local minute = MessagingHandler.getCurrentMinute()
   ```
]=]
function MessagingHandler.getCurrentMinute(): number
	return math.floor(DateTime.now().UnixTimestamp / 60)
end

--[=[
   Refreshes the message counter if we're in a new minute

   @within MessagingHandler

   ```lua
   MessagingHandler.refreshCounter()
   ```
]=]
function MessagingHandler.refreshCounter(): ()
	local minute = MessagingHandler.getCurrentMinute()
	if minute ~= currentMinute then
		currentMinute = minute
		messagesSent = 0
	end
end

--[=[
   Checks if we can publish a message without exceeding limits

   @within MessagingHandler

   @return boolean -- Whether we can publish a message

   ```lua
   if MessagingHandler.canPublish() then
       -- Send message
   end
   ```
]=]
function MessagingHandler.canPublish(): boolean
	MessagingHandler.refreshCounter()
	return (messagesSent + 1) <= MessagingHandler.getMessagesLimit()
end

--[=[
   Processes a value into a JSON string for messaging

   @within MessagingHandler

   @param value any -- The value to process

   @return string? -- The processed string or nil if failed

   ```lua
   local jsonString = MessagingHandler.processValue({ data = "test" })
   ```
]=]
function MessagingHandler.processValue(value: any): string?
	if value == nil then
		return nil
	end

	if type(value) == "string" then
		return value
	end

	local success, result = pcall(function()
		return HttpService:JSONEncode(value)
	end)

	if success then
		-- JSONEncode returns "null" for nil values, but we want to return nil
		if result == "null" then
			return nil
		end
		return result
	else
		warn(`MessagingHandler: Failed to encode value: {result}`)
		return nil
	end
end

--[=[
   Adds a message to the delayed queue

   @within MessagingHandler

   @param topic string -- The messaging topic
   @param message string -- The message to delay

   ```lua
   MessagingHandler.addDelayedMessage("PlayerData", jsonString)
   ```
]=]
function MessagingHandler.addDelayedMessage(topic: string, message: string): ()
	delayedMessages[topic] = delayedMessages[topic] or {}
	if not table.find(delayedMessages[topic], message) then
		table.insert(delayedMessages[topic], message)
	end
end

--[=[
   Removes a message from the delayed queue

   @within MessagingHandler

   @param topic string -- The messaging topic
   @param message string -- The message to remove

   ```lua
   MessagingHandler.removeDelayedMessage("PlayerData", jsonString)
   ```
]=]
function MessagingHandler.removeDelayedMessage(topic: string, message: string): ()
	if not delayedMessages[topic] then
		return
	end

	local index = table.find(delayedMessages[topic], message)
	if index then
		table.remove(delayedMessages[topic], index)
	end

	if #delayedMessages[topic] == 0 then
		delayedMessages[topic] = nil
	end
end

--[=[
   Publishes a single message immediately

   @within MessagingHandler

   @param topic string -- The messaging topic
   @param message string -- The message to publish

   @return boolean -- Whether the publish was successful

   ```lua
   local success = MessagingHandler.publishImmediate("PlayerData", jsonString)
   ```
]=]
function MessagingHandler.publishImmediate(topic: string, message: string): boolean
	if not MessagingHandler.canPublish() then
		return false
	end

	local success, error = pcall(function()
		MessagingService:PublishAsync(topic, message)
		messagesSent += 1
	end)

	if not success then
		warn(`MessagingHandler: Failed to publish to {topic}: {error}`)
		return false
	end

	return true
end

--[=[
   Processes all delayed messages

   @within MessagingHandler

   @return boolean -- Whether all delayed messages were processed

   ```lua
   local allProcessed = MessagingHandler.processDelayedMessages()
   ```
]=]
function MessagingHandler.processDelayedMessages(): boolean
	if isProcessingDelayed then
		return false
	end

	isProcessingDelayed = true

	for topic, messages in pairs(delayedMessages) do
		for i = #messages, 1, -1 do
			local message = messages[i]
			if MessagingHandler.publishImmediate(topic, message) then
				MessagingHandler.removeDelayedMessage(topic, message)
			else
				-- Can't send more this minute
				isProcessingDelayed = false
				return false
			end
		end
	end

	isProcessingDelayed = false
	return true
end

--[=[
   Publishes a message, queuing it if necessary

   @within MessagingHandler

   @param topic string -- The messaging topic
   @param value any -- The value to publish

   @return boolean -- Whether the message was sent immediately

   ```lua
   MessagingHandler.publishAsync("PlayerData", { userId = 123, action = "login" })
   ```
]=]
function MessagingHandler.publishAsync(topic: string, value: any): boolean
	local processedMessage = MessagingHandler.processValue(value)
	if not processedMessage then
		warn("MessagingHandler: Could not process message value")
		return false
	end

	-- Try to process any delayed messages first
	MessagingHandler.processDelayedMessages()

	-- Try to send this message
	if MessagingHandler.publishImmediate(topic, processedMessage) then
		return true
	else
		-- Queue for later
		MessagingHandler.addDelayedMessage(topic, processedMessage)
		return false
	end
end

--[=[
   Initializes the messaging handler

   @within MessagingHandler

   ```lua
   MessagingHandler.init()
   ```
]=]
function MessagingHandler.init(): ()
	-- Periodically try to process delayed messages
	RunService.Heartbeat:Connect(function(): ()
		if next(delayedMessages) then
			MessagingHandler.processDelayedMessages()
		end
	end)
end

return MessagingHandler
