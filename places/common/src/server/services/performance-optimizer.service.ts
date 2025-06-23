import { OnStart, Service } from "@flamework/core";
import { RunService } from "@rbxts/services";

// Placeholder types and interfaces (to be properly defined later)
interface Person {
	player: Player;
	dataCache: (fn?: (data: DataCache) => DataCache) => DataCache;
}

interface DataCache {
	[key: string]: unknown;
	Effects: Record<string, unknown>;
}

// Mock Person module
const Person = {
	getForPlayer: (player: Player): Person | undefined => {
		// Mock implementation - would be replaced with actual Person module
		return undefined;
	},
};

interface EventData {
	eventType: string;
	playerId: string;
	timestamp: number;
	customData: Record<string, unknown>;
}

interface DataUpdateOperation {
	person: Person;
	updateFunction: (dataCache: DataCache) => DataCache;
	timestamp: number;
}

interface EffectUpdateOperation {
	person: Person;
	effectUpdates: Record<string, unknown>;
	timestamp: number;
}

interface PerformanceMetrics {
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

/**
 * Performance optimization module for batching operations and improving system efficiency.
 */
@Service({})
export class PerformanceOptimizerService implements OnStart {
	public readonly version = { major: 1, minor: 0, patch: 0 };

	// Batching queues
	private readonly dataUpdateQueue: DataUpdateOperation[] = [];
	private readonly analyticsEventQueue: EventData[] = [];
	private readonly effectUpdateQueue: EffectUpdateOperation[] = [];

	// Configuration
	private readonly BATCH_SIZE = 50;
	private readonly BATCH_INTERVAL = 0.5; // seconds
	private maxOperationsPerFrame = 10;

	// Performance monitoring
	private readonly performanceMetrics = {
		dataUpdatesProcessed: 0,
		analyticsEventsProcessed: 0,
		effectUpdatesProcessed: 0,
		averageFrameTime: 0,
		lastFrameTime: 0,
	};

	onStart(): void {
		this.startPerformanceMonitoring();
		this.startPeriodicQueueProcessing();
		this.startPerformanceReporting();
		print("⚡ Performance optimizer started");
	}

	/**
	 * Adds a data update operation to the batch queue
	 */
	public queueDataUpdate(person: Person, updateFunction: (dataCache: DataCache) => DataCache): void {
		this.dataUpdateQueue.push({
			person,
			updateFunction,
			timestamp: tick(),
		});

		// Process immediately if queue is full
		if (this.dataUpdateQueue.size() >= this.BATCH_SIZE) {
			this.processDataUpdateQueue();
		}
	}

	/**
	 * Adds an analytics event to the batch queue
	 */
	public queueAnalyticsEvent(eventData: EventData): void {
		this.analyticsEventQueue.push(eventData);

		// Process immediately if queue is full
		if (this.analyticsEventQueue.size() >= this.BATCH_SIZE) {
			this.processAnalyticsEventQueue();
		}
	}

	/**
	 * Adds an effect update to the batch queue
	 */
	public queueEffectUpdate(person: Person, effectUpdates: Record<string, unknown>): void {
		this.effectUpdateQueue.push({
			person,
			effectUpdates,
			timestamp: tick(),
		});

		// Process immediately if queue is full
		if (this.effectUpdateQueue.size() >= this.BATCH_SIZE) {
			this.processEffectUpdateQueue();
		}
	}

	/**
	 * Processes the data update queue
	 */
	public processDataUpdateQueue(): void {
		if (this.dataUpdateQueue.size() === 0) {
			return;
		}

		const startTime = tick();
		let processedCount = 0;

		// Process updates in batches to avoid frame drops
		const operationsToProcess = math.min(this.dataUpdateQueue.size(), this.maxOperationsPerFrame);
		for (let i = 0; i < operationsToProcess; i++) {
			const update = this.dataUpdateQueue[i];
			if (update === undefined) continue;

			// Check if person is still valid
			if (update.person.player.Parent !== undefined) {
				const [success, err] = pcall(() => {
					update.person.dataCache(update.updateFunction);
				});

				if (!success) {
					warn(`Failed to process data update: ${err}`);
				} else {
					processedCount = processedCount + 1;
				}
			}
		}

		// Remove processed updates
		for (let i = operationsToProcess - 1; i >= 0; i--) {
			this.dataUpdateQueue.remove(i);
		}

		// Update metrics
		this.performanceMetrics.dataUpdatesProcessed = this.performanceMetrics.dataUpdatesProcessed + processedCount;
		this.performanceMetrics.lastFrameTime = tick() - startTime;
	}

	/**
	 * Processes the analytics event queue
	 */
	public processAnalyticsEventQueue(): void {
		if (this.analyticsEventQueue.size() === 0) {
			return;
		}

		// Batch process analytics events
		const eventsToProcess = [...this.analyticsEventQueue];
		this.analyticsEventQueue.clear();

		task.spawn(() => {
			for (const eventData of eventsToProcess) {
				// Process analytics event (this would integrate with the Analytics module)
				// For now, just count them
				this.performanceMetrics.analyticsEventsProcessed = this.performanceMetrics.analyticsEventsProcessed + 1;
			}
		});
	}

	/**
	 * Processes the effect update queue
	 */
	public processEffectUpdateQueue(): void {
		if (this.effectUpdateQueue.size() === 0) {
			return;
		}

		let processedCount = 0;

		// Process effect updates in batches
		const operationsToProcess = math.min(this.effectUpdateQueue.size(), this.maxOperationsPerFrame);
		for (let i = 0; i < operationsToProcess; i++) {
			const update = this.effectUpdateQueue[i];
			if (update === undefined) continue;

			// Check if person is still valid
			if (update.person.player.Parent !== undefined) {
				const [success, err] = pcall(() => {
					update.person.dataCache((dataCache) => {
						const newDataCache = { ...dataCache };

						// Apply effect updates
						for (const [effectId, effectData] of pairs(update.effectUpdates)) {
							newDataCache.Effects[effectId] = effectData;
						}

						return newDataCache;
					});
				});

				if (!success) {
					warn(`Failed to process effect update: ${err}`);
				} else {
					processedCount = processedCount + 1;
				}
			}
		}

		// Remove processed updates
		for (let i = operationsToProcess - 1; i >= 0; i--) {
			this.effectUpdateQueue.remove(i);
		}

		// Update metrics
		this.performanceMetrics.effectUpdatesProcessed =
			this.performanceMetrics.effectUpdatesProcessed + processedCount;
	}

	/**
	 * Monitors frame time and adjusts batch sizes accordingly
	 */
	private startPerformanceMonitoring(): void {
		RunService.Heartbeat.Connect((deltaTime) => {
			// Update average frame time
			this.performanceMetrics.averageFrameTime = this.performanceMetrics.averageFrameTime * 0.9 + deltaTime * 0.1;

			// Adjust batch processing based on frame time
			if (this.performanceMetrics.averageFrameTime > 1 / 30) {
				// If below 30 FPS - Reduce operations per frame
				this.maxOperationsPerFrame = math.max(5, this.maxOperationsPerFrame - 1);
			} else if (this.performanceMetrics.averageFrameTime < 1 / 60) {
				// If above 60 FPS - Increase operations per frame
				this.maxOperationsPerFrame = math.min(20, this.maxOperationsPerFrame + 1);
			}
		});
	}

	/**
	 * Sets up periodic queue processing
	 */
	private startPeriodicQueueProcessing(): void {
		task.spawn(() => {
			for (;;) {
				task.wait(this.BATCH_INTERVAL);

				// Process all queues
				this.processDataUpdateQueue();
				this.processAnalyticsEventQueue();
				this.processEffectUpdateQueue();
			}
		});
	}

	/**
	 * Sets up periodic performance reporting (in Studio only)
	 */
	private startPerformanceReporting(): void {
		if (RunService.IsStudio()) {
			task.spawn(() => {
				for (;;) {
					task.wait(60); // Report every minute
					this.printPerformanceReport();
				}
			});
		}
	}

	/**
	 * Gets current performance metrics
	 */
	public getPerformanceMetrics(): PerformanceMetrics {
		return {
			dataUpdatesProcessed: this.performanceMetrics.dataUpdatesProcessed,
			analyticsEventsProcessed: this.performanceMetrics.analyticsEventsProcessed,
			effectUpdatesProcessed: this.performanceMetrics.effectUpdatesProcessed,
			averageFrameTime: this.performanceMetrics.averageFrameTime,
			currentFPS: 1 / math.max(this.performanceMetrics.averageFrameTime, 0.001),
			queueSizes: {
				dataUpdates: this.dataUpdateQueue.size(),
				analyticsEvents: this.analyticsEventQueue.size(),
				effectUpdates: this.effectUpdateQueue.size(),
			},
			maxOperationsPerFrame: this.maxOperationsPerFrame,
		};
	}

	/**
	 * Prints a performance report
	 */
	public printPerformanceReport(): void {
		const metrics = this.getPerformanceMetrics();

		print("📊 Performance Optimizer Report:");
		print(`   Data Updates Processed: ${metrics.dataUpdatesProcessed}`);
		print(`   Analytics Events Processed: ${metrics.analyticsEventsProcessed}`);
		print(`   Effect Updates Processed: ${metrics.effectUpdatesProcessed}`);
		print(`   Average Frame Time: ${math.floor(metrics.averageFrameTime * 1000)}ms`);
		print(`   Current FPS: ${math.floor(metrics.currentFPS)}`);
		print(
			`   Queue Sizes: Data=${metrics.queueSizes.dataUpdates}, Analytics=${metrics.queueSizes.analyticsEvents}, Effects=${metrics.queueSizes.effectUpdates}`,
		);
		print(`   Max Operations/Frame: ${metrics.maxOperationsPerFrame}`);
	}

	/**
	 * Clears all queues (useful for testing or emergencies)
	 */
	public clearAllQueues(): void {
		this.dataUpdateQueue.clear();
		this.analyticsEventQueue.clear();
		this.effectUpdateQueue.clear();
		print("⚡ All performance optimizer queues cleared");
	}

	/**
	 * Gets queue sizes for monitoring
	 */
	public getQueueSizes(): Record<string, number> {
		return {
			dataUpdates: this.dataUpdateQueue.size(),
			analyticsEvents: this.analyticsEventQueue.size(),
			effectUpdates: this.effectUpdateQueue.size(),
		};
	}
}
