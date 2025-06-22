import { expect, describe, it, beforeEach } from "@rbxts/jest-globals";
import { AnalyticsService } from "server/services/analytics.service";
import { DataService } from "server/services/data.service";
import { PlayerManagerService } from "server/services/player-manager.service";

// Type interfaces for testing private members
interface AnalyticsServiceTestable {
	handlePlayerJoined(player: Player): void;
	handlePlayerLeft(player: Player): void;
	handleCharacterAdded(player: Player): void;
	processPendingEvents(isShuttingDown?: boolean): void;
	pendingEvents: AnalyticsEvent[];
}

interface AnalyticsEvent {
	player?: Player;
	eventName: string;
	parameters: Map<string, unknown>;
	timestamp: number;
}

interface RobloxAnalyticsService {
	ReportEvent: (player: Player, eventName: string, eventContext?: unknown, eventSpecificData?: unknown) => void;
}

interface GameTestable {
	BindToClose?: (callback: () => void) => void;
	_closeCallback?: () => void;
}

describe("AnalyticsService", () => {
	let analyticsService: AnalyticsService;
	let dataService: DataService;
	let playerManagerService: PlayerManagerService;
	let mockPlayer: Player;

	// Mock RobloxAnalyticsService
	const mockRobloxAnalytics = {
		ReportEvent: () => {},
	};

	beforeEach(() => {
		// Create fresh instances for each test
		dataService = new DataService();
		playerManagerService = new PlayerManagerService(dataService);
		analyticsService = new AnalyticsService(dataService, playerManagerService);

		// Create a mock player object
		mockPlayer = {
			UserId: 1,
			Name: "TestPlayer",
			DisplayName: "TestPlayer",
			Parent: {}, // Set parent to indicate player is still in game
			CharacterAdded: {
				Connect: () => {},
				Disconnect: () => {},
			},
		} as unknown as Player;

		// Initialize the analytics service
		analyticsService.onInit();
	});

	it("should be defined", () => {
		expect(analyticsService).toBeDefined();
	});

	describe("Session Management", () => {
		it("should track session data when player joins", () => {
			// Simulate player joining by calling the handler directly
			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			testableService.handlePlayerJoined(mockPlayer);

			const session = analyticsService.getSessionData(mockPlayer);
			expect(session).toBeDefined();
			expect(session?.joinTime).toBeLessThanOrEqual(os.time());
			expect(session?.lastActivity).toBeLessThanOrEqual(os.time());
		});

		it("should update last activity when character spawns", () => {
			// First, player joins
			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			testableService.handlePlayerJoined(mockPlayer);
			const initialSession = analyticsService.getSessionData(mockPlayer);

			// Wait a moment then simulate character spawn
			task.wait(0.1);
			testableService.handleCharacterAdded(mockPlayer);

			const updatedSession = analyticsService.getSessionData(mockPlayer);
			// eslint-disable-next-line roblox-ts/lua-truthiness
			expect(updatedSession?.lastActivity).toBeGreaterThanOrEqual(initialSession?.lastActivity || 0);
		});

		it("should clean up session data when player leaves", () => {
			// Player joins first
			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			testableService.handlePlayerJoined(mockPlayer);
			expect(analyticsService.getSessionData(mockPlayer)).toBeDefined();

			// Player leaves
			testableService.handlePlayerLeft(mockPlayer);
			expect(analyticsService.getSessionData(mockPlayer)).toBeUndefined();
		});

		it("should calculate session duration correctly", () => {
			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			testableService.handlePlayerJoined(mockPlayer);

			const session = analyticsService.getSessionData(mockPlayer);
			expect(session?.sessionDuration).toBeGreaterThanOrEqual(0);
		});
	});

	describe("Event Tracking", () => {
		it("should track custom events", () => {
			const params = new Map<string, unknown>([
				["key1", "value1"],
				["key2", 42],
			]);

			analyticsService.trackEvent(mockPlayer, "CustomTestEvent", params);

			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pending = testableService.pendingEvents;
			expect(pending.size()).toBe(1);
			expect(pending[0].eventName).toBe("CustomTestEvent");
			expect(pending[0].player).toBe(mockPlayer);
			expect(pending[0].parameters.get("key1")).toBe("value1");
			expect(pending[0].parameters.get("key2")).toBe(42);
		});

		it("should track error events", () => {
			analyticsService.trackError("Test Error", "TestType");

			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pending = testableService.pendingEvents;
			expect(pending.size()).toBe(1);
			expect(pending[0].eventName).toBe("SystemError");
			expect(pending[0].parameters.get("errorMessage")).toBe("Test Error");
			expect(pending[0].parameters.get("errorType")).toBe("TestType");
			expect(pending[0].player).toBeUndefined(); // System events don't have a player
		});

		it("should track performance metrics for players with sessions", () => {
			// First create a session
			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			testableService.handlePlayerJoined(mockPlayer);

			// Clear any pending events from join
			testableService.pendingEvents = [];

			// Track performance
			analyticsService.trackPerformance(mockPlayer);

			const pending = testableService.pendingEvents;
			expect(pending.size()).toBe(1);
			expect(pending[0].eventName).toBe("PerformanceMetrics");
			expect(pending[0].player).toBe(mockPlayer);
			expect(pending[0].parameters.get("sessionDuration")).toBeGreaterThanOrEqual(0);
		});

		it("should not track performance for players without sessions", () => {
			// Don't create a session first
			analyticsService.trackPerformance(mockPlayer);

			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pending = testableService.pendingEvents;
			expect(pending.size()).toBe(0);
		});
	});

	describe("Event Processing", () => {
		it("should process pending events", () => {
			// Add some events
			analyticsService.trackEvent(mockPlayer, "Event1", new Map());
			analyticsService.trackEvent(mockPlayer, "Event2", new Map());

			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pendingBefore = testableService.pendingEvents;
			expect(pendingBefore.size()).toBe(2);

			// Process events
			testableService.processPendingEvents();

			const pendingAfter = testableService.pendingEvents;
			expect(pendingAfter.size()).toBe(0);
		});

		it("should process all events when shutting down", () => {
			// Add many events (more than batch size)
			for (let i = 0; i < 60; i++) {
				analyticsService.trackEvent(mockPlayer, `Event${i}`, new Map());
			}

			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pendingBefore = testableService.pendingEvents;
			expect(pendingBefore.size()).toBe(60);

			// Process with shutdown flag
			testableService.processPendingEvents(true);

			const pendingAfter = testableService.pendingEvents;
			expect(pendingAfter.size()).toBe(0);
		});

		it("should not process events for players who have left", () => {
			// Create a player that has left (no parent)
			const leftPlayer = {
				...mockPlayer,
				Parent: undefined,
			} as unknown as Player;

			analyticsService.trackEvent(leftPlayer, "EventForLeftPlayer", new Map());

			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pendingBefore = testableService.pendingEvents;
			expect(pendingBefore.size()).toBe(1);

			// Process events - should remove the event but not actually process it
			testableService.processPendingEvents();

			const pendingAfter = testableService.pendingEvents;
			expect(pendingAfter.size()).toBe(0);
		});
	});

	describe("Game Lifecycle", () => {
		it("should handle game bind to close", () => {
			// The onInit method should have set up BindToClose
			const testableGame = game as unknown as GameTestable;
			expect(testableGame.BindToClose).toBeDefined();

			// Add some events
			analyticsService.trackEvent(mockPlayer, "TestEvent", new Map());

			// Simulate game closing if the callback exists
			if (testableGame._closeCallback) {
				testableGame._closeCallback();
			}

			// Events should be processed
			const testableService = analyticsService as unknown as AnalyticsServiceTestable;
			const pending = testableService.pendingEvents;
			expect(pending.size()).toBe(0);
		});
	});
});
