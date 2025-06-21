// Mock for @flamework/core
// For Jest tests in Node.js environment

// Mock the Service decorator
// It's a class decorator, so it needs to return a new constructor or the original one.
// For simplicity, we'll make it an identity decorator.
const Service = () => (ctor) => ctor;

// Mock the OnInit interface/decorator if used as such (though it's usually an interface)
// If OnInit is just an interface, it doesn't need a runtime mock unless used in a way that requires it.
// Assuming it's primarily for type checking.
const OnInit = {}; // Placeholder, might not be strictly necessary as a runtime mock

// Mock Modding
const Modding = {
    registerService: jest.fn(),
    // Add other Modding methods if needed, e.g., registerDependency, OnInit, OnStart
    // For the current test, only registerService seems to be directly called on Modding.
};

// Mock other decorators or functions if they are used and cause errors
// e.g., OnStart, Dependency, etc.
const OnStart = () => (ctor) => ctor; // If OnStart is used as a decorator
const Dependency = () => () => {}; // If Dependency decorator is used

module.exports = {
    Service,
    OnInit,
    Modding, // Export Modding
    OnStart, // Export OnStart if used
    Dependency, // Export Dependency if used
    // Add other exports from @flamework/core if they are directly used and need mocking
};
