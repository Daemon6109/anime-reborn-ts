import leaderboardSeasons from "@shared/configuration/leaderboard-seasons-data.json";

export type LeaderboardSeasonsRegistry = typeof leaderboardSeasons;
export type SeasonNumber = keyof LeaderboardSeasonsRegistry;
export type SeasonData = LeaderboardSeasonsRegistry[SeasonNumber];
export type RewardsData = (SeasonData & { Rewards: any })["Rewards"];

/**
 * All leaderboard seasons organized by their internal names
 */
export const LeaderboardSeasonsRegistry: LeaderboardSeasonsRegistry = leaderboardSeasons;

/**
 * Helper functions for working with leaderboard seasons
 */
export namespace LeaderboardSeasonsData {
	/**
	 * Get leaderboard season data by season number
	 */
	export function getSeason(seasonNumber: SeasonNumber): SeasonData | undefined {
		return LeaderboardSeasonsRegistry[seasonNumber];
	}

	/**
	 * Get the rewards for a specific season
	 */
	export function getRewards(seasonNumber: SeasonNumber): RewardsData | undefined {
		const season = LeaderboardSeasonsRegistry[seasonNumber];
		if (season && "Rewards" in season) {
			return (season as any).Rewards;
		}
		return undefined;
	}
}
