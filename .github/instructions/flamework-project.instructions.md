# Flamework Game Development Instructions

Flamework is a TypeScript framework designed for Roblox game development that emphasizes simplicity and extensibility. This project uses Flamework to structure our game's architecture with Services (server-side) and Controllers (client-side).

## Framework Overview

### Why Flamework?

- **Extensible**: Provides APIs not possible in vanilla roblox-ts
- **Type Safety**: Automatically generates type guards for components and dependency injection
- **Lifecycle Events**: Non-obtrusive, easy to opt-in lifecycle management
- **Dependency Injection**: Constructor-based dependency injection with automatic resolution
- **Modular**: Split into packages - only install what you need
- **Minimal Boilerplate**: Preserves simplicity while providing robust structure
- **Decorator-Based**: Uses TypeScript decorators for clean, declarative code

### Key Principles

- **Single Responsibility**: Each service/controller should handle one specific area of functionality
- **Dependency Inversion**: Services depend on abstractions, not concrete implementations
- **Lifecycle Management**: Use appropriate lifecycle hooks for initialization and cleanup
- **Type Safety**: Leverage TypeScript's type system for robust, maintainable code

## Core Architecture

### Services vs Controllers

- **Services**: Server-side singletons that handle:
    - Game logic and business rules
    - Data management and persistence
    - Player management and events
    - Game state management
    - Background processes and timers
    - Server-side computations

- **Controllers**: Client-side singletons that manage:
    - User interface and interactions
    - User input handling
    - Client-side visual effects
    - Local state management
    - Audio and visual feedback
    - Client-side game features

### Project Structure

```
places/
├── common/          # Shared code between all places
│   ├── src/server/services/    # Server-side game logic
│   ├── src/client/controllers/ # Client-side game logic
│   └── src/shared/             # Shared utilities, types, and components
├── lobby/           # Lobby-specific code and features
├── gameplay/        # Main gameplay area code
└── afk/            # AFK area specific code
```

### File Organization Guidelines

- Group related functionality into focused services/controllers
- Use clear, descriptive naming conventions
- Keep shared utilities in the `shared` folder
- Separate concerns between client and server clearly

## Lifecycle Events

Flamework provides structured lifecycle management through interfaces:

- **OnInit()**:
    - Executed before dependency injection is complete
    - Use for critical initialization that doesn't depend on other services
    - Ideal for setting up internal state, constants, or data structures
    - Avoid calling other services in OnInit

- **OnStart()**:
    - Executed after all dependencies are injected and available
    - **Preferred for most initialization logic**
    - All services are guaranteed to be constructed and ready
    - Perfect for setting up connections, handlers, and cross-service interactions

- **OnTick()**:
    - Connected to `RunService.Heartbeat` (both client and server)
    - Runs every frame (approximately 60 FPS)
    - Use for game loop logic, continuous updates, and real-time calculations
    - Be mindful of performance - this runs frequently

- **OnRender()**:
    - **Client-only**, connected to `RunService.RenderStepped`
    - Runs before each frame is rendered
    - Use for smooth visual updates, camera effects, and UI animations
    - Higher priority than OnTick for visual fidelity

### Lifecycle Implementation Example

```ts
@Service()
export class ExampleService implements OnInit, OnStart, OnTick {
	private tickCounter = 0;

	constructor(private readonly dataService: DataService) {}

	onInit(): void {
		// Initialize internal state before dependencies are ready
		this.tickCounter = 0;
		print("ExampleService initialized");
	}

	onStart(): void {
		// Set up connections and interactions with other services
		this.setupPlayerHandlers();
		this.dataService.onDataLoaded.Connect(() => {
			print("Data loaded, service ready");
		});
	}

	onTick(): void {
		// Run every frame
		this.tickCounter++;
		if (this.tickCounter % 60 === 0) {
			// Every second logic
		}
	}

	private setupPlayerHandlers(): void {
		// Implementation
	}
}
```

## Dependency Injection

Flamework uses constructor-based dependency injection with automatic resolution:

### Basic Dependency Injection

```ts
@Service()
export class GameplayService implements OnStart {
	constructor(
		private readonly dataService: DataService,
		private readonly analyticsService: AnalyticsService,
		private readonly effectsService: EffectsService,
	) {}

	onStart() {
		// All dependencies are guaranteed to be available and ready
		this.setupGameplayLogic();
	}
}
```

### Dependency Resolution Rules

1. **Constructor Parameters**: Flamework automatically injects services/controllers based on their types
2. **Circular Dependencies**: Avoided through proper architecture - services should have clear hierarchies
3. **Optional Dependencies**: Use the `Dependency<T>()` macro sparingly for optional or dynamic dependencies
4. **Singleton Pattern**: All services and controllers are singletons by default

### Advanced Dependency Patterns

```ts
// Standard constructor injection (preferred)
@Service()
export class ShopService {
	constructor(
		private readonly dataService: DataService,
		private readonly playerService: PlayerService,
	) {}
}

// Dependency macro for special cases (use sparingly)
@Service()
export class SpecialService implements OnStart {
	private readonly optionalService = Dependency<OptionalService>();

	onStart() {
		// Can access optionalService here if needed
		if (this.optionalService) {
			this.optionalService.doSomething();
		}
	}
}

// Interface-based dependencies for better testability
interface IDataService {
	getPlayerData(player: Player): Promise<PlayerData>;
}

@Service()
export class TestableService {
	constructor(private readonly dataService: IDataService) {}
}
```

## Service Development Patterns

### Complete Service Structure Template

```ts
import { Service, OnStart, OnInit } from "@flamework/core";
import { Players, RunService } from "@rbxts/services";
import { DataService } from "./data.service";
import { safePlayerAdded } from "../../shared/utils/safe-player-added.util";

@Service()
export class GameFeatureService implements OnStart {
	// Constants and readonly properties
	private readonly FEATURE_CONSTANTS = {
		COOLDOWN_TIME: 5,
		MAX_ATTEMPTS: 3,
	} as const;

	// State management
	private activeFeatures = new Map<Player, FeatureState>();
	private connections: RBXScriptConnection[] = [];

	constructor(
		private readonly dataService: DataService,
		private readonly playerService: PlayerService,
	) {}

	onStart(): void {
		this.setupPlayerHandlers();
		this.setupPeriodicTasks();
		this.setupEventListeners();
	}

	// Public API methods
	public async activateFeature(player: Player, featureType: FeatureType): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) return false;

		// Feature activation logic
		return true;
	}

	public getFeatureState(player: Player): FeatureState | undefined {
		return this.activeFeatures.get(player);
	}

	// Private implementation methods
	private setupPlayerHandlers(): void {
		// Handle players joining (including existing players)
		const connection = safePlayerAdded((player) => {
			this.handlePlayerJoined(player);
		});
		this.connections.push(connection);

		// Handle players leaving
		const leavingConnection = Players.PlayerRemoving.Connect((player) => {
			this.handlePlayerLeaving(player);
		});
		this.connections.push(leavingConnection);
	}

	private async handlePlayerJoined(player: Player): Promise<void> {
		// Initialize feature state for the player
		this.activeFeatures.set(player, {
			isActive: false,
			lastActivated: 0,
			attempts: 0,
		});

		// Load player-specific feature data
		const playerData = await this.dataService.getCache(player);
		if (playerData?.FeatureData) {
			// Restore feature state from saved data
		}
	}

	private handlePlayerLeaving(player: Player): void {
		// Clean up player state
		this.activeFeatures.delete(player);

		// Save any important state before cleanup
		this.saveFeatureState(player);
	}

	private setupPeriodicTasks(): void {
		// Example: Reset feature cooldowns every hour
		const resetConnection = RunService.Heartbeat.Connect(() => {
			// Periodic logic here
		});
		this.connections.push(resetConnection);
	}

	private setupEventListeners(): void {
		// Set up any game event listeners
	}

	private async saveFeatureState(player: Player): Promise<void> {
		// Save current feature state to data service
	}

	// Cleanup method (if needed)
	public destroy(): void {
		// Disconnect all connections
		this.connections.forEach((connection) => connection.Disconnect());
		this.connections.clear();
		this.activeFeatures.clear();
	}
}

// Type definitions
interface FeatureState {
	isActive: boolean;
	lastActivated: number;
	attempts: number;
}

type FeatureType = "boost" | "upgrade" | "special";
```

### Controller Development Pattern

```ts
import { Controller, OnStart } from "@flamework/core";
import { Players, UserInputService, RunService } from "@rbxts/services";
import { UIService } from "./ui.service";

@Controller()
export class InputController implements OnStart {
	private readonly INPUT_BINDINGS = {
		TOGGLE_MENU: Enum.KeyCode.M,
		QUICK_ACTION: Enum.KeyCode.Q,
	} as const;

	private connections: RBXScriptConnection[] = [];
	private isMenuOpen = false;

	constructor(
		private readonly uiService: UIService,
		private readonly soundController: SoundController,
	) {}

	onStart(): void {
		this.setupInputHandlers();
		this.setupUIConnections();
	}

	// Public API
	public isInputLocked(): boolean {
		return this.uiService.isModalOpen() || this.isMenuOpen;
	}

	public lockInput(locked: boolean): void {
		// Implementation for locking/unlocking input
	}

	// Private methods
	private setupInputHandlers(): void {
		const inputConnection = UserInputService.InputBegan.Connect((input, gameProcessed) => {
			if (gameProcessed || this.isInputLocked()) return;

			if (input.KeyCode === this.INPUT_BINDINGS.TOGGLE_MENU) {
				this.toggleMenu();
			} else if (input.KeyCode === this.INPUT_BINDINGS.QUICK_ACTION) {
				this.handleQuickAction();
			}
		});
		this.connections.push(inputConnection);
	}

	private setupUIConnections(): void {
		// Connect to UI events
		this.uiService.onMenuToggled.Connect((isOpen) => {
			this.isMenuOpen = isOpen;
		});
	}

	private toggleMenu(): void {
		this.isMenuOpen = !this.isMenuOpen;
		this.uiService.toggleMenu(this.isMenuOpen);
		this.soundController.playUISound("menu_toggle");
	}

	private handleQuickAction(): void {
		// Quick action implementation
	}

	public destroy(): void {
		this.connections.forEach((connection) => connection.Disconnect());
		this.connections.clear();
	}
}
```

## Best Practices

### Service Organization

```ts
// GOOD: Well-structured game service
@Service()
export class ShopService implements OnStart {
	private readonly SHOP_TYPES = ["Event", "Raid", "Dungeon"] as const;

	constructor(private readonly dataService: DataService) {}

	onStart(): void {
		this.setupPlayerJoinedHandler();
		this.setupPeriodicResets();
	}

	// Public API methods
	public async purchaseItem(player: Player, shopType: string, itemId: string): Promise<boolean> {
		// Implementation
	}

	// Private helper methods
	private setupPlayerJoinedHandler(): void {
		safePlayerAdded((player) => {
			// Initialize shop data for new players
		});
	}

	private setupPeriodicResets(): void {
		// Handle daily/weekly shop resets
	}
}
```

### Data Service Integration Pattern

```ts
@Service()
export class FeatureService implements OnStart {
	private readonly featureCache = new Map<Player, FeatureData>();

	constructor(
		private readonly dataService: DataService,
		private readonly analyticsService: AnalyticsService,
	) {}

	onStart(): void {
		// Set up data synchronization
		this.dataService.onPlayerDataLoaded.Connect((player, data) => {
			this.featureCache.set(player, data.FeatureData || this.getDefaultFeatureData());
		});

		this.dataService.onPlayerDataSaved.Connect((player) => {
			// Handle data save events if needed
		});
	}

	// Public API methods with proper error handling and caching
	public async getPlayerFeatureData(player: Player): Promise<FeatureData | undefined> {
		// Try cache first for performance
		const cached = this.featureCache.get(player);
		if (cached) return cached;

		// Fallback to data service
		const playerData = await this.dataService.getCache(player);
		if (!playerData) return undefined;

		const featureData = playerData.FeatureData || this.getDefaultFeatureData();
		this.featureCache.set(player, featureData);
		return featureData;
	}

	public async updatePlayerFeatureData(
		player: Player,
		updates: Partial<FeatureData>,
		saveImmediately = false,
	): Promise<boolean> {
		try {
			const currentData = await this.getPlayerFeatureData(player);
			if (!currentData) return false;

			const newFeatureData = { ...currentData, ...updates };

			// Update cache
			this.featureCache.set(player, newFeatureData);

			// Update data service
			const playerData = await this.dataService.getCache(player);
			if (!playerData) return false;

			const updatedPlayerData = { ...playerData };
			updatedPlayerData.FeatureData = newFeatureData;

			this.dataService.setCache(player, updatedPlayerData);

			if (saveImmediately) {
				await this.dataService.savePlayerData(player);
			}

			// Analytics tracking
			this.analyticsService.trackFeatureUpdate(player, updates);

			return true;
		} catch (error) {
			warn(`Failed to update feature data for ${player.Name}: ${error}`);
			return false;
		}
	}

	public async incrementFeatureValue(player: Player, field: keyof FeatureData, amount: number): Promise<boolean> {
		const currentData = await this.getPlayerFeatureData(player);
		if (!currentData || typeof currentData[field] !== "number") return false;

		const updates = { [field]: (currentData[field] as number) + amount };
		return this.updatePlayerFeatureData(player, updates as Partial<FeatureData>);
	}

	private getDefaultFeatureData(): FeatureData {
		return {
			level: 1,
			experience: 0,
			lastActive: DateTime.now().UnixTimestamp,
			settings: {
				autoSave: true,
				notifications: true,
			},
		};
	}

	// Cleanup when player leaves
	public onPlayerLeaving(player: Player): void {
		this.featureCache.delete(player);
	}
}

// Type definitions
interface FeatureData {
	level: number;
	experience: number;
	lastActive: number;
	settings: {
		autoSave: boolean;
		notifications: boolean;
	};
}
```

## Best Practices & Code Standards

### Service Organization Principles

```ts
// EXCELLENT: Well-structured, focused service
@Service()
export class ShopService implements OnStart {
	// Clear constants grouped logically
	private readonly SHOP_TYPES = ["Event", "Raid", "Dungeon"] as const;
	private readonly REFRESH_INTERVALS = {
		DAILY: 24 * 60 * 60,
		WEEKLY: 7 * 24 * 60 * 60,
	} as const;

	// State management with proper typing
	private readonly playerShopStates = new Map<Player, ShopState>();
	private connections: RBXScriptConnection[] = [];

	constructor(
		private readonly dataService: DataService,
		private readonly economyService: EconomyService,
		private readonly analyticsService: AnalyticsService,
	) {}

	onStart(): void {
		this.setupPlayerHandlers();
		this.setupPeriodicResets();
		this.setupShopEvents();
	}

	// Clear, focused public API
	public async purchaseItem(player: Player, shopType: ShopType, itemId: string): Promise<PurchaseResult> {
		try {
			// Validate purchase
			const validationResult = await this.validatePurchase(player, shopType, itemId);
			if (!validationResult.isValid) {
				return { success: false, reason: validationResult.reason };
			}

			// Process purchase
			const cost = await this.getItemCost(shopType, itemId);
			const deductResult = await this.economyService.deductCurrency(player, cost);

			if (!deductResult.success) {
				return { success: false, reason: "insufficient_funds" };
			}

			// Grant item and update data
			await this.grantItemToPlayer(player, itemId);
			await this.updatePurchaseHistory(player, shopType, itemId);

			// Analytics
			this.analyticsService.trackPurchase(player, shopType, itemId, cost);

			return { success: true, item: itemId };
		} catch (error) {
			warn(`Purchase failed for ${player.Name}: ${error}`);
			return { success: false, reason: "internal_error" };
		}
	}

	public getShopState(player: Player): ShopState | undefined {
		return this.playerShopStates.get(player);
	}

	// Well-organized private methods
	private setupPlayerHandlers(): void {
		const joinConnection = safePlayerAdded((player) => {
			this.initializePlayerShop(player);
		});
		this.connections.push(joinConnection);

		const leaveConnection = Players.PlayerRemoving.Connect((player) => {
			this.cleanupPlayerShop(player);
		});
		this.connections.push(leaveConnection);
	}

	private setupPeriodicResets(): void {
		// Use proper timing for shop resets
		const resetConnection = RunService.Heartbeat.Connect(() => {
			const now = DateTime.now().UnixTimestamp;
			// Check for daily/weekly resets
		});
		this.connections.push(resetConnection);
	}

	private async validatePurchase(player: Player, shopType: ShopType, itemId: string): Promise<ValidationResult> {
		// Comprehensive validation logic
		return { isValid: true };
	}

	private async initializePlayerShop(player: Player): Promise<void> {
		const shopData = await this.dataService.getPlayerShopData(player);
		this.playerShopStates.set(player, shopData || this.getDefaultShopState());
	}

	private cleanupPlayerShop(player: Player): void {
		this.playerShopStates.delete(player);
	}

	// Proper cleanup
	public destroy(): void {
		this.connections.forEach((connection) => connection.Disconnect());
		this.connections.clear();
		this.playerShopStates.clear();
	}
}

// Well-defined types
type ShopType = "Event" | "Raid" | "Dungeon";

interface ShopState {
	lastRefresh: number;
	purchaseHistory: PurchaseRecord[];
	availableItems: string[];
}

interface PurchaseResult {
	success: boolean;
	reason?: string;
	item?: string;
}

interface ValidationResult {
	isValid: boolean;
	reason?: string;
}
```

### Dependency Management Best Practices

```ts
// GOOD: Clear dependency hierarchy
@Service()
export class HighLevelService {
	constructor(
		private readonly dataService: DataService, // Core dependency
		private readonly playerService: PlayerService, // Core dependency
		private readonly analyticsService: AnalyticsService, // Optional dependency
	) {}
}

// AVOID: Circular dependencies
// Don't have ServiceA depend on ServiceB if ServiceB depends on ServiceA

// GOOD: Use interfaces for testability
interface IDataProvider {
	getData(key: string): Promise<unknown>;
}

@Service()
export class TestableService {
	constructor(private readonly dataProvider: IDataProvider) {}
}

// AVOID: Using Dependency<T>() everywhere
// Only use when you have special initialization requirements
```

## Component System

Flamework's component system allows you to attach behavior to specific game instances:

### Basic Component Structure

```ts
import { Component, BaseComponent } from "@flamework/components";
import { OnStart } from "@flamework/core";

@Component({ tag: "InteractableNPC" })
export class NPCComponent extends BaseComponent<NPCAttributes, Model> implements OnStart {
	constructor(
		private readonly dialogService: DialogService,
		private readonly questService: QuestService,
	) {
		super();
	}

	onStart(): void {
		this.setupInteraction();
		this.setupVisualEffects();
	}

	private setupInteraction(): void {
		const clickDetector = this.instance.FindFirstChild("ClickDetector") as ClickDetector;
		if (!clickDetector) return;

		clickDetector.MouseClick.Connect((player) => {
			this.handlePlayerInteraction(player);
		});
	}

	private setupVisualEffects(): void {
		// Add hover effects, animations, etc.
		const highlight = new Instance("SelectionBox");
		highlight.Parent = this.instance;
		highlight.Adornee = this.instance;
		highlight.Color3 = Color3.fromRGB(0, 255, 0);
		highlight.Transparency = 0.8;
		highlight.Visible = false;
	}

	private handlePlayerInteraction(player: Player): void {
		const npcData = this.attributes;

		if (npcData.questId) {
			this.questService.startQuest(player, npcData.questId);
		} else if (npcData.dialogId) {
			this.dialogService.startDialog(player, npcData.dialogId);
		}
	}

	// Component cleanup
	public destroy(): void {
		// Cleanup logic here
		super.destroy();
	}
}

// Component attributes interface
interface NPCAttributes {
	questId?: string;
	dialogId?: string;
	interactionRange?: number;
}
```

### Advanced Component Patterns

```ts
// Component with lifecycle events
@Component({ tag: "TimedEffect" })
export class TimedEffectComponent extends BaseComponent<TimedEffectAttributes, BasePart> implements OnStart, OnTick {
	private startTime = 0;
	private isActive = false;

	onStart(): void {
		this.startTime = tick();
		this.isActive = true;
		this.applyEffect();
	}

	onTick(): void {
		if (!this.isActive) return;

		const elapsed = tick() - this.startTime;
		const duration = this.attributes.duration || 5;

		if (elapsed >= duration) {
			this.removeEffect();
			this.destroy();
		} else {
			this.updateEffect(elapsed / duration);
		}
	}

	private applyEffect(): void {
		// Apply visual/audio effects
		const effectType = this.attributes.effectType;
		switch (effectType) {
			case "glow":
				this.applyGlowEffect();
				break;
			case "pulse":
				this.applyPulseEffect();
				break;
		}
	}

	private updateEffect(progress: number): void {
		// Update effect based on progress (0 to 1)
	}

	private removeEffect(): void {
		this.isActive = false;
		// Cleanup effect
	}
}

interface TimedEffectAttributes {
	duration: number;
	effectType: "glow" | "pulse" | "rotate";
	intensity?: number;
}
```

### Component Registration and Usage

```ts
// In your game initialization
import { Components } from "@flamework/components";

// Register components
Components.addComponent(NPCComponent);
Components.addComponent(TimedEffectComponent);

// Components are automatically applied to instances with matching tags
// Set tags in Studio or via code:

// Via code:
const npcModel = workspace.FindFirstChild("NPCModel") as Model;
if (npcModel) {
	npcModel.SetAttribute("questId", "tutorial_quest_1");
	npcModel.AddTag("InteractableNPC");
}

// Components will automatically attach when instances are tagged
```

## Project Initialization & Setup

### Flamework Ignition Pattern

Each place needs proper Flamework initialization:

```ts
// src/server/main.server.ts
import { Flamework } from "@flamework/core";

// Add paths for server-side code
Flamework.addPaths("src/server/services");
Flamework.addPaths("src/shared/components");

// Start the framework
Flamework.ignite();
```

```ts
// src/client/main.client.ts
import { Flamework } from "@flamework/core";

// Add paths for client-side code
Flamework.addPaths("src/client/controllers");
Flamework.addPaths("src/shared/components");

// Start the framework
Flamework.ignite();
```

### Multi-Place Architecture

```ts
// places/common/src/server/main.server.ts - Shared server logic
import { Flamework } from "@flamework/core";

Flamework.addPaths("src/server/services");
Flamework.addPaths("../../common/src/server/services"); // Shared services
Flamework.addPaths("src/shared/components");
Flamework.addPaths("../../common/src/shared/components"); // Shared components

Flamework.ignite();
```

```ts
// places/lobby/src/server/main.server.ts - Lobby-specific logic
import { Flamework } from "@flamework/core";

// Include common services
Flamework.addPaths("../../common/src/server/services");
Flamework.addPaths("../../common/src/shared/components");

// Include lobby-specific services
Flamework.addPaths("src/server/services");
Flamework.addPaths("src/shared/components");

Flamework.ignite();
```

## Error Handling & Debugging

### Service Error Handling

```ts
@Service()
export class RobustService implements OnStart {
	onStart(): void {
		try {
			this.initializeService();
		} catch (error) {
			warn(`Failed to initialize ${this.constructor.name}: ${error}`);
			// Graceful degradation
			this.initializeFallbackMode();
		}
	}

	public async performCriticalOperation(player: Player): Promise<OperationResult> {
		try {
			// Critical operation
			const result = await this.executeCriticalLogic(player);
			return { success: true, data: result };
		} catch (error) {
			warn(`Critical operation failed for ${player.Name}: ${error}`);

			// Log for debugging
			this.logError("performCriticalOperation", error, { playerId: player.UserId });

			return { success: false, error: "Operation failed" };
		}
	}

	private logError(operation: string, error: unknown, context: Record<string, unknown>): void {
		// Implement proper error logging
		const errorData = {
			service: this.constructor.name,
			operation,
			error: tostring(error),
			context,
			timestamp: DateTime.now().UnixTimestamp,
		};

		// Send to analytics/logging service
		warn(`Error Log: ${game.HttpService.JSONEncode(errorData)}`);
	}
}

interface OperationResult {
	success: boolean;
	data?: unknown;
	error?: string;
}
```

### Debugging Utilities

```ts
// Shared debugging utilities
export namespace Debug {
	export const IS_DEVELOPMENT = game.PlaceId === 0; // Studio mode

	export function log(message: string, context?: Record<string, unknown>): void {
		if (!IS_DEVELOPMENT) return;

		const contextStr = context ? ` | ${game.HttpService.JSONEncode(context)}` : "";
		print(`[DEBUG] ${message}${contextStr}`);
	}

	export function assert(condition: boolean, message: string): asserts condition {
		if (!condition) {
			throw new Error(`Assertion failed: ${message}`);
		}
	}

	export function time<T>(label: string, fn: () => T): T {
		if (!IS_DEVELOPMENT) return fn();

		const start = tick();
		const result = fn();
		const elapsed = tick() - start;

		print(`[TIMER] ${label}: ${elapsed}ms`);
		return result;
	}
}

// Usage in services
@Service()
export class DebuggableService implements OnStart {
	onStart(): void {
		Debug.log("Service starting", { serviceName: this.constructor.name });

		Debug.time("Service initialization", () => {
			this.performExpensiveInitialization();
		});
	}

	public performOperation(input: unknown): void {
		Debug.assert(input !== undefined, "Input cannot be undefined");
		// Rest of implementation
	}
}
```

## Performance Optimization

### Efficient Service Patterns

```ts
@Service()
export class OptimizedService implements OnStart, OnTick {
	// Use object pools to reduce garbage collection
	private readonly objectPool = new Array<ReusableObject>();
	private readonly poolSize = 100;

	// Cache frequently accessed data
	private readonly playerCache = new Map<Player, CachedPlayerData>();
	private readonly configCache = new Map<string, unknown>();

	// Batch operations for better performance
	private readonly pendingUpdates = new Array<UpdateOperation>();
	private updateBatchSize = 50;

	onStart(): void {
		this.initializeObjectPool();
		this.setupPerformanceMonitoring();
	}

	onTick(): void {
		// Process batched updates
		this.processPendingUpdates();

		// Update performance metrics
		this.updatePerformanceMetrics();
	}

	// Efficient object pooling
	public getPooledObject(): ReusableObject {
		return this.objectPool.pop() || new ReusableObject();
	}

	public returnToPool(obj: ReusableObject): void {
		if (this.objectPool.size() < this.poolSize) {
			obj.reset();
			this.objectPool.push(obj);
		}
	}

	// Efficient caching strategy
	public async getPlayerData(player: Player): Promise<CachedPlayerData> {
		const cached = this.playerCache.get(player);
		if (cached && this.isCacheValid(cached)) {
			return cached;
		}

		const freshData = await this.loadPlayerData(player);
		this.playerCache.set(player, freshData);
		return freshData;
	}

	// Batch operations to reduce overhead
	public queueUpdate(operation: UpdateOperation): void {
		this.pendingUpdates.push(operation);
	}

	private processPendingUpdates(): void {
		if (this.pendingUpdates.size() === 0) return;

		const batch = this.pendingUpdates.splice(0, this.updateBatchSize);
		this.processBatch(batch);
	}

	private setupPerformanceMonitoring(): void {
		// Monitor service performance
		this.monitorMemoryUsage();
		this.monitorExecutionTime();
	}
}
```

### Memory Management

```ts
@Service()
export class MemoryEfficientService implements OnStart {
	private connections: RBXScriptConnection[] = [];
	private temporaryObjects = new Set<Instance>();

	onStart(): void {
		// Proper connection management
		this.setupConnections();

		// Memory cleanup intervals
		this.setupMemoryCleanup();
	}

	private setupConnections(): void {
		const connection = SomeService.SomeEvent.Connect((data) => {
			this.handleEvent(data);
		});
		this.connections.push(connection);
	}

	private setupMemoryCleanup(): void {
		// Clean up temporary objects periodically
		const cleanupConnection = task.wait(30, () => {
			this.cleanupTemporaryObjects();
		});
		this.connections.push(cleanupConnection);
	}

	private cleanupTemporaryObjects(): void {
		for (const obj of this.temporaryObjects) {
			if (obj.Parent === undefined) {
				this.temporaryObjects.delete(obj);
			}
		}
	}

	// Proper cleanup on service destruction
	public destroy(): void {
		// Disconnect all connections
		this.connections.forEach((conn) => conn.Disconnect());
		this.connections.clear();

		// Clean up temporary objects
		this.temporaryObjects.forEach((obj) => obj.Destroy());
		this.temporaryObjects.clear();

		// Clear any caches/maps
		// this.someCache.clear();
	}
}
```

## Game-Specific Implementation Guidelines

### Multi-Place Architecture Benefits

This project structure provides several key advantages:

- **Code Reusability**: Shared services work across lobby, gameplay, and AFK areas
- **Modular Development**: Each place can have specific features while sharing core logic
- **Type Safety**: Strong typing for player data and game state across all places
- **Scalable Architecture**: Easy to add new features without breaking existing code
- **Centralized Data Management**: Consistent data handling across all game areas

### Feature Implementation Strategy

```ts
// Shared core service (in common)
@Service()
export class CoreFeatureService implements OnStart {
	// Core functionality that works everywhere
}

// Place-specific extension (in lobby/gameplay/afk)
@Service()
export class LobbyFeatureService implements OnStart {
	constructor(private readonly coreFeature: CoreFeatureService) {}

	// Lobby-specific enhancements
}
```

### Best Practices Summary

1. **Use OnStart() for most initialization** - dependencies are guaranteed to be ready
2. **Implement proper cleanup** - always disconnect connections and clear caches
3. **Cache frequently accessed data** - but implement cache invalidation strategies
4. **Use batch processing** - for operations that can be grouped together
5. **Handle errors gracefully** - provide fallbacks and log meaningful error information
6. **Follow single responsibility principle** - each service should have one clear purpose
7. **Use TypeScript types effectively** - define clear interfaces for data structures
8. **Monitor performance** - especially in OnTick and OnRender implementations
9. **Implement proper player state management** - handle joins/leaves consistently
10. **Use components for instance-specific behavior** - keep game objects organized

### Common Patterns to Follow

- **Data Layer**: Services that manage persistence and caching
- **Business Logic Layer**: Services that implement game rules and mechanics
- **Presentation Layer**: Controllers that handle UI and user interactions
- **Infrastructure Layer**: Shared utilities, constants, and helper functions

This architecture ensures maintainable, scalable, and robust game development using Flamework's powerful features.
