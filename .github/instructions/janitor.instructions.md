# Janitor Package Instructions

The Janitor is a powerful resource management utility for Roblox TypeScript projects that helps prevent memory leaks by automatically cleaning up resources like connections, instances, promises, and other objects.

## Installation

```bash
npm i @rbxts/janitor
```

## Core Concepts

### What is Janitor?

Janitor is a cleanup utility that manages the lifecycle of resources in your Roblox game. It automatically handles:

- **RBXScriptConnections** - Event connections that need to be disconnected
- **Instances** - Roblox objects that need to be destroyed
- **Promises** - Asynchronous operations that need to be cancelled
- **Functions** - Cleanup callbacks that need to be called
- **Custom cleanup methods** - Any object with a cleanup method

### Why Use Janitor?

- **Prevents Memory Leaks** - Automatically cleans up resources when they're no longer needed
- **Simplifies Cleanup Logic** - Centralized cleanup instead of scattered disconnect/destroy calls
- **Type Safety** - Full TypeScript support with generic type constraints
- **Flexible** - Works with any cleanup pattern (destroy, disconnect, cancel, etc.)

## Basic Usage

### Import and Basic Setup

```ts
import { Janitor } from "@rbxts/janitor";

// Create a basic janitor
const janitor = new Janitor();

// Create a typed janitor with named resources
const typedJanitor = new Janitor<{
	UserInterface: ScreenGui;
	PlayerConnection: RBXScriptConnection;
	DataPromise: Promise<PlayerData>;
}>();
```

### Adding Resources for Cleanup

```ts
import { Janitor } from "@rbxts/janitor";
import { Players, RunService } from "@rbxts/services";

const cleanup = new Janitor();

// Add an instance to be destroyed on cleanup
const part = new Instance("Part");
part.Parent = workspace;
cleanup.Add(part, "Destroy");

// Add a connection to be disconnected on cleanup
const connection = RunService.Heartbeat.Connect(() => {
	print("Heartbeat");
});
cleanup.Add(connection, "Disconnect");

// Add a function to be called on cleanup
cleanup.Add(() => {
	print("Cleaning up custom logic");
}, true); // `true` means call the function directly

// Add with named index for later reference
cleanup.Add(part, "Destroy", "MyPart");
cleanup.Add(connection, "Disconnect", "HeartbeatConnection");
```

## Flamework Integration Patterns

### Service Cleanup Pattern

```ts
import { Service, OnStart } from "@flamework/core";
import { Janitor } from "@rbxts/janitor";
import { Players, RunService } from "@rbxts/services";

@Service()
export class ExampleService implements OnStart {
	private readonly janitor = new Janitor<{
		PlayerConnections: Map<Player, RBXScriptConnection>;
		HeartbeatConnection: RBXScriptConnection;
		PlayerDataCache: Map<Player, PlayerData>;
	}>();

	onStart(): void {
		this.setupPlayerHandling();
		this.setupHeartbeatLoop();
	}

	private setupPlayerHandling(): void {
		const playerConnections = new Map<Player, RBXScriptConnection>();

		// Handle player joining
		const playerAddedConnection = Players.PlayerAdded.Connect((player) => {
			this.handlePlayerJoined(player, playerConnections);
		});
		this.janitor.Add(playerAddedConnection, "Disconnect");

		// Handle player leaving
		const playerRemovingConnection = Players.PlayerRemoving.Connect((player) => {
			this.handlePlayerLeaving(player, playerConnections);
		});
		this.janitor.Add(playerRemovingConnection, "Disconnect");

		// Store the map for cleanup
		this.janitor.Add(
			playerConnections,
			(map) => {
				// Custom cleanup for the map
				for (const [player, connection] of map) {
					connection.Disconnect();
				}
				map.clear();
			},
			"PlayerConnections",
		);
	}

	private setupHeartbeatLoop(): void {
		const heartbeatConnection = RunService.Heartbeat.Connect(() => {
			this.onHeartbeat();
		});
		this.janitor.Add(heartbeatConnection, "Disconnect", "HeartbeatConnection");
	}

	private handlePlayerJoined(player: Player, connections: Map<Player, RBXScriptConnection>): void {
		// Create player-specific connection
		const characterConnection = player.CharacterAdded.Connect((character) => {
			this.onCharacterAdded(player, character);
		});
		connections.set(player, characterConnection);
	}

	private handlePlayerLeaving(player: Player, connections: Map<Player, RBXScriptConnection>): void {
		const connection = connections.get(player);
		if (connection) {
			connection.Disconnect();
			connections.delete(player);
		}
	}

	private onHeartbeat(): void {
		// Heartbeat logic
	}

	private onCharacterAdded(player: Player, character: Model): void {
		// Character handling logic
	}

	// Cleanup when service is destroyed
	public destroy(): void {
		this.janitor.Cleanup();
	}
}
```

### Controller Cleanup Pattern

```ts
import { Controller, OnStart } from "@flamework/core";
import { Janitor } from "@rbxts/janitor";
import { Players, UserInputService } from "@rbxts/services";

@Controller()
export class UIController implements OnStart {
	private readonly janitor = new Janitor<{
		MainUI: ScreenGui;
		InputConnections: RBXScriptConnection[];
		TweenPromises: Promise<void>[];
	}>();

	onStart(): void {
		this.setupUI();
		this.setupInputHandling();
	}

	private setupUI(): void {
		const playerGui = Players.LocalPlayer.WaitForChild("PlayerGui") as PlayerGui;

		// Create main UI
		const screenGui = new Instance("ScreenGui");
		screenGui.Name = "MainUI";
		screenGui.Parent = playerGui;

		// Add to janitor for cleanup
		this.janitor.Add(screenGui, "Destroy", "MainUI");

		// Create UI elements
		this.createMenuButton(screenGui);
		this.createInventoryPanel(screenGui);
	}

	private setupInputHandling(): void {
		const inputConnections: RBXScriptConnection[] = [];

		// Handle key inputs
		const inputBeganConnection = UserInputService.InputBegan.Connect((input, gameProcessed) => {
			if (gameProcessed) return;
			this.handleInput(input);
		});
		inputConnections.push(inputBeganConnection);

		// Handle mouse inputs
		const mouseButtonConnection = UserInputService.InputBegan.Connect((input) => {
			if (input.UserInputType === Enum.UserInputType.MouseButton1) {
				this.handleMouseClick();
			}
		});
		inputConnections.push(mouseButtonConnection);

		// Add all input connections to janitor
		this.janitor.Add(
			inputConnections,
			(connections) => {
				connections.forEach((conn) => conn.Disconnect());
			},
			"InputConnections",
		);
	}

	private createMenuButton(parent: ScreenGui): void {
		const button = new Instance("TextButton");
		button.Size = UDim2.fromScale(0.2, 0.1);
		button.Position = UDim2.fromScale(0.1, 0.1);
		button.Text = "Menu";
		button.Parent = parent;

		// Handle button click
		const clickConnection = button.MouseButton1Click.Connect(() => {
			this.toggleMenu();
		});
		this.janitor.Add(clickConnection, "Disconnect");
	}

	private createInventoryPanel(parent: ScreenGui): void {
		// Create inventory UI elements
		// Add cleanup as needed
	}

	private handleInput(input: InputObject): void {
		// Handle input logic
	}

	private handleMouseClick(): void {
		// Handle mouse click logic
	}

	private toggleMenu(): void {
		// Menu toggle logic with animations
		const tweenPromises: Promise<void>[] = [];

		// Create animation promises
		const fadePromise = this.animateMenuFade();
		tweenPromises.push(fadePromise);

		// Add promises to janitor for cancellation
		this.janitor.Add(
			tweenPromises,
			(promises) => {
				promises.forEach((promise) => {
					if (promise.getStatus() === Promise.Status.Started) {
						promise.cancel();
					}
				});
			},
			"TweenPromises",
		);
	}

	private animateMenuFade(): Promise<void> {
		return new Promise((resolve) => {
			// Animation logic
			task.wait(1);
			resolve();
		});
	}

	// Cleanup when controller is destroyed
	public destroy(): void {
		this.janitor.Cleanup();
	}
}
```

## Advanced Usage Patterns

### Promise Integration

```ts
import { Janitor } from "@rbxts/janitor";

class DataManager {
	private readonly janitor = new Janitor<{
		LoadPromise: Promise<PlayerData>;
		SavePromise: Promise<void>;
		TimeoutPromise: Promise<void>;
	}>();

	public async loadPlayerData(player: Player): Promise<PlayerData> {
		// Create a promise for loading data
		const loadPromise = new Promise<PlayerData>((resolve, reject) => {
			// Simulate data loading
			task.spawn(() => {
				task.wait(2);
				resolve({
					coins: 100,
					level: 1,
					inventory: [],
				});
			});
		});

		// Add promise to janitor for automatic cancellation
		this.janitor.AddPromise(loadPromise, "LoadPromise");

		return loadPromise;
	}

	public async savePlayerData(player: Player, data: PlayerData): Promise<void> {
		const savePromise = new Promise<void>((resolve, reject) => {
			// Simulate data saving
			task.spawn(() => {
				task.wait(1);
				print(`Saved data for ${player.Name}`);
				resolve();
			});
		});

		// Use AddPromise for automatic promise management
		return this.janitor.AddPromise(savePromise, "SavePromise");
	}

	public setupTimeout(duration: number): Promise<void> {
		const timeoutPromise = new Promise<void>((resolve) => {
			task.wait(duration);
			resolve();
		});

		return this.janitor.AddPromise(timeoutPromise, "TimeoutPromise");
	}

	public cleanup(): void {
		// All promises will be automatically cancelled
		this.janitor.Cleanup();
	}
}

interface PlayerData {
	coins: number;
	level: number;
	inventory: string[];
}
```

### Component Cleanup Pattern

```ts
import { Component, BaseComponent } from "@flamework/components";
import { OnStart } from "@flamework/core";
import { Janitor } from "@rbxts/janitor";
import { TweenService } from "@rbxts/services";

@Component({ tag: "AnimatedPart" })
export class AnimatedPartComponent extends BaseComponent<AnimatedPartAttributes, BasePart> implements OnStart {
	private readonly janitor = new Janitor<{
		AnimationTween: Tween;
		HeartbeatConnection: RBXScriptConnection;
		ClickConnection: RBXScriptConnection;
	}>();

	onStart(): void {
		this.setupAnimation();
		this.setupInteraction();
		this.setupHeartbeatUpdate();
	}

	private setupAnimation(): void {
		const tweenInfo = new TweenInfo(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
		const tween = TweenService.Create(this.instance, tweenInfo, {
			CFrame: this.instance.CFrame.mul(CFrame.Angles(0, math.rad(90), 0)),
		});

		// Add tween to janitor for cleanup
		this.janitor.Add(tween, "Cancel", "AnimationTween");
		tween.Play();
	}

	private setupInteraction(): void {
		// Create click detector if it doesn't exist
		let clickDetector = this.instance.FindFirstChild("ClickDetector") as ClickDetector;
		if (!clickDetector) {
			clickDetector = new Instance("ClickDetector");
			clickDetector.Parent = this.instance;
			// The click detector will be cleaned up when the part is destroyed
		}

		const clickConnection = clickDetector.MouseClick.Connect((player) => {
			this.handleClick(player);
		});
		this.janitor.Add(clickConnection, "Disconnect", "ClickConnection");
	}

	private setupHeartbeatUpdate(): void {
		const heartbeatConnection = game.GetService("RunService").Heartbeat.Connect(() => {
			this.onHeartbeat();
		});
		this.janitor.Add(heartbeatConnection, "Disconnect", "HeartbeatConnection");
	}

	private handleClick(player: Player): void {
		print(`${player.Name} clicked ${this.instance.Name}`);

		// Create click effect
		this.createClickEffect();
	}

	private createClickEffect(): void {
		const effect = new Instance("Explosion");
		effect.Position = this.instance.Position;
		effect.BlastRadius = 0;
		effect.BlastPressure = 0;
		effect.Parent = workspace;

		// Clean up effect after 5 seconds
		task.spawn(() => {
			task.wait(5);
			effect.Destroy();
		});
	}

	private onHeartbeat(): void {
		// Update logic that runs every frame
		const attributes = this.attributes;
		if (attributes.rotationSpeed) {
			this.instance.CFrame = this.instance.CFrame.mul(CFrame.Angles(0, math.rad(attributes.rotationSpeed), 0));
		}
	}

	// Component cleanup - called when component is destroyed
	public destroy(): void {
		this.janitor.Cleanup();
		super.destroy();
	}
}

interface AnimatedPartAttributes {
	rotationSpeed?: number;
	animationType?: "spin" | "bounce" | "pulse";
}
```

## Best Practices

### 1. Use Typed Janitors for Better Organization

```ts
// GOOD: Typed janitor with clear resource names
const janitor = new Janitor<{
	PlayerConnections: Map<Player, RBXScriptConnection>;
	UIElements: ScreenGui;
	DataPromises: Promise<unknown>[];
	HeartbeatLoop: RBXScriptConnection;
}>();

// AVOID: Untyped janitor with unclear resource management
const janitor = new Janitor();
```

### 2. Consistent Cleanup in Lifecycle Methods

```ts
@Service()
export class WellManagedService implements OnStart {
	private readonly janitor = new Janitor();

	onStart(): void {
		this.setupService();
	}

	// Always provide cleanup method
	public destroy(): void {
		this.janitor.Cleanup();
	}
}
```

### 3. Group Related Resources

```ts
// Group related cleanup resources
const uiJanitor = new Janitor(); // For UI-related cleanup
const networkJanitor = new Janitor(); // For network-related cleanup
const gameplayJanitor = new Janitor(); // For gameplay-related cleanup

// Or use a master janitor with organized indices
const masterJanitor = new Janitor<{
	UI: Janitor;
	Network: Janitor;
	Gameplay: Janitor;
}>();

masterJanitor.Add(uiJanitor, "Cleanup", "UI");
masterJanitor.Add(networkJanitor, "Cleanup", "Network");
masterJanitor.Add(gameplayJanitor, "Cleanup", "Gameplay");
```

### 4. Handle Player-Specific Cleanup

```ts
@Service()
export class PlayerManagedService implements OnStart {
	private readonly playerJanitors = new Map<Player, Janitor>();
	private readonly serviceJanitor = new Janitor();

	onStart(): void {
		// Handle new players
		const playerAddedConnection = Players.PlayerAdded.Connect((player) => {
			this.setupPlayerResources(player);
		});
		this.serviceJanitor.Add(playerAddedConnection, "Disconnect");

		// Handle leaving players
		const playerRemovingConnection = Players.PlayerRemoving.Connect((player) => {
			this.cleanupPlayerResources(player);
		});
		this.serviceJanitor.Add(playerRemovingConnection, "Disconnect");
	}

	private setupPlayerResources(player: Player): void {
		const playerJanitor = new Janitor<{
			CharacterConnection: RBXScriptConnection;
			PlayerData: PlayerData;
			UIElements: ScreenGui;
		}>();

		// Set up player-specific resources
		const characterConnection = player.CharacterAdded.Connect((character) => {
			this.handleCharacterAdded(player, character);
		});
		playerJanitor.Add(characterConnection, "Disconnect", "CharacterConnection");

		// Store the player's janitor
		this.playerJanitors.set(player, playerJanitor);
	}

	private cleanupPlayerResources(player: Player): void {
		const playerJanitor = this.playerJanitors.get(player);
		if (playerJanitor) {
			playerJanitor.Cleanup();
			this.playerJanitors.delete(player);
		}
	}

	// Service cleanup
	public destroy(): void {
		// Clean up all player janitors
		for (const [player, janitor] of this.playerJanitors) {
			janitor.Cleanup();
		}
		this.playerJanitors.clear();

		// Clean up service janitor
		this.serviceJanitor.Cleanup();
	}
}
```

### 5. Error Handling with Janitor

```ts
class RobustResourceManager {
	private readonly janitor = new Janitor();

	public async initializeResources(): Promise<boolean> {
		try {
			// Set up resources that might fail
			const connection = this.setupCriticalConnection();
			this.janitor.Add(connection, "Disconnect");

			const ui = this.createUserInterface();
			this.janitor.Add(ui, "Destroy");

			const dataPromise = this.loadCriticalData();
			this.janitor.AddPromise(dataPromise);

			return true;
		} catch (error) {
			warn(`Failed to initialize resources: ${error}`);
			// Janitor will clean up any resources that were successfully created
			this.janitor.Cleanup();
			return false;
		}
	}

	private setupCriticalConnection(): RBXScriptConnection {
		// Connection setup that might throw
		return game.GetService("SomeService").SomeEvent.Connect(() => {});
	}

	private createUserInterface(): ScreenGui {
		// UI creation that might fail
		const gui = new Instance("ScreenGui");
		gui.Parent = Players.LocalPlayer.WaitForChild("PlayerGui");
		return gui;
	}

	private loadCriticalData(): Promise<unknown> {
		// Data loading that might be cancelled
		return new Promise((resolve, reject) => {
			task.spawn(() => {
				task.wait(5);
				resolve("data");
			});
		});
	}

	public cleanup(): void {
		this.janitor.Cleanup();
	}
}
```

## Common Cleanup Methods

### Built-in Cleanup Methods

```ts
// Common cleanup methods that Janitor recognizes:
janitor.Add(connection, "Disconnect"); // For RBXScriptConnections
janitor.Add(instance, "Destroy"); // For Instances
janitor.Add(tween, "Cancel"); // For Tweens
janitor.Add(sound, "Stop"); // For Sounds
janitor.Add(promise, "cancel"); // For Promises (lowercase)

// Use AddPromise for Promise objects (recommended)
janitor.AddPromise(somePromise);
```

### Custom Cleanup Functions

```ts
// Custom cleanup with function
janitor.Add(customObject, (obj) => {
	obj.cleanup();
	obj.reset();
});

// Cleanup with boolean true (call the object directly as a function)
janitor.Add(() => {
	print("Custom cleanup logic");
}, true);

// Cleanup arrays or maps
janitor.Add(connectionsArray, (connections) => {
	connections.forEach((conn) => conn.Disconnect());
});
```

## Integration with Flamework Components

```ts
// Example of comprehensive Janitor usage in a Flamework component
@Component({ tag: "ComplexInteractable" })
export class ComplexInteractableComponent extends BaseComponent<InteractableAttributes, Model> implements OnStart {
	private readonly janitor = new Janitor<{
		ClickDetector: ClickDetector;
		HoverEffect: Tween;
		SoundEffects: Sound[];
		UpdateLoop: RBXScriptConnection;
		InteractionPromises: Promise<void>[];
	}>();

	onStart(): void {
		this.setupClickDetection();
		this.setupVisualEffects();
		this.setupSoundEffects();
		this.setupUpdateLoop();
	}

	private setupClickDetection(): void {
		const clickDetector = new Instance("ClickDetector");
		clickDetector.Parent = this.instance;
		this.janitor.Add(clickDetector, "Destroy", "ClickDetector");

		const clickConnection = clickDetector.MouseClick.Connect((player) => {
			this.handleInteraction(player);
		});
		this.janitor.Add(clickConnection, "Disconnect");
	}

	// ... other setup methods

	private handleInteraction(player: Player): Promise<void> {
		const interactionPromise = this.processInteraction(player);

		// Add to janitor's promise tracking
		const promises = this.janitor.Get("InteractionPromises") || [];
		promises.push(interactionPromise);
		this.janitor.Add(
			promises,
			(promiseArray) => {
				promiseArray.forEach((p) => {
					if (p.getStatus() === Promise.Status.Started) {
						p.cancel();
					}
				});
			},
			"InteractionPromises",
		);

		return interactionPromise;
	}

	private async processInteraction(player: Player): Promise<void> {
		// Long-running interaction logic
		await task.wait(2);
		print(`Interaction completed for ${player.Name}`);
	}

	// Component cleanup
	public destroy(): void {
		this.janitor.Cleanup();
		super.destroy();
	}
}
```

This comprehensive guide should help you effectively use the Janitor package in your Flamework-based Roblox TypeScript project, ensuring proper resource management and preventing memory leaks throughout your game's lifecycle.
