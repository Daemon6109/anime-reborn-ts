import { expect, describe, it, beforeEach, jest } from "@rbxts/jest-globals";
import { PerformanceOptimizerService } from "server/services/performance-optimizer.service";

describe("PerformanceOptimizerService", () => {
	let performanceService: PerformanceOptimizerService;

	beforeEach(() => {
		jest.clearAllMocks();
		performanceService = new PerformanceOptimizerService();
	});

	describe("Initialization", () => {
		it("should initialize with correct version", () => {
			expect(performanceService.version).toEqual({ major: 1, minor: 0, patch: 0 });
		});
	});

	describe("Queue Management", () => {
		it("should start with empty queues", () => {
			const queueSizes = performanceService.getQueueSizes();
			expect(queueSizes.dataUpdates).toBe(0);
			expect(queueSizes.analyticsEvents).toBe(0);
			expect(queueSizes.effectUpdates).toBe(0);
		});

		it("should clear all queues", () => {
			// Add some mock data first
			const mockEventData = {
				eventType: "test",
				playerId: "123",
				timestamp: os.time(),
				customData: { test: true },
			};

			performanceService.queueAnalyticsEvent(mockEventData);

			// Clear queues
			performanceService.clearAllQueues();

			const queueSizes = performanceService.getQueueSizes();
			expect(queueSizes.analyticsEvents).toBe(0);
		});
	});

	describe("Analytics Events", () => {
		it("should queue analytics events", () => {
			const mockEventData = {
				eventType: "test",
				playerId: "123",
				timestamp: os.time(),
				customData: { test: true },
			};

			performanceService.queueAnalyticsEvent(mockEventData);

			const queueSizes = performanceService.getQueueSizes();
			expect(queueSizes.analyticsEvents).toBe(1);
		});

		it("should process analytics events", () => {
			const mockEventData = {
				eventType: "test",
				playerId: "123",
				timestamp: os.time(),
				customData: { test: true },
			};

			performanceService.queueAnalyticsEvent(mockEventData);
			performanceService.processAnalyticsEventQueue();

			// Queue should be cleared after processing
			const queueSizes = performanceService.getQueueSizes();
			expect(queueSizes.analyticsEvents).toBe(0);
		});
	});

	describe("Performance Metrics", () => {
		it("should return performance metrics", () => {
			const metrics = performanceService.getPerformanceMetrics();

			expect(metrics.dataUpdatesProcessed).toBeDefined();
			expect(metrics.analyticsEventsProcessed).toBeDefined();
			expect(metrics.effectUpdatesProcessed).toBeDefined();
			expect(metrics.averageFrameTime).toBeDefined();
			expect(metrics.currentFPS).toBeDefined();
			expect(metrics.queueSizes).toBeDefined();
			expect(metrics.maxOperationsPerFrame).toBeDefined();
		});

		it("should have valid metric values", () => {
			const metrics = performanceService.getPerformanceMetrics();

			expect(metrics.dataUpdatesProcessed).toBeGreaterThanOrEqual(0);
			expect(metrics.analyticsEventsProcessed).toBeGreaterThanOrEqual(0);
			expect(metrics.effectUpdatesProcessed).toBeGreaterThanOrEqual(0);
			expect(metrics.maxOperationsPerFrame).toBeGreaterThan(0);
		});
	});

	describe("Queue Processing", () => {
		it("should handle empty queue processing", () => {
			// Should not throw when processing empty queues
			performanceService.processDataUpdateQueue();
			performanceService.processAnalyticsEventQueue();
			performanceService.processEffectUpdateQueue();

			const metrics = performanceService.getPerformanceMetrics();
			expect(metrics).toBeDefined();
		});
	});

	describe("Performance Reporting", () => {
		it("should print performance report without errors", () => {
			// This should not throw
			performanceService.printPerformanceReport();

			// Verify metrics are accessible
			const metrics = performanceService.getPerformanceMetrics();
			expect(metrics).toBeDefined();
		});
	});

	describe("Configuration", () => {
		it("should have version information", () => {
			expect(performanceService.version.major).toBe(1);
			expect(performanceService.version.minor).toBe(0);
			expect(performanceService.version.patch).toBe(0);
		});

		it("should have valid queue size limits", () => {
			const queueSizes = performanceService.getQueueSizes();
			expect(typeIs(queueSizes.dataUpdates, "number")).toBe(true);
			expect(typeIs(queueSizes.analyticsEvents, "number")).toBe(true);
			expect(typeIs(queueSizes.effectUpdates, "number")).toBe(true);
		});
	});

	describe("Batch Processing", () => {
		it("should handle multiple analytics events", () => {
			// Add multiple events
			for (let i = 0; i < 5; i++) {
				const mockEventData = {
					eventType: `test-${i}`,
					playerId: `player-${i}`,
					timestamp: os.time(),
					customData: { index: i },
				};
				performanceService.queueAnalyticsEvent(mockEventData);
			}

			const queueSizes = performanceService.getQueueSizes();
			expect(queueSizes.analyticsEvents).toBe(5);

			// Process all events
			performanceService.processAnalyticsEventQueue();

			const newQueueSizes = performanceService.getQueueSizes();
			expect(newQueueSizes.analyticsEvents).toBe(0);
		});
	});
});
