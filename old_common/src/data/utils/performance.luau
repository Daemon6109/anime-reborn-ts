--------------------------------------------------------------------------------
-- Data Performance Monitoring

-- This module provides utilities for monitoring the performance of data operations,
-- helping identify bottlenecks or inefficiencies in the data system.
--------------------------------------------------------------------------------

local PerformanceMonitor = {
	_metrics = {},
	_enabled = false,
}

--[=[
	Enables performance monitoring. Call this before any data operations to start tracking performance.
]=]
function PerformanceMonitor.enable(): ()
	PerformanceMonitor._enabled = true
	PerformanceMonitor._metrics = {}
end

--[=[
	Disables performance monitoring. Call this when you no longer need to track performance.
]=]
function PerformanceMonitor.disable(): ()
	PerformanceMonitor._enabled = false
end

--[=[
	Checks if performance monitoring is enabled.
	@return boolean - True if performance monitoring is enabled, false otherwise.
]=]
function PerformanceMonitor.isEnabled(): boolean
	return PerformanceMonitor._enabled
end

--[=[
	Measures the performance of a function call.
	@param name string - The name of the operation being measured.
	@param callback (...any) -> ...any, ...: any) - The function to be measured.
	@return ...any - The result of the callback function.
]=]
function PerformanceMonitor.measure(name: string, callback: (...any) -> ...any, ...: any): ...any
	if not PerformanceMonitor._enabled then
		return callback(...)
	end

	local startTime = os.clock()
	local results = { callback(...) }
	local endTime = os.clock()
	local elapsed = endTime - startTime

	if not PerformanceMonitor._metrics[name] then
		PerformanceMonitor._metrics[name] = {
			totalTime = 0,
			callCount = 0,
			minTime = math.huge,
			maxTime = 0,
		}
	end

	local metric = PerformanceMonitor._metrics[name]
	metric.totalTime += elapsed
	metric.callCount += 1
	metric.minTime = math.min(metric.minTime, elapsed)
	metric.maxTime = math.max(metric.maxTime, elapsed)

	return table.unpack(results)
end

--[=[
	Warp a function to measure its performance.
	@param name string - The name of the operation being measured.
	@param func (...any) -> ...any - The function to be wrapped.
	@return (...any) -> ...any - The wrapped function that measures performance.
]=]
function PerformanceMonitor.wrapFunction(name: string, func: (...any) -> ...any): (...any) -> ...any
	return function(...)
		return PerformanceMonitor.measure(name, func, ...)
	end
end

--[=[
	Retrieves the performance metrics collected so far.
	@return { [string]: { totalTime: number, callCount: number, averageTime: number, minTime: number, maxTime: number } }
]=]
function PerformanceMonitor.getMetrics(): {
	[string]: { totalTime: number, callCount: number, averageTime: number, minTime: number, maxTime: number },
}
	local metrics = {}

	for name, data in pairs(PerformanceMonitor._metrics) do
		metrics[name] = {
			totalTime = data.totalTime,
			callCount = data.callCount,
			averageTime = data.callCount > 0 and data.totalTime / data.callCount or 0,
			minTime = data.minTime ~= math.huge and data.minTime or 0,
			maxTime = data.maxTime,
		}
	end

	return metrics
end

--[=[
	Prints a performance report to the console.
	Includes total time, average time, min time, and max time for each operation.
]=]
function PerformanceMonitor.printReport(): ()
	if not PerformanceMonitor._enabled then
		print("Performance monitoring is disabled. Enable it with PerformanceMonitor.enable()")
		return
	end

	local metrics = PerformanceMonitor.getMetrics()
	local names = {}

	for name, _ in pairs(metrics) do
		table.insert(names, name)
	end

	table.sort(names, function(a, b)
		return metrics[a].totalTime > metrics[b].totalTime
	end)

	print("=== Data System Performance Report ===")
	print("Operation                    | Count |  Total  | Average | Min  | Max")
	print("------------------------------|-------|---------|---------|------|------")

	for _, name in ipairs(names) do
		local metric = metrics[name]
		print(
			string.format(
				"%-30s| %5d | %7.3fms | %7.3fms | %4.3fms | %5.3fms",
				name,
				metric.callCount,
				metric.totalTime * 1000,
				metric.averageTime * 1000,
				metric.minTime * 1000,
				metric.maxTime * 1000
			)
		)
	end

	print("=====================================")
end

--[=[
	Resets the performance metrics.
	Call this to clear all collected data.
]=]
function PerformanceMonitor.reset(): ()
	PerformanceMonitor._metrics = {}
end

--[=[
	Wrap common operations for monitoring
	@param factoryModules { [string]: () -> any } - A table of factory functions to be monitored.
	@return { [string]: () -> any } - A table of wrapped factory functions.
]=]
local function createMonitoredFactories(factoryModules: { [string]: () -> any }): { [string]: () -> any }
	local wrappedFactories = {}

	for name, factory in pairs(factoryModules) do
		wrappedFactories[name] = PerformanceMonitor.wrapFunction("factory:" .. name, factory)
	end

	return wrappedFactories
end

--[=[
	Example usage of the performance monitoring system.
	Wrap factory functions to monitor their performance.

	```lua
	-- Example usage:
	local factories = {
		playerBasicData = require("./factories/player/playerbasicdata"),
		inventory = require("./factories/inventory/inventorydata"),
	}

	local monitoredFactories = PerformanceMonitor.createMonitoredFactories(factories)
	local playerData = monitoredFactories.playerBasicData()
	local inventoryData = monitoredFactories.inventory()

	PerformanceMonitor.printReport()
	```
]=]
return {
	enable = PerformanceMonitor.enable,
	disable = PerformanceMonitor.disable,
	isEnabled = PerformanceMonitor.isEnabled,
	measure = PerformanceMonitor.measure,
	wrapFunction = PerformanceMonitor.wrapFunction,
	getMetrics = PerformanceMonitor.getMetrics,
	printReport = PerformanceMonitor.printReport,
	reset = PerformanceMonitor.reset,
	createMonitoredFactories = createMonitoredFactories,
}
