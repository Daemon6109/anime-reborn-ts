--------------------------------------------------------------------------------
-- performance_optimizer
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local Person = require("@commonserver/person")

local RunService = game:GetService("RunService")

--[=[
   Performance optimization module for batching operations and improving system efficiency.

   @class PerformanceOptimizer
]=]
local PerformanceOptimizer = {
	version = version,
}

-- Batching queues
local dataUpdateQueue = {}
local analyticsEventQueue = {}
local effectUpdateQueue = {}

-- Configuration
local BATCH_SIZE = 50
local BATCH_INTERVAL = 0.5 -- seconds
local MAX_OPERATIONS_PER_FRAME = 10

-- Performance monitoring
local performanceMetrics = {
	dataUpdatesProcessed = 0,
	analyticsEventsProcessed = 0,
	effectUpdatesProcessed = 0,
	averageFrameTime = 0,
	lastFrameTime = 0,
}

type EventData = {
	eventType: string,
	playerId: string,
	timestamp: number,
	customData: EventData,
}

type PerformanceMetrics = {
	dataUpdatesProcessed: number,
	analyticsEventsProcessed: number,
	effectUpdatesProcessed: number,
	averageFrameTime: number,
	currentFPS: number,
	queueSizes: {
		dataUpdates: number,
		analyticsEvents: number,
		effectUpdates: number,
	},
	maxOperationsPerFrame: number,
}

--[=[
   Adds a data update operation to the batch queue.

   @within PerformanceOptimizer

   @param person Person -- The person to update
   @param updateFunction (any) -> any -- The function to execute

   ```lua
   performance_optimizer.queueDataUpdate(person, function(dataCache)
	   -- Modify dataCache as needed
	   return dataCache
   end)
   ```
]=]
function PerformanceOptimizer:queueDataUpdate(person: Person.Person, updateFunction: (any) -> any): ()
	table.insert(dataUpdateQueue, {
		person = person,
		updateFunction = updateFunction,
		timestamp = tick(),
	})

	-- Process immediately if queue is full
	if #dataUpdateQueue >= BATCH_SIZE then
		self:processDataUpdateQueue()
	end
end

--[=[
   Adds an analytics event to the batch queue.

   @within PerformanceOptimizer

   @param eventData EventData -- The event data to track

   ```lua
   performance_optimizer.queueAnalyticsEvent({
	   eventType = "PlayerJoined",
	   playerId = "12345",
	   timestamp = os.time(),
	   customData = { someKey = "someValue" }
   })
   ```
]=]
function PerformanceOptimizer:queueAnalyticsEvent(eventData: EventData): ()
	table.insert(analyticsEventQueue, eventData)

	-- Process immediately if queue is full
	if #analyticsEventQueue >= BATCH_SIZE then
		self:processAnalyticsEventQueue()
	end
end

--[=[
   Adds an effect update to the batch queue.

   @within PerformanceOptimizer

   @param person Person -- The person to update effects for
   @param effectUpdates EventData -- The effect updates to apply

   ```lua
   performance_optimizer.queueEffectUpdate(person, {
	   effectId = {
		   duration = 60,
		   intensity = 1.5,
		   customData = { someKey = "someValue" }
	   }
		   })
   ```
]=]
function PerformanceOptimizer:queueEffectUpdate(person: Person.Person, effectUpdates: EventData): ()
	table.insert(effectUpdateQueue, {
		person = person,
		effectUpdates = effectUpdates,
		timestamp = tick(),
	})

	-- Process immediately if queue is full
	if #effectUpdateQueue >= BATCH_SIZE then
		self:processEffectUpdateQueue()
	end
end

--[=[
   Processes the data update queue.

   @within PerformanceOptimizer

   @private

   ```lua
   performance_optimizer.processDataUpdateQueue()
   ```
]=]
function PerformanceOptimizer:processDataUpdateQueue(): ()
	if #dataUpdateQueue == 0 then
		return
	end

	local startTime = tick()
	local processedCount = 0

	-- Process updates in batches to avoid frame drops
	for i = 1, math.min(#dataUpdateQueue, MAX_OPERATIONS_PER_FRAME) do
		local update = dataUpdateQueue[i]

		-- Check if person is still valid
		if update.person and update.person.player.Parent then
			local success, err = pcall(function()
				update.person.dataCache(update.updateFunction)
			end)

			if not success then
				warn(`Failed to process data update: {err}`)
			else
				processedCount = processedCount + 1
			end
		end
	end

	-- Remove processed updates
	for i = MAX_OPERATIONS_PER_FRAME, 1, -1 do
		if dataUpdateQueue[i] then
			table.remove(dataUpdateQueue, i)
		end
	end

	-- Update metrics
	performanceMetrics.dataUpdatesProcessed = performanceMetrics.dataUpdatesProcessed + processedCount
	performanceMetrics.lastFrameTime = tick() - startTime
end

--[=[
   Processes the analytics event queue.

   @within PerformanceOptimizer

   @private

   ```lua
   performance_optimizer.processAnalyticsEventQueue()
   ```
]=]
function PerformanceOptimizer:processAnalyticsEventQueue(): ()
	if #analyticsEventQueue == 0 then
		return
	end

	-- Batch process analytics events
	local eventsToProcess = table.clone(analyticsEventQueue)
	table.clear(analyticsEventQueue)

	task.spawn(function()
		for _, eventData in ipairs(eventsToProcess) do
			-- Process analytics event (this would integrate with the Analytics module)
			-- For now, just count them
			performanceMetrics.analyticsEventsProcessed = performanceMetrics.analyticsEventsProcessed + 1
		end
	end)
end

--[=[
   Processes the effect update queue.

   @within PerformanceOptimizer

   @private

   ```lua
   performance_optimizer.processEffectUpdateQueue()
   ```
]=]
function PerformanceOptimizer:processEffectUpdateQueue(): ()
	if #effectUpdateQueue == 0 then
		return
	end

	-- local _startTime = tick()
	local processedCount = 0

	-- Process effect updates in batches
	for i = 1, math.min(#effectUpdateQueue, MAX_OPERATIONS_PER_FRAME) do
		local update = effectUpdateQueue[i]

		-- Check if person is still valid
		if update.person and update.person.player.Parent then
			local success, err = pcall(function()
				update.person.dataCache(function(dataCache)
					local newDataCache = table.clone(dataCache)

					-- Apply effect updates
					for effectId, effectData in pairs(update.effectUpdates) do
						newDataCache.Effects[effectId] = effectData
					end

					return newDataCache
				end)
			end)

			if not success then
				warn(`Failed to process effect update: {err}`)
			else
				processedCount = processedCount + 1
			end
		end
	end

	-- Remove processed updates
	for i = MAX_OPERATIONS_PER_FRAME, 1, -1 do
		if effectUpdateQueue[i] then
			table.remove(effectUpdateQueue, i)
		end
	end

	-- Update metrics
	performanceMetrics.effectUpdatesProcessed = performanceMetrics.effectUpdatesProcessed + processedCount
end

--[=[
   Monitors frame time and adjusts batch sizes accordingly.

   @within PerformanceOptimizer

   @private

   ```lua
   local connection = performance_optimizer.monitorPerformance()
   --   -- To stop monitoring, call connection:Disconnect()
   --   connection:Disconnect()
   --
   ```
]=]
function PerformanceOptimizer:monitorPerformance(): ()
	local connection
	connection = RunService.Heartbeat:Connect(function(deltaTime): ()
		-- Update average frame time
		performanceMetrics.averageFrameTime = (performanceMetrics.averageFrameTime * 0.9) + (deltaTime * 0.1)

		-- Adjust batch processing based on frame time
		if performanceMetrics.averageFrameTime > 1 / 30 then -- If below 30 FPS
			-- Reduce operations per frame
			MAX_OPERATIONS_PER_FRAME = math.max(5, MAX_OPERATIONS_PER_FRAME - 1)
		elseif performanceMetrics.averageFrameTime < 1 / 60 then -- If above 60 FPS
			-- Increase operations per frame
			MAX_OPERATIONS_PER_FRAME = math.min(20, MAX_OPERATIONS_PER_FRAME + 1)
		end
	end)

	return connection
end

--[=[
   Gets current performance metrics.

   @within PerformanceOptimizer

   @return PerformanceMetrics -- Performance metrics

   ```lua
   local metrics = performance_optimizer.getPerformanceMetrics()
   print(`Data Updates Processed: {metrics.dataUpdatesProcessed}`)
   print(`Analytics Events Processed: {metrics.analyticsEventsProcessed}`)
   print(`Effect Updates Processed: {metrics.effectUpdatesProcessed}`)
   print(`Average Frame Time: {math.floor(metrics.averageFrameTime * 1000)}ms`)
   print(`Current FPS: {math.floor(metrics.currentFPS)}`)
   print(`Queue Sizes: Data={metrics.queueSizes.dataUpdates}, Analytics={metrics.queueSizes.analyticsEvents}, Effects={metrics.queueSizes.effectUpdates}`)
   ```
]=]
function PerformanceOptimizer:getPerformanceMetrics(): PerformanceMetrics
	return {
		dataUpdatesProcessed = performanceMetrics.dataUpdatesProcessed,
		analyticsEventsProcessed = performanceMetrics.analyticsEventsProcessed,
		effectUpdatesProcessed = performanceMetrics.effectUpdatesProcessed,
		averageFrameTime = performanceMetrics.averageFrameTime,
		currentFPS = 1 / math.max(performanceMetrics.averageFrameTime, 0.001),
		queueSizes = {
			dataUpdates = #dataUpdateQueue,
			analyticsEvents = #analyticsEventQueue,
			effectUpdates = #effectUpdateQueue,
		},
		maxOperationsPerFrame = MAX_OPERATIONS_PER_FRAME,
	}
end

--[=[
   Prints a performance report.

   ```lua
   performance_optimizer.printPerformanceReport()
   ```
]=]
function PerformanceOptimizer:printPerformanceReport(): ()
	local metrics = PerformanceOptimizer:getPerformanceMetrics()

	print("📊 Performance Optimizer Report:")
	print(`   Data Updates Processed: {metrics.dataUpdatesProcessed}`)
	print(`   Analytics Events Processed: {metrics.analyticsEventsProcessed}`)
	print(`   Effect Updates Processed: {metrics.effectUpdatesProcessed}`)
	print(`   Average Frame Time: {math.floor(metrics.averageFrameTime * 1000)}ms`)
	print(`   Current FPS: {math.floor(metrics.currentFPS)}`)
	print(
		`   Queue Sizes: Data={metrics.queueSizes.dataUpdates}, Analytics={metrics.queueSizes.analyticsEvents}, Effects={metrics.queueSizes.effectUpdates}`
	)
	print(`   Max Operations/Frame: {metrics.maxOperationsPerFrame}`)
end

--[=[
   This function is used to start the provider and initialize any necessary systems.

   ```lua
   performance_optimizer.start()
   ```
]=]
local function start(): ()
	-- Start performance monitoring
	PerformanceOptimizer:monitorPerformance()

	-- Set up periodic queue processing
	task.spawn(function()
		while true do
			task.wait(BATCH_INTERVAL)

			-- Process all queues
			PerformanceOptimizer:processDataUpdateQueue()
			PerformanceOptimizer:processAnalyticsEventQueue()
			PerformanceOptimizer:processEffectUpdateQueue()
		end
	end)

	-- Set up periodic performance reporting (in Studio only)
	if RunService:IsStudio() then
		task.spawn(function()
			while true do
				task.wait(60) -- Report every minute
				PerformanceOptimizer:printPerformanceReport()
			end
		end)
	end

	print("⚡ Performance optimizer started")
end

return {
	version = version,
	order = 1, -- Initialize early

	-- Functions
	start = start,
	queueDataUpdate = PerformanceOptimizer.queueDataUpdate,
	queueAnalyticsEvent = PerformanceOptimizer.queueAnalyticsEvent,
	queueEffectUpdate = PerformanceOptimizer.queueEffectUpdate,
	getPerformanceMetrics = PerformanceOptimizer.getPerformanceMetrics,
	printPerformanceReport = PerformanceOptimizer.printPerformanceReport,
}
