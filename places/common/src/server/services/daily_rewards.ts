/* eslint-disable roblox-ts/lua-truthiness */
/**
 * Daily Rewards
 *
 */

import { Signal } from "@rbxts/lemon-signal";
import { Players } from "@rbxts/services";
import { DataStore } from "./player-data";
import { Service, OnInit } from "@flamework/core";
import { safePlayerAdded } from "../../shared/utils/safe-player-added.util";

type DailyRewardPayload = { Coins: number; Gems: number; BonusCoins: number };

@Service()
export class DailyRewardsService implements OnInit {
	private Config = {
		_daily_reset_hour: 0, // Reset at Midnight UTC
		MAX_STREAK_DAYS: 7, // Reset streak after 7 days
		BASE_REWARD_COINS: 100,
		STREAK_MULTIPLIER: 1.5,

		// SPECIAL REWARDS BASED ON DAY
		SPECIAL_REWARDS: new Map<number, { Gems?: number; BonusCoins?: number }>([
			[3, { Gems: 10 }], // Day 3
			[7, { Gems: 25, BonusCoins: 500 }], // Day 7
		]),
	};

	constructor(private readonly dataservice: DataStore) {}

	// Events
	public newDayEvent = new Signal<[{ player: Player; day: number }]>();
	public rewardClaimedEvent = new Signal<[{ player: Player; day: number; reward: DailyRewardPayload }]>();

	onInit(): void {
		// The daily reset check will be queued by the data service and run once the player's data is loaded.
		safePlayerAdded((player) => {
			this.checkDailyReset(player);
		});

		// Also handle players who might already be in the game when the service initializes
		for (const player of Players.GetPlayers()) {
			this.checkDailyReset(player).catch((error) => {
				warn(`[DailyRewardsService] Failed initial daily reset check for ${player.Name} with error: ${error}`);
			});
		}

		// Setup hourly checks for daily reset (every hour)
		task.spawn(() => {
			do {
				task.wait(3600); // 1 hour
				for (const player of Players.GetPlayers()) {
					this.checkDailyReset(player);
				}
				// eslint-disable-next-line no-constant-condition
			} while (true);
		});
	}

	private GetCurrentDay(): number {
		return math.floor((os.time() - this.Config._daily_reset_hour * 3600) / 86400);
	}

	private async checkDailyReset(player: Player): Promise<void> {
		const PlayerStore = this.dataservice.getPlayerStore();
		const currentDay = this.GetCurrentDay();

		try {
			PlayerStore.updateAsync(player, (playerData) => {
				const { daily_reward } = playerData;
				const { last_claimed: lastClaimedDay, current_streak: currentStreak } = daily_reward;

				// No update needed if the reward for the current day has already been processed.
				if (lastClaimedDay !== undefined && lastClaimedDay >= currentDay) {
					return false;
				}

				// A new day has begun. Determine the new streak.
				const isStreakBroken = lastClaimedDay !== undefined && currentDay - lastClaimedDay > 1;
				const newStreak = isStreakBroken
					? 1 // Streak is broken, reset to 1.
					: math.min((currentStreak ?? 0) + 1, this.Config.MAX_STREAK_DAYS); // Continue or start streak.

				daily_reward.current_streak = newStreak;
				daily_reward.CanClaim = true;
				this.newDayEvent.Fire({ player: player, day: newStreak });

				// Commit the changes.
				return true;
			});
		} catch (error) {
			warn(`[DailyRewardsService] Failed to check daily reset for ${player.Name}: ${error}`);
		}
	}

	public async ClaimDailyReward(player: Player): Promise<void> {
		const PlayerStore = this.dataservice.getPlayerStore();

		try {
			PlayerStore.updateAsync(player, (playerData) => {
				if (playerData.daily_reward.CanClaim !== true) {
					return false;
				}

				const streakDay = playerData.daily_reward.current_streak ?? 1;
				const reward = this.CalculateDailyReward(streakDay);

				const goldReward = (playerData.currencies.gold() ?? 0) + reward.Coins + reward.BonusCoins;
				const gemsReward = (playerData.currencies.gems() ?? 0) + reward.Gems;

				// Atomically update currency and reward status.
				if (playerData.currencies) {
					playerData.currencies.gold(goldReward);
					playerData.currencies.gems(gemsReward);
				}

				playerData.daily_reward.CanClaim = false;
				playerData.daily_reward.last_claimed = this.GetCurrentDay();
				playerData.daily_reward.total_claimed = (playerData.daily_reward.total_claimed ?? 0) + 1;

				this.rewardClaimedEvent.Fire({ player: player, day: streakDay, reward: reward });

				return true;
			});
		} catch (error) {
			warn(`[DailyRewardsService] Failed to claim daily reward for ${player.Name}: ${error}`);
		}
	}

	public CalculateDailyReward(day: number): DailyRewardPayload {
		const baseCoins = this.Config.BASE_REWARD_COINS;
		const streakBonus = math.floor(baseCoins * (day - 1) * this.Config.STREAK_MULTIPLIER);

		const reward: DailyRewardPayload = {
			Coins: baseCoins + streakBonus,
			Gems: 0,
			BonusCoins: 0,
		};

		const specialReward = this.Config.SPECIAL_REWARDS.get(day);
		if (specialReward) {
			reward.Gems += specialReward.Gems ?? 0;
			reward.BonusCoins += specialReward.BonusCoins ?? 0;
		}

		return reward;
	}

	public GiveReward(player: Player, reward: DailyRewardPayload) {
		const PlayerStore = this.dataservice.getPlayerStore();

		PlayerStore.updateAsync(player, (playerData) => {
			// Add gold (its named coins in dailyrewardpayload but im 2 lazy to change it)
			if (reward.Coins !== undefined && reward.BonusCoins !== undefined) {
				playerData.currencies.gold((playerData.currencies.gold() ?? 0) + reward.Coins + reward.BonusCoins);
			}

			// Add gems
			if (reward.Gems !== undefined) {
				playerData.currencies.gems((playerData.currencies.gems() ?? 0) + reward.Gems);
			}

			// commit
			return true;
		});
	}

	public GetDailyStatus(player: Player): { currentDay: number; canClaim: boolean; totalClaimed: number } | undefined {
		const PlayerStore = this.dataservice.getPlayerStore();
		let playerData;

		PlayerStore.get(player).andThen((data) => {
			playerData = {
				currentDay: data.daily_reward.current_streak,
				canClaim: data.daily_reward.CanClaim,
				totalClaimed: data.daily_reward.total_claimed,
			};
		});

		if (!playerData) {
			warn(`[DailyRewardsService] Could not get data for player ${player.Name} in GetDailyStatus.`);
			return undefined;
		}

		return playerData;
	}
}
