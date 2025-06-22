import { Service, OnInit, OnStart } from "@flamework/core";
import { Players, RunService } from "@rbxts/services";
import { DataService } from "./data.service"; // Assuming DataService might be needed for player data
import { PlayerManagerService } from "./player-manager.service"; // Assuming PlayerManagerService might be needed

interface RobloxAnalyticsService {
	ReportEvent: (player: Player, eventName: string, eventContext?: unknown, eventSpecificData?: unknown) => void;
}

interface SessionData {
	joinTime: number;
	lastActivity: number;
}

interface AnalyticsEvent {
	player?: Player;
	eventName: string;
	parameters: Map<string, unknown>;
	timestamp: number;
}

const BATCH_SIZE = 50;
const BATCH_INTERVAL = 30; // seconds
const PERFORMANCE_TRACK_INTERVAL = 300; // 5 minutes

@Service({
	loadOrder: 5, // Matches old script's load order
})
export class AnalyticsService implements OnInit, OnStart {
	private pendingEvents: AnalyticsEvent[] = [];
	private sessionData = new Map<Player, SessionData>();

	constructor(
		private readonly dataService: DataService,
		private readonly playerManagerService: PlayerManagerService,
		private readonly robloxAnalytics: RobloxAnalyticsService, // Inject Roblox Analytics Service
	) {}

	onInit(): void {
		Players.PlayerAdded.Connect((player) => this.handlePlayerJoined(player));
		Players.PlayerRemoving.Connect((player) => this.handlePlayerLeft(player));

		// Set up final event processing when the server shuts down
		game.BindToClose(() => {
			this.processPendingEvents(true); // Process all remaining events
		});
		print("AnalyticsService Initialized");
	}

	onStart(): void {
		// Set up periodic event processing
		task.spawn(() => {
			// eslint-disable-next-line no-constant-condition
			while (true) {
				task.wait(BATCH_INTERVAL);
				if (RunService.IsRunning()) {
					this.processPendingEvents();
				} else {
					break;
				}
			}
		});

		// Set up periodic performance tracking
		task.spawn(() => {
			// eslint-disable-next-line no-constant-condition
			while (true) {
				task.wait(PERFORMANCE_TRACK_INTERVAL);
				if (RunService.IsRunning()) {
					for (const [player] of this.sessionData) {
						if (player.Parent) {
							this.trackPerformance(player);
						}
					}
				} else {
					break;
				}
			}
		});
		print("AnalyticsService Started");
	}

	private async handlePlayerJoined(player: Player): Promise<void> {
		const joinTime = os.time();
		this.sessionData.set(player, {
			joinTime: joinTime,
			lastActivity: joinTime,
		});

		// Wait for player data to be ready if needed, or get basic info
		// This might require coordination with PlayerManagerService or DataService
		// For now, let's assume we can get some basic data or proceed without it
		// Example: const playerData = await this.dataService.getCache(player);

		// For simplicity, replicating old logic's direct cache access if possible,
		// otherwise, this needs robust handling via DataService
		// This part needs careful review based on how `person.dataCache()` worked
		// let level = 1;
		// let playtime = 0;
		// let gamesPlayed = 0;
		// if (playerData) {
		//     level = playerData.Level ?? 1;
		//     playtime = playerData.PlayerStatistics?.PlayTime ?? 0;
		//     gamesPlayed = playerData.PlayerStatistics?.GamesPlayed ?? 0;
		// }

		this.trackEvent(
			player,
			"PlayerJoined",
			new Map<string, unknown>([
				// ["level", level], // Placeholder, requires data access
				// ["playtime", playtime], // Placeholder
				// ["gamesPlayed", gamesPlayed], // Placeholder
			]),
		);

		player.CharacterAdded.Connect(() => this.handleCharacterAdded(player));
	}

	private handlePlayerLeft(player: Player): void {
		const leaveTime = os.time();
		const sessionInfo = this.sessionData.get(player);

		if (sessionInfo) {
			const sessionDuration = leaveTime - sessionInfo.joinTime;

			this.trackEvent(
				player,
				"PlayerLeft",
				new Map<string, unknown>([
					["sessionDuration", sessionDuration],
					["playtime", sessionDuration], // Consistent with old logic
				]),
			);

			this.sessionData.delete(player);
		}
	}

	private handleCharacterAdded(player: Player): void {
		const sessionInfo = this.sessionData.get(player);
		if (sessionInfo) {
			sessionInfo.lastActivity = os.time();
			this.sessionData.set(player, sessionInfo); // Update the map
		}

		this.trackEvent(player, "CharacterSpawned", new Map<string, unknown>([["spawnTime", os.time()]]));
	}

	public trackEvent(player: Player | undefined, eventName: string, parameters: Map<string, unknown>): void {
		this.pendingEvents.push({
			player: player,
			eventName: eventName,
			parameters: parameters,
			timestamp: os.time(),
		});
	}

	public trackError(errorMessage: string, errorType: string): void {
		const parameters = new Map<string, unknown>([
			["errorMessage", errorMessage],
			["errorType", errorType],
			["timestamp", os.time()],
		]);
		this.trackEvent(undefined, "SystemError", parameters);
	}

	public trackPerformance(player: Player): void {
		const sessionInfo = this.sessionData.get(player);
		if (!sessionInfo) {
			return;
		}

		const currentTime = os.time();
		const sessionDuration = currentTime - sessionInfo.joinTime;
		// const playerData = await this.dataService.getCache(player); // Requires async handling or different approach

		// let level = 1;
		// if (playerData) {
		//     level = playerData.Level ?? 1;
		// }

		this.trackEvent(
			player,
			"PerformanceMetrics",
			new Map<string, unknown>([
				["sessionDuration", sessionDuration],
				// ["level", level], // Placeholder
				["playtime", sessionDuration], // Consistent with old logic
			]),
		);
	}

	public getSessionData(
		player: Player,
	): { joinTime?: number; lastActivity?: number; sessionDuration?: number } | undefined {
		const info = this.sessionData.get(player);
		if (info) {
			return {
				joinTime: info.joinTime,
				lastActivity: info.lastActivity,
				sessionDuration: os.time() - info.joinTime,
			};
		}
		return undefined;
	}

	private processPendingEvents(isShuttingDown = false): void {
		if (this.pendingEvents.size() === 0) {
			return;
		}

		const eventsToProcess = isShuttingDown
			? this.pendingEvents.size()
			: math.min(BATCH_SIZE, this.pendingEvents.size());

		for (let i = 0; i < eventsToProcess; i++) {
			const event = this.pendingEvents.shift(); // Get and remove the first event
			if (!event) continue;

			try {
				if (event.player && event.player.Parent) {
					// Convert parameters Map to a format accepted by RobloxAnalyticsService
					// Roblox's Standard Events expect specific parameter names and types.
					// For custom events, it's often simpler to send a serialized string or fewer, structured params.
					// The old script did: AnalyticsService:LogCustomEvent(event.player, event.eventName)
					// The new equivalent is robloxAnalytics.ReportEvent(player, eventName, eventContext, eventSpecificData)
					// For simplicity, and matching the old script's limited parameter usage with LogCustomEvent,
					// we might need to adjust how parameters are sent or focus on the event name.

					// Example: Basic custom event reporting (might need adjustment based on actual API needs)
					// This is a simplified version. The actual Roblox API might require more specific formatting for parameters.
					// The old code did *not* pass parameters to LogCustomEvent, only event.player and event.eventName.
					// So, to match that, we would do:
					this.robloxAnalytics.ReportEvent(event.player, event.eventName);
					// If we want to include parameters, we need to structure them according to Roblox's expectations.
					// For example, as a dictionary:
					// const paramsForRoblox: { [key: string]: string | number | boolean } = {};
					// event.parameters.forEach((value, key) => {
					//     if (typeIs(value, "string") || typeIs(value, "number") || typeIs(value, "boolean")) {
					//         paramsForRoblox[key] = value;
					//     } else {
					//         paramsForRoblox[key] = tostring(value); // Fallback to string
					//     }
					// });
					// this.robloxAnalytics.ReportEvent(event.player, event.eventName, undefined, paramsForRoblox);
				} else if (!event.player) {
					// For system events without a player
					// The ReportEvent API requires a player. How to log system-wide events needs consideration.
					// One common approach is to have a dedicated "system" Player object or log through an external service if available.
					// Or, if RobloxAnalyticsService allows event reporting without a player context (unlikely for ReportEvent), use that.
					// For now, we'll log a warning if it's a system event, as direct porting is tricky.
					print(`Analytics: System event "${event.eventName}" logged. Parameters:`, event.parameters);
				}
			} catch (e) {
				warn(`Analytics error processing event "${event.eventName}": ${e}`);
			}
		}
	}
}
