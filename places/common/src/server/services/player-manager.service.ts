// Example usage of the DataService in a Flamework controller or service

import { Service, OnStart } from "@flamework/core";
import { Players } from "@rbxts/services";
import { DataService } from "./data.service";
import { safePlayerAdded } from "../../shared/utils/safe-player-added.util";

/**
 * Example service showing how to use the DataService
 */
@Service()
export class PlayerManagerService implements OnStart {
	constructor(private readonly dataService: DataService) {}

	public onStart(): void {
		// Handle player joining
		safePlayerAdded((player) => {
			this.handlePlayerJoined(player);
		});

		// Handle player leaving
		Players.PlayerRemoving.Connect((player) => {
			this.handlePlayerLeaving(player);
		});
	}

	private async handlePlayerJoined(player: Player): Promise<void> {
		print(`${player.DisplayName} is joining...`);

		try {
			// Open the player's data document
			const success = await this.dataService.openDocument(player);

			if (success) {
				print(`Successfully loaded data for ${player.DisplayName}`);

				// Get the player's data
				const playerData = await this.dataService.getCache(player);

				if (playerData) {
					print(`Player level: ${playerData.Level}`);
					print(`Player XP: ${playerData.XP}`);
					print(`Daily rewards streak: ${playerData.DailyRewardsData.CurrentStreak}`);
				}
			} else {
				warn(`Failed to load data for ${player.DisplayName}`);
			}
		} catch (error) {
			warn(`Error loading player data: ${error}`);
		}
	}

	private handlePlayerLeaving(player: Player): void {
		print(`${player.DisplayName} is leaving...`);

		// Close the player's data document
		this.dataService.closeDocument(player);
	}

	/**
	 * Example method to update player data
	 */
	public async givePlayerXP(player: Player, amount: number): Promise<void> {
		try {
			const playerData = await this.dataService.getCache(player);

			if (playerData) {
				// Update XP
				playerData.XP += amount;

				// Level up logic (example)
				const xpNeededForNextLevel = playerData.Level * 100;
				if (playerData.XP >= xpNeededForNextLevel) {
					playerData.Level += 1;
					playerData.XP -= xpNeededForNextLevel;
					print(`${player.DisplayName} leveled up to level ${playerData.Level}!`);
				}

				// Save the updated data
				this.dataService.setCache(player, playerData);
			}
		} catch (error) {
			warn(`Error updating player XP: ${error}`);
		}
	}

	/**
	 * Example method to handle daily reward claiming
	 */
	public async claimDailyReward(player: Player): Promise<boolean> {
		try {
			const playerData = await this.dataService.getCache(player);

			if (playerData && playerData.DailyRewardsData.CanClaim) {
				const currentDay = math.floor(tick() / 86400); // Current day number
				const lastClaimedDay = playerData.DailyRewardsData.LastClaimedDay;

				// Check if it's a new day
				if (lastClaimedDay === undefined || currentDay > lastClaimedDay) {
					// Update daily rewards data
					playerData.DailyRewardsData.LastClaimedDay = currentDay;
					playerData.DailyRewardsData.TotalClaimed += 1;

					// Update streak
					if (lastClaimedDay !== undefined && currentDay === lastClaimedDay + 1) {
						playerData.DailyRewardsData.CurrentStreak += 1;
					} else {
						playerData.DailyRewardsData.CurrentStreak = 1;
					}

					// Set can't claim again today
					playerData.DailyRewardsData.CanClaim = false;

					// Save the data
					this.dataService.setCache(player, playerData);

					print(
						`${player.DisplayName} claimed daily reward! Streak: ${playerData.DailyRewardsData.CurrentStreak}`,
					);
					return true;
				}
			}

			return false;
		} catch (error) {
			warn(`Error claiming daily reward: ${error}`);
			return false;
		}
	}
}
