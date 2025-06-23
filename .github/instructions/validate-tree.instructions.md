# `validate-tree` Documentation

This document provides a comprehensive guide to `validate-tree`, a TypeScript utility for Roblox-TS that provides a powerful and type-safe way to validate the structure of Roblox Instances at runtime. It is designed to be easily understood by both developers and AI assistants.

## 1. Introduction

`validate-tree` allows you to define an expected hierarchy of Instances (a "tree") and then check if a given Instance matches that structure at runtime.

If the validation passes, TypeScript's type checker will understand the precise types of the instance and all its descendants. This gives you full autocompletion and type safety, eliminating the need for unsafe type assertions or repetitive `FindFirstChild` calls.

**Key Features:**

- **Runtime Validation:** Safely validates Rojo-like instance trees against live Roblox Instances.
- **Type Guarding:** Uses a `validateTree` function that acts as a type guard to narrow the type of an instance within a scope.
- **Asynchronous Validation:** Provides a promise-based function (`promiseTree`) to wait for an instance tree to exist, which is useful for content that is streamed from the server.
- **Strong Typing:** Infers a detailed TypeScript type for your instance hierarchy using the `EvaluateInstanceTree` utility type.

## 2. Getting Started

Here's a basic example of how to use `validate-tree`.

### Step 1: Define Your Instance Tree

Create an object that describes the structure of the instances you want to validate. **You must use `as const`** to ensure TypeScript infers the most specific types.

```typescript
const myComponentTree = {
	$className: "Folder",
	HealthBar: {
		$className: "BillboardGui",
		Bar: {
			$className: "Frame",
			Progress: "Frame", // Shorthand for { $className: "Frame" }
		},
	},
	Config: {
		$className: "Configuration",
		MaxHealth: "IntValue",
	},
} as const;
```

### Step 2: Use `validateTree` to Check an Instance

Use `validateTree` in a conditional block. Inside this block, the instance variable will be correctly typed according to the tree definition.

```typescript
import { validateTree, EvaluateInstanceTree } from "@rbxts/validate-tree";

// This utility type creates a reusable type alias for your validated instance.
type MyComponent = EvaluateInstanceTree<typeof myComponentTree>;

function setupComponent(instance: Instance) {
	// Check if the instance matches the defined tree structure.
	if (validateTree(instance, myComponentTree)) {
		// Validation passed! `instance` is now typed as `MyComponent`.
		// You can now access all children with full type safety.
		print(`Setting up ${instance.Name}`);

		const healthBar = instance.HealthBar;
		const maxHealth = instance.Config.MaxHealth.Value;

		healthBar.Bar.Progress.Size = new UDim2(1, 0, 1, 0);
		print(`Max health is ${maxHealth}`);
	} else {
		// Validation failed.
		warn(`${instance.GetFullName()} does not match the expected component tree.`);
	}
}

// This would cause a type error if uncommented, because `HealthBar` is not known to exist on a generic `Instance`.
// instance.HealthBar.Bar.Progress.Size = new UDim2(1, 0, 1, 0);
```

## 3. API Reference

### `validateTree(instance: Instance, tree: T): instance is EvaluateInstanceTree<T>`

This function is a TypeScript type guard.

- **`instance`**: The root `Instance` to validate.
- **`tree`**: The tree definition object (which must be defined with `as const`).
- **Returns**: `true` if the `instance` and its descendants match the `tree` definition, `false` otherwise.

Inside a conditional block where `validateTree` returns `true`, the type of `instance` is narrowed to the specific, strongly-typed structure defined by the tree.

### `promiseTree<T>(instance: Instance, tree: T): Promise<EvaluateInstanceTree<T>>`

This function waits for the instance tree to be valid and returns a Promise. This is useful for objects that might be created by the server and streamed to the client.

- **`instance`**: The root `Instance` to validate.
- **`tree`**: The tree definition object.
- **Returns**: A `Promise` that resolves with the fully typed instance once it matches the tree structure. The promise will reject if the root instance is destroyed before the tree is fully validated.

**Example:**

```typescript
async function safelyUseComponent(parent: Instance, name: string) {
	const instance = parent.WaitForChild(name);

	try {
		// Wait for the instance and its children to match the tree
		const component = await promiseTree(instance, myComponentTree);

		// The tree is valid, and `component` is fully typed.
		print(`${component.Name} is ready!`);
		component.HealthBar.Enabled = true;
	} catch (err) {
		warn(`Component ${name} was destroyed or failed to validate:`, err);
	}
}
```

### `EvaluateInstanceTree<T>`

This is a utility type that takes a tree definition (`T`) and computes the corresponding Roblox-TS instance type. You typically use it with `typeof myTree` to create a named type alias for your validated instance structure, which improves code readability.

```typescript
// Define the tree
const projectTree = {
	$className: "Folder",
	NumItems: {
		$className: "IntValue",
	},
} as const;

// Create a reusable type alias
type Project = EvaluateInstanceTree<typeof projectTree>;

function processProject(p: Project) {
	p.NumItems.Value++;
}
```

## 4. Tree Definition Syntax

The tree definition is a TypeScript object with a specific structure.

- **`$className: string`**: This property is **required** for every object in the tree. It specifies the `ClassName` of the Roblox Instance.
- **`[childName: string]: object | string`**: Any other property on the object represents a child of the instance.
    - The **key** is the `Name` of the child instance.
    - The **value** is another tree definition object for that child.

### Shorthand Syntax

For children that are simple instances with no children of their own that you need to validate, you can use a shorthand:

`ChildName: "ClassName"`

This is equivalent to:

`ChildName: { $className: "ClassName" }`

**Example with Shorthand:**

```typescript
const tree = {
	$className: "Folder",
	// Long form
	Data: {
		$className: "Folder",
	},
	// Shorthand
	Script: "Script",
} as const;
```

## 5. Important Note: Using `as const`

You **must** use `as const` when defining your tree object if it's not declared inline.

```typescript
// GOOD: Using `as const`
const myTree = { $className: "Folder" } as const;
validateTree(instance, myTree);

// GOOD: Using the tree inline
validateTree(instance, { $className: "Folder" });

// BAD: Not using `as const`
const myTreeObject = { $className: "Folder" };
// The type of myTree is `{ $className: string }`, not `{ readonly $className: "Folder" }`
// This will cause `EvaluateInstanceTree` to fail and result in a generic `Instance` type.
validateTree(instance, myTreeObject);
```

This is a TypeScript limitation. `as const` tells TypeScript to infer the most specific literal types for your object (e.g., `readonly $className: "Folder"`) instead of general types (e.g., `$className: string`). This specific information is essential for `EvaluateInstanceTree` to correctly build the detailed instance type.
