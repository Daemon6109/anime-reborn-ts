// Mock for @rbxts/services
// Provides basic stubs for services used in tests.
// The actual detailed mocking is often done within the test files themselves
// using jest.mock() or jest-mock-extended.

const Players = {
    // Add any properties or methods that are accessed directly
    // by the code under test if not covered by test-specific mocks.
    // Example: Players.PlayerAdded, Players.GetPlayerByUserId(), etc.
    // For now, a simple object will do to satisfy the import.
    PlayerAdded: {
        Connect: () => {},
        Disconnect: () => {},
    },
    PlayerRemoving: {
        Connect: () => {},
        Disconnect: () => {},
    },
    GetPlayerByUserId: (userId) => undefined,
    GetPlayers: () => [],
};

const RunService = {
    // Example: RunService.IsStudio, RunService.Heartbeat
    // IsStudio: () => false, // Default mock value
    // IsClient: () => false,
    // IsServer: () => true,
    // Heartbeat: {
    //     Connect: () => {},
    //     Disconnect: () => {},
    // },
    // Stepped: {
    //     Connect: () => {},
    //     Disconnect: () => {},
    // },
};

// Add other services if they are imported and used from @rbxts/services
// e.g. ReplicatedStorage, ServerScriptService, etc.

// Use jest-mock-extended directly in the file mock
const { mock } = require('jest-mock-extended');

module.exports = {
    Players: mock(),
    RunService: mock(),
    // Add other exported services here, also as mock()
};
