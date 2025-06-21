import { Modding } from "@flamework/core";
import { AnalyticsService } from "../../server/services/analytics.service";
import { DataService } from "../../server/services/data.service";
import { PlayerManagerService } from "../../server/services/player-manager.service";
import { AnalyticsService as RobloxAnalyticsService, Players, RunService } from "@rbxts/services";

// Mock services
jest.mock("../../server/services/data.service");
jest.mock("../../server/services/player-manager.service");

// Mock Roblox services
const MockRobloxAnalyticsService = {
    ReportEvent: jest.fn(),
};
const MockPlayers = {
    PlayerAdded: new Instance("BindableEvent"),
    PlayerRemoving: new Instance("BindableEvent"),
    GetPlayers: jest.fn(() => [] as Player[]),
};
const MockRunService = {
    IsRunning: jest.fn(() => true),
    IsStudio: jest.fn(() => true), // Or false, depending on what you want to test
};
const MockGame = {
    BindToClose: jest.fn((cb: () => void) => {
        // Store the callback to simulate game closing if needed
        (MockGame as any)._closeCallback = cb;
    }),
    _closeCallback: undefined as (() => void) | undefined,
};

// Apply mocks using Flamework/Jest capabilities or manual mocking if necessary
Modding.registerService(DataService);
Modding.registerService(PlayerManagerService);

// Setup for dependency injection if not automatically handled by Flamework's test runner
// This might involve using a testing module or manually instantiating the service with mocks.

describe("AnalyticsService", () => {
    let analyticsService: AnalyticsService;
    let mockDataService: jest.Mocked<DataService>;
    let mockPlayerManagerService: jest.Mocked<PlayerManagerService>;
    let mockRobloxAnalytics: jest.Mocked<RobloxAnalyticsService>;

    const mockPlayer = {
        UserId: 1,
        Name: "TestPlayer",
        CharacterAdded: new Instance("BindableEvent"),
        Parent: MockPlayers, // Ensure player.Parent is set for checks
    } as unknown as Player;

    beforeEach(() => {
        jest.clearAllMocks();

        // Re-assign mocks before each test if they are stateful or might be changed by tests
        mockRobloxAnalytics = MockRobloxAnalyticsService as jest.Mocked<RobloxAnalyticsService>;

        // Manually inject mocks. For Flamework, this often means ensuring the DI container uses these mocks.
        // If Flamework's test runner handles DI, this might be simpler.
        // For now, direct instantiation with mocks:
        analyticsService = new AnalyticsService(
            new DataService() as jest.Mocked<DataService>, // These will use the jest.mocked versions
            new PlayerManagerService() as jest.Mocked<PlayerManagerService>,
            mockRobloxAnalytics
        );

        // Assign global mocks - these should align with what setupFilesAfterEnv provides
        // or ensure these are the instances the service-under-test receives.
        // The global.* versions are set by setupFilesAfterEnv.
        // We use local consts like MockPlayers for controlling events like PlayerAdded.Fire()
        global.game = MockGame as any; // Ensure this specific mock is used for 'game'
        global.Players = MockPlayers as any;
        global.RunService = MockRunService as any;
        // global.AnalyticsService is the Roblox one, already mocked if needed by setup scripts.
        // mockRobloxAnalytics is the one we inject into our service.

        // Initialize the service (simulating Flamework lifecycle)
        analyticsService.onInit(); // Now onInit can use the global mocks correctly
        // analyticsService.onStart(); // onStart contains loops, tricky for unit tests without time control
    });

    afterEach(() => {
        // It's generally better to let Jest's environment isolation handle cleanup.
        // Explicitly deleting globals can be risky if not managed carefully.
        if ((analyticsService as any).pendingEvents) (analyticsService as any).pendingEvents = [];
        if ((analyticsService as any).sessionData) (analyticsService as any).sessionData.clear();
    });

    it("should be defined", () => {
        expect(analyticsService).toBeDefined();
    });

    describe("Player Join/Leave/CharacterAdded", () => {
        it("should handle player joining", () => {
            MockPlayers.PlayerAdded.Fire(mockPlayer);

            const session = analyticsService.getSessionData(mockPlayer);
            expect(session).toBeDefined();
            expect(session?.joinTime).toBeLessThanOrEqual(os.time());

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(1);
            expect(pending[0].eventName).toBe("PlayerJoined");
            expect(pending[0].player).toBe(mockPlayer);
        });

        it("should handle character added after player joined", () => {
            MockPlayers.PlayerAdded.Fire(mockPlayer); // Player joins
            (analyticsService as any).pendingEvents = []; // Clear PlayerJoined event for this test

            mockPlayer.CharacterAdded.Fire(undefined); // Character spawns

            const session = analyticsService.getSessionData(mockPlayer);
            expect(session?.lastActivity).toBeLessThanOrEqual(os.time());

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(1);
            expect(pending[0].eventName).toBe("CharacterSpawned");
            expect(pending[0].player).toBe(mockPlayer);
        });

        it("should handle player leaving", () => {
            MockPlayers.PlayerAdded.Fire(mockPlayer); // Player joins
            (analyticsService as any).pendingEvents = []; // Clear PlayerJoined event

            MockPlayers.PlayerRemoving.Fire(mockPlayer); // Player leaves

            const session = analyticsService.getSessionData(mockPlayer);
            expect(session).toBeUndefined();

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(1);
            expect(pending[0].eventName).toBe("PlayerLeft");
            expect(pending[0].player).toBe(mockPlayer);
            expect(pending[0].parameters.get("sessionDuration")).toBeGreaterThanOrEqual(0);
        });
    });

    describe("Event Tracking", () => {
        it("should track a custom event", () => {
            const params = new Map<string, unknown>([["key", "value"]]);
            analyticsService.trackEvent(mockPlayer, "CustomTestEvent", params);

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(1);
            expect(pending[0].eventName).toBe("CustomTestEvent");
            expect(pending[0].parameters.get("key")).toBe("value");
        });

        it("should track an error event", () => {
            analyticsService.trackError("Test Error", "TestType");

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(1);
            expect(pending[0].eventName).toBe("SystemError");
            expect(pending[0].parameters.get("errorMessage")).toBe("Test Error");
            expect(pending[0].parameters.get("errorType")).toBe("TestType");
        });

        it("should track performance event if player is in session", () => {
            MockPlayers.PlayerAdded.Fire(mockPlayer); // Player joins to create session
            (analyticsService as any).pendingEvents = [];

            analyticsService.trackPerformance(mockPlayer);

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(1);
            expect(pending[0].eventName).toBe("PerformanceMetrics");
            expect(pending[0].player).toBe(mockPlayer);
            expect(pending[0].parameters.get("sessionDuration")).toBeGreaterThanOrEqual(0);
        });

        it("should not track performance event if player has no session", () => {
            analyticsService.trackPerformance(mockPlayer); // No session for mockPlayer yet
            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(0);
        });
    });

    describe("Process Pending Events", () => {
        beforeEach(() => {
            // Ensure onStart is called to setup loops, but we'll call processPendingEvents manually
            // analyticsService.onStart();
            // For testing, we call processPendingEvents directly.
        });

        it("should process pending events and call RobloxAnalyticsService", () => {
            analyticsService.trackEvent(mockPlayer, "Event1", new Map());
            analyticsService.trackEvent(mockPlayer, "Event2", new Map());

            (analyticsService as any).processPendingEvents();

            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenCalledTimes(2);
            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenNthCalledWith(1, mockPlayer, "Event1");
            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenNthCalledWith(2, mockPlayer, "Event2");

            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(0);
        });

        it("should process only BATCH_SIZE events if more are pending", () => {
            const BATCH_SIZE = 50; // From service constants
            for (let i = 0; i < BATCH_SIZE + 10; i++) {
                analyticsService.trackEvent(mockPlayer, `Event${i}`, new Map());
            }

            (analyticsService as any).processPendingEvents();

            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenCalledTimes(BATCH_SIZE);
            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(10); // 10 should remain
        });

        it("should process all events if isShuttingDown is true", () => {
            for (let i = 0; i < 60; i++) { // More than BATCH_SIZE
                analyticsService.trackEvent(mockPlayer, `Event${i}`, new Map());
            }

            (analyticsService as any).processPendingEvents(true); // isShuttingDown = true

            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenCalledTimes(60);
            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(0);
        });

        it("should handle errors during event reporting gracefully", () => {
            MockRobloxAnalyticsService.ReportEvent.mockImplementationOnce(() => {
                throw "Mock ReportEvent error";
            });

            analyticsService.trackEvent(mockPlayer, "ErrorEvent", new Map());
            analyticsService.trackEvent(mockPlayer, "GoodEvent", new Map());

            expect(() => (analyticsService as any).processPendingEvents()).not.toThrow();

            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenCalledTimes(2); // Both attempts
            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(0); // Events should still be cleared
        });

        it("should not process event if player has left for player-specific events", () => {
            const leavingPlayer = { ...mockPlayer, Parent: undefined } as unknown as Player; // Simulate player left
            analyticsService.trackEvent(leavingPlayer, "PlayerSpecificEvent", new Map());

            (analyticsService as any).processPendingEvents();

            expect(MockRobloxAnalyticsService.ReportEvent).not.toHaveBeenCalledWith(leavingPlayer, "PlayerSpecificEvent");
        });

        it("should print info for system events as ReportEvent needs a player", () => {
            const consoleSpy = jest.spyOn(global, "print"); // Spy on global.print itself
            analyticsService.trackError("SystemWideError", "System");

            (analyticsService as any).processPendingEvents();

            expect(MockRobloxAnalyticsService.ReportEvent).not.toHaveBeenCalled();
            expect(consoleSpy).toHaveBeenCalledWith(
                expect.stringContaining("Analytics: System event \"SystemError\" logged."),
                expect.anything() // For the parameters map
            );
            consoleSpy.mockRestore();
        });
    });

    describe("BindToClose", () => {
        it("should setup BindToClose and process all events on close", () => {
            // BindToClose is setup in onInit
            // analyticsService.onInit(); // Called in beforeEach

            expect(MockGame.BindToClose).toHaveBeenCalled();

            for (let i = 0; i < 60; i++) {
                analyticsService.trackEvent(mockPlayer, `Event${i}`, new Map());
            }

            // Simulate game closing
            if (MockGame._closeCallback) {
                MockGame._closeCallback();
            }

            expect(MockRobloxAnalyticsService.ReportEvent).toHaveBeenCalledTimes(60);
            const pending = (analyticsService as any).pendingEvents as any[];
            expect(pending.size()).toBe(0);
        });
    });

    // Note: Testing the actual timing loops in onStart (BATCH_INTERVAL, PERFORMANCE_TRACK_INTERVAL)
    // is complex in unit tests and often requires Jest's timer mocks (jest.useFakeTimers).
    // For simplicity, those loops' direct functionality (processPendingEvents, trackPerformance)
    // are tested by calling the methods directly.
});
