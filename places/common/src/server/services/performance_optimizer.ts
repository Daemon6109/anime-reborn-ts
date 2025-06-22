// performance_optimizer
--------------------------------------------------------------------------------

import { Person } from "@commonserver/person";
import { RunService } from "@rbxts/services";
import { t } from "@rbxts/t";

const version = { major: 1, minor: 0, patch: 0 };

//[=[
//   Performance optimization module for batching operations and improving system efficiency.
//
//   @class PerformanceOptimizer
//]=]

// Batching queues
interface DataUpdateOperation {
	person: Person;
	updateFunction: (dataCache: any) => any;
	timestamp: number;
}
const dataUpdateQueue: DataUpdateOperation[] = [];

interface AnalyticsEvent {
	eventType: string;
	playerId: string;
	timestamp: number;
	customData: Record<string, unknown>;
}
const analyticsEventQueue: AnalyticsEvent[] = [];

interface EffectUpdateOperation {
	person: Person;
	effectUpdates: Record<string, unknown>;
	timestamp: number;
}
const effectUpdateQueue: EffectUpdateOperation[] = [];

// Configuration
const BATCH_SIZE = 50;
const BATCH_INTERVAL = 0.5; // seconds
let MAX_OPERATIONS_PER_FRAME = 10;

// Performance monitoring
const performanceMetrics = {
	dataUpdatesProcessed: 0,
	analyticsEventsProcessed: 0,
	effectUpdatesProcessed: 0,
	averageFrameTime: 0,
	lastFrameTime: 0,
};

export interface PerformanceMetrics {
	dataUpdatesProcessed: number;
	analyticsEventsProcessed: number;
	effectUpdatesProcessed: number;
	averageFrameTime: number;
	currentFPS: number;
	queueSizes: {
		dataUpdates: number;
		analyticsEvents: number;
		effectUpdates: number;
	};
	maxOperationsPerFrame: number;
}

const PerformanceOptimizer = {
	version: version,

	//[=[
	//   Adds a data update operation to the batch queue.
	//
	//   @within PerformanceOptimizer
	//
	//   @param person Person -- The person to update
	//   @param updateFunction (any) => any -- The function to execute
	//
	//   ```ts
	//   PerformanceOptimizer.queueDataUpdate(person, (dataCache) => {
	// 	   // Modify dataCache as needed
	// 	   return dataCache;
	//   });
	//   ```
	//]=]
	queueDataUpdate(person: Person, updateFunction: (dataCache: any) => any): void {
		dataUpdateQueue.push({
			person: person,
			updateFunction: updateFunction,
			timestamp: tick(),
		});

		// Process immediately if queue is full
		if (dataUpdateQueue.size() >= BATCH_SIZE) {
			this.processDataUpdateQueue();
		}
	},

	//[=[
	//   Adds an analytics event to the batch queue.
	//
	//   @within PerformanceOptimizer
	//
	//   @param eventData AnalyticsEvent -- The event data to track
	//
	//   ```ts
	//   PerformanceOptimizer.queueAnalyticsEvent({
	// 	   eventType: "PlayerJoined",
	// 	   playerId: "12345",
	// 	   timestamp: os.time(),
	// 	   customData: { someKey: "someValue" }
	//   });
	//   ```
	//]=]
	queueAnalyticsEvent(eventData: AnalyticsEvent): void {
		analyticsEventQueue.push(eventData);

		// Process immediately if queue is full
		if (analyticsEventQueue.size() >= BATCH_SIZE) {
			this.processAnalyticsEventQueue();
		}
	},

	//[=[
	//   Adds an effect update to the batch queue.
	//
	//   @within PerformanceOptimizer
	//
	//   @param person Person -- The person to update effects for
	//   @param effectUpdates Record<string, unknown> -- The effect updates to apply
	//
	//   ```ts
	//   PerformanceOptimizer.queueEffectUpdate(person, {
	// 	   effectId: {
	// 		   duration: 60,
	// 		   intensity: 1.5,
	// 		   customData: { someKey: "someValue" }
	// 	   }
	//   });
	//   ```
	//]=]
	queueEffectUpdate(person: Person, effectUpdates: Record<string, unknown>): void {
		effectUpdateQueue.push({
			person: person,
			effectUpdates: effectUpdates,
			timestamp: tick(),
		});

		// Process immediately if queue is full
		if (effectUpdateQueue.size() >= BATCH_SIZE) {
			this.processEffectUpdateQueue();
		}
	},

	//[=[
	//   Processes the data update queue.
	//
	//   @within PerformanceOptimizer
	//
	//   @private
	//
	//   ```ts
	//   PerformanceOptimizer.processDataUpdateQueue();
	//   ```
	//]=]
	processDataUpdateQueue(): void {
		if (dataUpdateQueue.size() === 0) {
			return;
		}

		const startTime = tick();
		let processedCount = 0;

		// Process updates in batches to avoid frame drops
		const operationsToProcess = Math.min(dataUpdateQueue.size(), MAX_OPERATIONS_PER_FRAME);
		for (let i = 0; i < operationsToProcess; i++) {
			const update = dataUpdateQueue.shift(); // Get and remove the first element
			if (!update) continue;


			// Check if person is still valid
			if (update.person && update.person.player.IsDescendantOf(Players)) {
				const [success, err] = pcall(() => {
					update.person.dataCache(update.updateFunction);
				});

				if (!success) {
					warn(`Failed to process data update: ${err}`);
				} else {
					processedCount++;
				}
			}
		}

		// Update metrics
		performanceMetrics.dataUpdatesProcessed += processedCount;
		performanceMetrics.lastFrameTime = tick() - startTime;
	},

	//[=[
	//   Processes the analytics event queue.
	//
	//   @within PerformanceOptimizer
	//
	//   @private
	//
	//   ```ts
	//   PerformanceOptimizer.processAnalyticsEventQueue();
	//   ```
	//]=]
	processAnalyticsEventQueue(): void {
		if (analyticsEventQueue.size() === 0) {
			return;
		}

		// Batch process analytics events
		const eventsToProcess = [...analyticsEventQueue];
		analyticsEventQueue.clear();

		task.spawn(() => {
			for (const eventData of eventsToProcess) {
				// Process analytics event (this would integrate with the Analytics module)
				// For now, just count them
				performanceMetrics.analyticsEventsProcessed++;
			}
		});
	},

	//[=[
	//   Processes the effect update queue.
	//
	//   @within PerformanceOptimizer
	//
	//   @private
	//
	//   ```ts
	//   PerformanceOptimizer.processEffectUpdateQueue();
	//   ```
	//]=]
	processEffectUpdateQueue(): void {
		if (effectUpdateQueue.size() === 0) {
			return;
		}

		// const _startTime = tick();
		let processedCount = 0;

		// Process effect updates in batches
		const operationsToProcess = Math.min(effectUpdateQueue.size(), MAX_OPERATIONS_PER_FRAME);
		for (let i = 0; i < operationsToProcess; i++) {
			const update = effectUpdateQueue.shift(); // Get and remove the first element
			if(!update) continue;

			// Check if person is still valid
			if (update.person && update.person.player.IsDescendantOf(Players)) {
				const [success, err] = pcall(() => {
					update.person.dataCache((dataCache: { Effects: Record<string, unknown> }) => {
						const newDataCache = { ...dataCache };

						// Apply effect updates
						for (const [effectId, effectData] of pairs(update.effectUpdates)) {
							newDataCache.Effects[effectId as string] = effectData;
						}

						return newDataCache;
					});
				});

				if (!success) {
					warn(`Failed to process effect update: ${err}`);
				} else {
					processedCount++;
				}
			}
		}

		// Update metrics
		performanceMetrics.effectUpdatesProcessed += processedCount;
	},

	//[=[
	//   Monitors frame time and adjusts batch sizes accordingly.
	//
	//   @within PerformanceOptimizer
	//
	//   @private
	//
	//   ```ts
	//   const connection = PerformanceOptimizer.monitorPerformance();
	//   //   -- To stop monitoring, call connection.Disconnect()
	//   //   connection.Disconnect();
	//   //
	//   ```
	//]=]
	monitorPerformance(): RBXScriptConnection {
		const connection = RunService.Heartbeat.Connect((deltaTime) => {
			// Update average frame time
			performanceMetrics.averageFrameTime = performanceMetrics.averageFrameTime * 0.9 + deltaTime * 0.1;

			// Adjust batch processing based on frame time
			if (performanceMetrics.averageFrameTime > 1 / 30) {
				// If below 30 FPS
				// Reduce operations per frame
				MAX_OPERATIONS_PER_FRAME = Math.max(5, MAX_OPERATIONS_PER_FRAME - 1);
			} else if (performanceMetrics.averageFrameTime < 1 / 60) {
				// If above 60 FPS
				// Increase operations per frame
				MAX_OPERATIONS_PER_FRAME = Math.min(20, MAX_OPERATIONS_PER_FRAME + 1);
			}
		});

		return connection;
	},

	//[=[
	//   Gets current performance metrics.
	//
	//   @within PerformanceOptimizer
	//
	//   @return PerformanceMetrics -- Performance metrics
	//
	//   ```ts
	//   const metrics = PerformanceOptimizer.getPerformanceMetrics();
	//   print(`Data Updates Processed: ${metrics.dataUpdatesProcessed}`);
	//   print(`Analytics Events Processed: ${metrics.analyticsEventsProcessed}`);
	//   print(`Effect Updates Processed: ${metrics.effectUpdatesProcessed}`);
	//   print(`Average Frame Time: ${Math.floor(metrics.averageFrameTime * 1000)}ms`);
	//   print(`Current FPS: ${Math.floor(metrics.currentFPS)}`);
	//   print(`Queue Sizes: Data=${metrics.queueSizes.dataUpdates}, Analytics=${metrics.queueSizes.analyticsEvents}, Effects=${metrics.queueSizes.effectUpdates}`);
	//   ```
	//]=]
	getPerformanceMetrics(): PerformanceMetrics {
		return {
			dataUpdatesProcessed: performanceMetrics.dataUpdatesProcessed,
			analyticsEventsProcessed: performanceMetrics.analyticsEventsProcessed,
			effectUpdatesProcessed: performanceMetrics.effectUpdatesProcessed,
			averageFrameTime: performanceMetrics.averageFrameTime,
			currentFPS: 1 / Math.max(performanceMetrics.averageFrameTime, 0.001),
			queueSizes: {
				dataUpdates: dataUpdateQueue.size(),
				analyticsEvents: analyticsEventQueue.size(),
				effectUpdates: effectUpdateQueue.size(),
			},
			maxOperationsPerFrame: MAX_OPERATIONS_PER_FRAME,
		};
	},

	//[=[
	//   Prints a performance report.
	//
	//   ```ts
	//   PerformanceOptimizer.printPerformanceReport();
	//   ```
	//]=]
	printPerformanceReport(): void {
		const metrics = PerformanceOptimizer.getPerformanceMetrics();

		print("📊 Performance Optimizer Report:");
		print(`   Data Updates Processed: ${metrics.dataUpdatesProcessed}`);
		print(`   Analytics Events Processed: ${metrics.analyticsEventsProcessed}`);
		print(`   Effect Updates Processed: ${metrics.effectUpdatesProcessed}`);
		print(`   Average Frame Time: ${Math.floor(metrics.averageFrameTime * 1000)}ms`);
		print(`   Current FPS: ${Math.floor(metrics.currentFPS)}`);
		print(
			`   Queue Sizes: Data=${metrics.queueSizes.dataUpdates}, Analytics=${metrics.queueSizes.analyticsEvents}, Effects=${metrics.queueSizes.effectUpdates}`,
		);
		print(`   Max Operations/Frame: ${metrics.maxOperationsPerFrame}`);
	},
};

//[=[
//   This function is used to start the provider and initialize any necessary systems.
//
//   ```ts
//   start();
//   ```
//]=]
function start(): void {
	// Start performance monitoring
	PerformanceOptimizer.monitorPerformance();

	// Set up periodic queue processing
	task.spawn(() => {
		while (true) {
			task.wait(BATCH_INTERVAL);

			// Process all queues
			PerformanceOptimizer.processDataUpdateQueue();
			PerformanceOptimizer.processAnalyticsEventQueue();
			PerformanceOptimizer.processEffectUpdateQueue();
		}
	});

	// Set up periodic performance reporting (in Studio only)
	if (RunService.IsStudio()) {
		task.spawn(() => {
			while (true) {
				task.wait(60); // Report every minute
				PerformanceOptimizer.printPerformanceReport();
			}
		});
	}

	print("⚡ Performance optimizer started");
}

export default {
	version: version,
	order: 1, // Initialize early

	// Functions
	start: start,
	queueDataUpdate: PerformanceOptimizer.queueDataUpdate,
	queueAnalyticsEvent: PerformanceOptimizer.queueAnalyticsEvent,
	queueEffectUpdate: PerformanceOptimizer.queueEffectUpdate,
	getPerformanceMetrics: PerformanceOptimizer.getPerformanceMetrics,
	printPerformanceReport: PerformanceOptimizer.printPerformanceReport,
};
