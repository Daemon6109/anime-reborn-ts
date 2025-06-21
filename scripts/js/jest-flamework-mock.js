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

// Mock other decorators or functions if they are used and cause errors
// e.g., OnStart, Dependency, etc.

module.exports = {
    Service,
    OnInit,
    // Add other exports from @flamework/core if they are directly used and need mocking
    // For example, if Dependency decorator is used:
    // Dependency: () => () => {},
};
