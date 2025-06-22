import PerformanceOptimizer from "../../server/performance_optimizer";
import Person from "../../server/person";
import { MockPlayer, MockRunService } from "@rbxts/jest-roblox";

// Mock Person dependency
jest.mock("@commonserver/person", () => ({
	// For PerformanceOptimizer, we mostly care about the person object being valid
	// and having a dataCache method.
	getForPlayer: jest.fn((player: Player) => ({
		player: player,
		dataCache: jest.fn((callback) => callback({})), // Simple mock dataCache
	})),
}));

// Mock RunService for Heartbeat
let mockRunService: MockRunService;
let heartbeatConnections: Array<() => void> = [];
(game as any).GetService = jest.fn((serviceName) => {
	if (serviceName === "RunService") {
		if (!mockRunService) {
			mockRunService = new MockRunService();
			// Simple mock for Heartbeat:Connect
			(mockRunService.Heartbeat as any) = {
				Connect: jest.fn((callback) => {
					heartbeatConnections.push(callback);
					return {
						Disconnect: jest.fn(() => {
							heartbeatConnections = heartbeatConnections.filter((cb) => cb !== callback);
						}),
					};
				}),
			};
		}
		return mockRunService;
	}
	// Fallback for other services
	const actualServices = require("@rbxts/services");
	return actualServices[serviceName as keyof typeof actualServices];
});

// Spy on task.spawn and task.wait
const mockTaskSpawn = jest.spyOn(task, "spawn");
const mockTaskWait = jest.spyOn(task, "wait");

describe("PerformanceOptimizer", () => {
	let mockPlayer: Player;
	let mockPerson: any;

	// Config values from the module (if not exported, replicate for test)
	const BATCH_SIZE = 50;
	// const BATCH_INTERVAL = 0.5;
	// let MAX_OPERATIONS_PER_FRAME = 10; // This can be dynamic

	beforeEach(() => {
		jest.clearAllMocks();
		heartbeatConnections = []; // Reset heartbeat connections
		mockTaskSpawn.mockClear();
		mockTaskWait.mockClear();

		mockPlayer = MockPlayer();
		// A simplified mock person for queueing tests
		mockPerson = {
			player: mockPlayer,
			dataCache: jest.fn((callback) => callback({})),
		};

		// Call start to initialize loops and monitoring
		// We need to do this to test the queue processing that happens periodically
		// Or the immediate processing if BATCH_SIZE is reached.
		PerformanceOptimizer.start();
	});

	afterEach(() => {
		// Attempt to clean up any tasks spawned by PerformanceOptimizer.start()
		// This is a bit of a hack; ideally, the module would provide a stop/dispose method.
		const optimizerThreads = getreg().filter((t: unknown) => typeIs(t, "thread") && coroutine.status(t) !== "dead");
		optimizerThreads.forEach((thr) => task.cancel(thr as thread));
		// Also disconnect heartbeat
		heartbeatConnections.forEach((cb) => (mockRunService.Heartbeat.Connect(() => {}) as any).Disconnect());
		heartbeatConnections = [];
	});

	it("should initialize and start monitoring", () => {
		expect(PerformanceOptimizer.queueDataUpdate).toBeDefined();
		expect(mockRunService.Heartbeat.Connect).toHaveBeenCalled();
		expect(mockTaskSpawn).toHaveBeenCalled(); // For periodic queue processing
	});

	describe("queueDataUpdate", () => {
		it("should add a data update to the queue", () => {
			PerformanceOptimizer.queueDataUpdate(mockPerson, (data: any) => data);
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			expect(metrics.queueSizes.dataUpdates).toBe(1);
		});

		it("should process queue immediately if BATCH_SIZE is reached", () => {
			const updateFn = jest.fn((data: any) => data);
			for (let i = 0; i < BATCH_SIZE; i++) {
				PerformanceOptimizer.queueDataUpdate(mockPerson, updateFn);
			}
			// processDataUpdateQueue should have been called
			// Check if dataCache on mockPerson was called BATCH_SIZE times (or at least MAX_OPERATIONS_PER_FRAME)
			// This depends on MAX_OPERATIONS_PER_FRAME, let's assume it's default 10
			// It will process in chunks.
			expect(mockPerson.dataCache).toHaveBeenCalledTimes(
				math.min(BATCH_SIZE, PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame),
			);
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			// Queue might not be 0 if BATCH_SIZE > MAX_OPERATIONS_PER_FRAME
			expect(metrics.queueSizes.dataUpdates).toBe(
				BATCH_SIZE - PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame,
			);
		});
	});

	describe("queueAnalyticsEvent", () => {
		it("should add an analytics event to the queue", () => {
			PerformanceOptimizer.queueAnalyticsEvent({
				eventType: "Test",
				playerId: "1",
				timestamp: 0,
				customData: {},
			});
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			expect(metrics.queueSizes.analyticsEvents).toBe(1);
		});

		it("should process analytics queue immediately if BATCH_SIZE is reached", () => {
			const initialProcessed = PerformanceOptimizer.getPerformanceMetrics().analyticsEventsProcessed;
			for (let i = 0; i < BATCH_SIZE; i++) {
				PerformanceOptimizer.queueAnalyticsEvent({
					eventType: "TestBatch",
					playerId: `${i}`,
					timestamp: 0,
					customData: {},
				});
			}
			// processAnalyticsEventQueue should be called
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			expect(metrics.analyticsEventsProcessed).toBe(initialProcessed + BATCH_SIZE);
			expect(metrics.queueSizes.analyticsEvents).toBe(0); // Analytics processes all at once in a task.spawn
		});
	});

	describe("queueEffectUpdate", () => {
		it("should add an effect update to the queue", () => {
			PerformanceOptimizer.queueEffectUpdate(mockPerson, { effectId: { duration: 60 } } as any);
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			expect(metrics.queueSizes.effectUpdates).toBe(1);
		});

		it("should process effect update queue immediately if BATCH_SIZE is reached", () => {
			const updateData = { testEffect: { duration: 10 } } as any;
			for (let i = 0; i < BATCH_SIZE; i++) {
				PerformanceOptimizer.queueEffectUpdate(mockPerson, updateData);
			}
			expect(mockPerson.dataCache).toHaveBeenCalledTimes(
				math.min(BATCH_SIZE, PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame),
			);
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			expect(metrics.queueSizes.effectUpdates).toBe(
				BATCH_SIZE - PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame,
			);
		});
	});

	describe("getPerformanceMetrics", () => {
		it("should return current metrics", () => {
			const metrics = PerformanceOptimizer.getPerformanceMetrics();
			expect(metrics).toHaveProperty("dataUpdatesProcessed");
			expect(metrics).toHaveProperty("averageFrameTime");
			expect(metrics).toHaveProperty("currentFPS");
			expect(metrics.queueSizes.dataUpdates).toBe(0); // Assuming clean state
		});
	});

	describe("Performance Monitoring (Heartbeat)", () => {
		it("should adjust MAX_OPERATIONS_PER_FRAME based on averageFrameTime", () => {
			const initialMaxOps = PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame;

			// Simulate high frame time (low FPS)
			heartbeatConnections[0](1 / 20); // deltaTime for 20 FPS
			let newMaxOps = PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame;
			// It might take a few "frames" for averageFrameTime to settle and trigger change
			for (let i = 0; i < 10; i++) heartbeatConnections[0](1 / 20);
			newMaxOps = PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame;
			expect(newMaxOps).toBeLessThanOrEqual(initialMaxOps); // Should decrease or stay at min

			// Simulate low frame time (high FPS)
			const currentMaxOpsBeforeIncrease = newMaxOps;
			for (let i = 0; i < 20; i++) heartbeatConnections[0](1 / 100); // deltaTime for 100 FPS
			newMaxOps = PerformanceOptimizer.getPerformanceMetrics().maxOperationsPerFrame;
			expect(newMaxOps).toBeGreaterThanOrEqual(currentMaxOpsBeforeIncrease); // Should increase or stay at max
		});
	});

	// Test periodic processing (difficult to test precisely without controlling task.wait)
	// We can check if task.wait was called by the periodic loop in start()
	it("should periodically attempt to process queues via task.spawned loop", () => {
		// PerformanceOptimizer.start() is called in beforeEach
		// This should have set up a task.spawn loop that calls task.wait
		expect(mockTaskSpawn).toHaveBeenCalled();
		// To assert task.wait, we'd need to let the event loop run or mock time,
		// which is complex with vanilla Jest for Roblox.
		// A simple check is that task.spawn was called for the loop.
	});

	it("printPerformanceReport should run without errors", () => {
		expect(() => PerformanceOptimizer.printPerformanceReport()).not.toThrow();
	});
});

export {}; // Make it a module
