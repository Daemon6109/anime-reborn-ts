-- Compiled with roblox-ts v2.3.0
-- Performance monitoring utilities for data operations
local PerformanceMonitor
do
	PerformanceMonitor = setmetatable({}, {
		__tostring = function()
			return "PerformanceMonitor"
		end,
	})
	PerformanceMonitor.__index = PerformanceMonitor
	function PerformanceMonitor.new(...)
		local self = setmetatable({}, PerformanceMonitor)
		return self:constructor(...) or self
	end
	function PerformanceMonitor:constructor()
		self.enabled = false
		self.metrics = {}
	end
	function PerformanceMonitor:enable()
		self.enabled = true
	end
	function PerformanceMonitor:disable()
		self.enabled = false
	end
	function PerformanceMonitor:measure(name, operation)
		if not self.enabled then
			return operation()
		end
		local startTime = tick()
		local result = operation()
		local endTime = tick()
		local duration = endTime - startTime
		local _metrics = self.metrics
		local _arg0 = {
			name = name,
			duration = duration,
			timestamp = startTime,
		}
		table.insert(_metrics, _arg0)
		return result
	end
	function PerformanceMonitor:getMetrics()
		local _array = {}
		local _length = #_array
		local _array_1 = self.metrics
		table.move(_array_1, 1, #_array_1, _length + 1, _array)
		return _array
	end
	function PerformanceMonitor:clearMetrics()
		self.metrics = {}
	end
	function PerformanceMonitor:printReport()
		if #self.metrics == 0 then
			print("No performance metrics recorded")
			return nil
		end
		print("=== Performance Report ===")
		for _, metric in self.metrics do
			print(`{metric.name}: {metric.duration}ms at {metric.timestamp}`)
		end
		local _exp = self.metrics
		-- ▼ ReadonlyArray.reduce ▼
		local _result = 0
		local _callback = function(sum, metric)
			return sum + metric.duration
		end
		for _i = 1, #_exp do
			_result = _callback(_result, _exp[_i], _i - 1, _exp)
		end
		-- ▲ ReadonlyArray.reduce ▲
		local totalTime = _result
		local avgTime = totalTime / #self.metrics
		print(`Total time: {totalTime}ms, Average: {avgTime}ms`)
		print("========================")
	end
end
local performance = PerformanceMonitor.new()
return {
	performance = performance,
}
