// Mock for @rbxts/profile-store
// This is used to prevent Jest from trying to load/parse .lua files.
// The actual detailed mocking is done in the test file.

const ProfileStore = {
    New: jest.fn(() => ({
        StartSessionAsync: jest.fn(),
        Mock: { // If DataService uses .Mock in IsStudio()
            StartSessionAsync: jest.fn(),
        },
        // Add any other methods or properties that might be accessed
        // by the code under test before the test-specific mock takes over.
    })),
};

module.exports = ProfileStore;
