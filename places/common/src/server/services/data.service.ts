// Data service for managing player data using ProfileStore and Promises
// Converted from Luau to TypeScript with Flamework service architecture

import { Service, OnInit } from "@flamework/core";
import { Players, RunService } from "@rbxts/services";
import ProfileStore from "@rbxts/profile-store";

import { DataTemplate, DATA_TEMPLATE, DailyRewardsData } from "../../shared/data/data-template";
import { DATA_CONSTANTS } from "../../shared/constants/data-constants";
import { migrations } from "../../shared/utils/migrations";
import { performance } from "../../shared/utils/performance";
import { validateDataSection } from "../../shared/utils/validate";
import { deepCopy } from "../../shared/utils/deep-copy";

// Let TypeScript infer the types from the actual ProfileStore calls
type DataProfileStore = ReturnType<typeof ProfileStore.New<DataTemplate>>;
type MockDataProfileStore = DataProfileStore["Mock"];
type DataProfile = NonNullable<ReturnType<DataProfileStore["StartSessionAsync"]>>;

interface ServiceVersion {
	major: number;
	minor: number;
	patch: number;
}

/**
 * Flamework service for managing player data operations.
 * Handles data loading, saving, validation, and migrations.
 */
@Service()
export class DataService implements OnInit {
	public readonly CONSTANTS = DATA_CONSTANTS;
	public readonly template = DATA_TEMPLATE;
	public readonly version: ServiceVersion = { major: 1, minor: 0, patch: 0 };

	private readonly CURRENT_DATA_VERSION = migrations.CurrentVersion;
	private readonly playerStore: DataProfileStore | MockDataProfileStore;
	private readonly profiles = new Map<Player, DataProfile>();
	private readonly threadsPendingSessionEndedLoad = new Map<Player, thread[]>();

	constructor() {
		// Initialize ProfileStore based on environment
		this.playerStore = RunService.IsStudio()
			? ProfileStore.New(DATA_CONSTANTS.DATASTORE_NAME, DATA_TEMPLATE).Mock
			: ProfileStore.New(DATA_CONSTANTS.DATASTORE_NAME, DATA_TEMPLATE);
	}

	public onInit(): void {
		this.initializeMigrations();
		print("DataService initialized");
	}

	/**
	 * Checks if player data is currently loading
	 */
	private isLoading(player: Player): boolean {
		return !this.profiles.has(player);
	}

	/**
	 * Waits for a player's session to end asynchronously
	 */
	public waitForPersonSessionEndedAsync(player: Player): Promise<void> {
		return new Promise<void>((resolve) => {
			if (!this.isLoading(player)) {
				resolve();
				return;
			}

			const threads = this.threadsPendingSessionEndedLoad.get(player) || [];
			threads.push(coroutine.running());
			this.threadsPendingSessionEndedLoad.set(player, threads);

			coroutine.yield();
			resolve();
		});
	}

	/**
	 * Resumes threads that were waiting for session ended load
	 */
	private resumeThreadsPendingSessionEndedLoad(player: Player): void {
		const threads = this.threadsPendingSessionEndedLoad.get(player);
		if (threads) {
			for (const thread of threads) {
				task.spawn(thread);
			}
		}
		this.threadsPendingSessionEndedLoad.delete(player);
	}

	/**
	 * Cancels threads that were waiting for session ended load
	 */
	private cancelThreadsPendingSessionEndedLoad(player: Player): void {
		const threads = this.threadsPendingSessionEndedLoad.get(player);
		if (threads) {
			for (const thread of threads) {
				coroutine.resume(thread);
			}
		}
		this.threadsPendingSessionEndedLoad.delete(player);
	}

	/**
	 * Deeply merges user data with template defaults
	 */
	private deepMergeWithTemplate(userData: unknown, template: unknown): unknown {
		if (typeOf(template) !== "table") {
			return userData !== undefined ? userData : template;
		}

		if (typeOf(userData) !== "table") {
			return userData !== undefined ? userData : deepCopy(template);
		}

		const result: Record<string, unknown> = {};
		const templateTable = template as Record<string, unknown>;
		const userDataTable = userData as Record<string, unknown>;

		// Add all fields from template
		for (const [key, templateValue] of pairs(templateTable)) {
			const userValue = userDataTable[key];
			if (typeOf(templateValue) === "table") {
				result[key] = this.deepMergeWithTemplate(userValue, templateValue);
			} else {
				result[key] = userValue !== undefined ? userValue : templateValue;
			}
		}

		// Add extra fields from userData
		for (const [key, userValue] of pairs(userDataTable)) {
			if (templateTable[key] === undefined) {
				result[key] = typeOf(userValue) === "table" ? deepCopy(userValue) : userValue;
			}
		}

		return result;
	}

	/**
	 * Performs data validation and ensures compatibility with template
	 */
	public dataCheck(value: unknown): DataTemplate {
		performance.enable();

		return performance.measure("data_validation", () => {
			assert(typeOf(value) === "table", "Data must be a table");

			const dataTable = value as Record<string, unknown>;

			// Handle versioning for migrations
			if (dataTable._version === undefined) {
				dataTable._version = 1;
			}

			const version = dataTable._version as number;

			// Apply migrations if needed
			if (version < this.CURRENT_DATA_VERSION) {
				const [migrated, newVersion] = migrations.migrateData(dataTable, version);
				dataTable._version = newVersion;
				for (const [key, val] of pairs(migrated)) {
					dataTable[key] = val;
				}
			}
		// Deep merge with template defaults
		const completeData = this.deepMergeWithTemplate(dataTable, DATA_TEMPLATE);
		const result = completeData as DataTemplate;
		result._version = dataTable._version as number;

		// Validate the complete data
		const [isValid, errorMessage] = validateDataSection(result, () => DATA_TEMPLATE);
			if (!isValid) {
				warn(`Data validation failed: ${errorMessage}`);
			}

			return result;
		});
	}

	/**
	 * Closes the document/profile for a given player
	 */
	public closeDocument(player: Player): void {
		const profile = this.profiles.get(player);
		if (profile) {
			profile.EndSession();
		}
	}

	/**
	 * Retrieves the cache for a given player (returns a Promise)
	 */
	public getCache(player: Player): Promise<DataTemplate | undefined> {
		return new Promise<DataTemplate | undefined>((resolve) => {
			const profile = this.profiles.get(player);
			if (!profile) {
				this.openDocument(player).then((success) => {
					if (success) {
						const playerProfile = this.profiles.get(player);
						if (playerProfile) {
							const data = this.dataCheck(deepCopy(playerProfile.Data));
							resolve(data);
						} else {
							resolve(undefined);
						}
					} else {
						resolve(undefined);
					}
				});
			} else {
				const data = this.dataCheck(deepCopy(profile.Data));
				resolve(data);
			}
		});
	}

	/**
	 * Opens a document/profile for the given player (returns a Promise)
	 */
	public openDocument(player: Player): Promise<boolean> {
		return new Promise<boolean>((resolve) => {
			const profile = this.playerStore.StartSessionAsync(`Player_${player.UserId}`, {
				Cancel: () => player.Parent !== Players,
			});

			if (profile) {
				profile.AddUserId(player.UserId); // GDPR compliance

				profile.OnSessionEnd.Connect(() => {
					this.profiles.delete(player);
					this.resumeThreadsPendingSessionEndedLoad(player);
					task.defer(() => {
						player.Kick("Profile session end - Please rejoin");
					});
				});

				if (player.Parent === Players) {
					this.profiles.set(player, profile);
					print(`Profile loaded for ${player.DisplayName}!`);
					resolve(true);
				} else {
					// Player left before profile session started
					profile.EndSession();
					resolve(false);
				}
			} else {
				// Server shutting down or other failure
				this.cancelThreadsPendingSessionEndedLoad(player);
				task.defer(() => {
					player.Kick("Profile load fail - Please rejoin");
				});
				resolve(false);
			}
		});
	}

	/**
	 * Sets the cache for a given player
	 */
	public setCache(player: Player, newCache: DataTemplate): void {
		const profile = this.profiles.get(player);
		assert(profile, "Profile not found for player");

		// Use immutable update to ensure data integrity
		const safeCache = deepCopy(newCache);
		const data = this.dataCheck(safeCache);

		// Optimize storage by removing default values
		const optimizedData: Record<string, unknown> = {};
		const template = DATA_TEMPLATE as Record<string, unknown>;

		for (const [key, value] of pairs(data as Record<string, unknown>)) {
			if (template[key] === undefined) {
				warn(`Data migration: Unrecognized field '${key}' in old data. This may cause issues.`);
				optimizedData[key] = value;
			} else {
				if (typeOf(value) !== typeOf(template[key])) {
					warn(
						`Data migration: Type mismatch for field '${key}'. Expected ${typeOf(template[key])}, got ${typeOf(value)}. This may cause issues.`
					);
				}

				// Keep non-default values and version info
				if (value !== template[key] || key === "_version") {
					optimizedData[key] = value;
				}
			}
		}

		profile.Data = optimizedData as DataTemplate;
	}

	/**
	 * Gets performance metrics for data operations
	 */
	public getPerformanceMetrics() {
		return performance.getMetrics();
	}

	/**
	 * Prints a performance report for data operations
	 */
	public printPerformanceReport(): void {
		performance.printReport();
	}

	/**
	 * Initializes data migrations
	 */
	private initializeMigrations(): void {
		// Migration from version 1 to version 2
		migrations.registerMigration(1, (data) => {
			const newData = { ...data };

			if (!newData.SlotsApplicable) {
				newData.SlotsApplicable = 3;
			}

			return newData;
		}, "Add missing SlotsApplicable field");

		// Migration from version 2 to version 3
		migrations.registerMigration(2, (data) => {
			const newData = { ...data };

			// Handle old DailyRewardData structure
			if (newData.DailyRewardData) {
				const oldDailyData = newData.DailyRewardData as Record<string, unknown>;

				newData.DailyRewardsData = {
					LastClaimedDay: undefined,
					CurrentStreak: 0,
					CanClaim: true,
					TotalClaimed: 0,
				} as DailyRewardsData;

				// Preserve meaningful data
				if (oldDailyData.LastClaimTime && (oldDailyData.LastClaimTime as number) > 0) {
					(newData.DailyRewardsData as DailyRewardsData).LastClaimedDay = math.floor((oldDailyData.LastClaimTime as number) / 86400);
				}

				if (oldDailyData.StreakDays && (oldDailyData.StreakDays as number) > 0) {
					(newData.DailyRewardsData as DailyRewardsData).CurrentStreak = oldDailyData.StreakDays as number;
				}

				delete newData.DailyRewardData;
			}

			// Ensure DailyRewardsData exists
			if (!newData.DailyRewardsData) {
				newData.DailyRewardsData = {
					LastClaimedDay: undefined,
					CurrentStreak: 0,
					CanClaim: true,
					TotalClaimed: 0,
				};
			}

			// Handle ReceiptHistory migration
			newData.ReceiptHistory = newData.ReceiptHistory || [];
			if (newData.ProductsBought) {
				const productsBought = newData.ProductsBought as unknown[];
				const receiptHistory = newData.ReceiptHistory as string[];
				
				for (const purchaseId of productsBought) {
					if (purchaseId && !receiptHistory.includes(purchaseId as string)) {
						receiptHistory.push(purchaseId as string);
					}
				}
				delete newData.ProductsBought;
			}

			if (newData.FailedPurchases) {
				delete newData.FailedPurchases;
			}

			return newData;
		}, "Transform daily rewards data structure and add ReceiptHistory");

		// Add remaining migrations (3-5) following the same pattern...
		// Migration from version 3 to version 4
		migrations.registerMigration(3, (data) => {
			const newData = { ...data };

			if (newData.DailyRewardsData) {
				const dailyData = newData.DailyRewardsData as Record<string, unknown>;

				// Check for old structure
				if (dailyData.LastDay || dailyData.CurrentDay || dailyData.ClaimedDays) {
					const newDailyData: DailyRewardsData = {
						LastClaimedDay: undefined,
						CurrentStreak: 0,
						CanClaim: true,
						TotalClaimed: 0,
					};

					if (dailyData.LastDay && (dailyData.LastDay as number) > 0) {
						newDailyData.LastClaimedDay = dailyData.LastDay as number;
					}

					if (dailyData.CurrentDay && (dailyData.CurrentDay as number) > 1) {
						newDailyData.CurrentStreak = (dailyData.CurrentDay as number) - 1;
					}

					if (dailyData.ClaimedDays) {
						const claimedDays = dailyData.ClaimedDays as Record<string, boolean>;
						let count = 0;
						for (const [, claimed] of pairs(claimedDays)) {
							if (claimed) count++;
						}
						newDailyData.TotalClaimed = count;
					}

					newData.DailyRewardsData = newDailyData;
				}
			}

			return newData;
		}, "Fix daily rewards data structure mismatches");

		// Additional migrations (4-5) can be added here following the same pattern
	}
}
