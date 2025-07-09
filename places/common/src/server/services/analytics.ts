import { Service, OnInit } from "@flamework/core";
import { AnalyticsService } from "@rbxts/services";
import { safePlayerAdded } from "@shared/utils/safe-player-added";

/**
 * Currency types for economy events
 */
interface EconomyEvents {
	Gold: number;
	Gems: number;
}

/**
 * Custom fields type for analytics events
 */
type CustomFields = Record<string, string>;

@Service()
export class Analytics implements OnInit {
	/**
	 * Logs an event used to track player actions related in experience.
	 */
	public LogEconomyEvent(
		player: Player,
		flowType: Enum.AnalyticsEconomyFlowType,
		currencyType: keyof EconomyEvents,
		amount: number,
		endingBalance: number,
		transactionType: keyof typeof Enum.AnalyticsEconomyTransactionType,
		itemSku?: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogEconomyEvent(
				player,
				flowType,
				currencyType,
				amount,
				endingBalance,
				transactionType,
				itemSku,
				customFields,
			);
		} catch (error) {
			warn(`Failed to log economy event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event used to track custom metrics of a user in experience.
	 */
	public LogCustomEvent(player: Player, eventName: string, value: number, customFields?: CustomFields): void {
		try {
			AnalyticsService.LogCustomEvent(player, eventName, value, customFields);
		} catch (error) {
			warn(`Failed to log custom event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event used to track user actions stepping through a pre-planned funnel.
	 */
	public LogFunnelStepEvent(
		player: Player,
		funnelName: string,
		funnelSessionId: string,
		step: number,
		stepName: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogFunnelStepEvent(player, funnelName, funnelSessionId, step, stepName, customFields);
		} catch (error) {
			warn(`Failed to log funnel step event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event used to track user actions stepping through an onboarding funnel.
	 */
	public LogOnboardingFunnelStepEvent(
		player: Player,
		step: number,
		stepName: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogOnboardingFunnelStepEvent(player, step, stepName, customFields);
		} catch (error) {
			warn(`Failed to log onboarding funnel step event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event for when a user has completed a level attempt.
	 */
	public LogProgressionCompleteEvent(
		player: Player,
		progressionPathName: string,
		level: number,
		levelName: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogProgressionCompleteEvent(player, progressionPathName, level, levelName, customFields);
		} catch (error) {
			warn(`Failed to log progression complete event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event for when a user has started, completed, or failed a level attempt.
	 */
	public LogProgressionEvent(
		player: Player,
		progressionPathName: string,
		status: Enum.AnalyticsProgressionType,
		level: number,
		levelName: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogProgressionEvent(player, progressionPathName, status, level, levelName, customFields);
		} catch (error) {
			warn(`Failed to log progression event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event for when a user has failed a level attempt.
	 */
	public LogProgressionFailEvent(
		player: Player,
		progressionPathName: string,
		level: number,
		levelName: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogProgressionFailEvent(player, progressionPathName, level, levelName, customFields);
		} catch (error) {
			warn(`Failed to log progression fail event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Logs an event for when a user has started a level attempt.
	 */
	public LogProgressionStartEvent(
		player: Player,
		progressionPathName: string,
		level: number,
		levelName: string,
		customFields?: CustomFields,
	): void {
		try {
			AnalyticsService.LogProgressionStartEvent(player, progressionPathName, level, levelName, customFields);
		} catch (error) {
			warn(`Failed to log progression start event for ${player.Name}: ${error}`);
		}
	}

	/**
	 * Helper method to log effect-related custom events
	 */
	public LogEffectEvent(
		player: Player,
		eventName: string,
		effectName: string,
		duration?: number,
		customFields?: CustomFields,
	): void {
		const fields: CustomFields = {
			effect_name: effectName,
			...customFields,
		};

		if (duration !== undefined) {
			fields.duration = tostring(duration);
		}

		this.LogCustomEvent(player, eventName, 1, fields);
	}

	onInit(): void {
		print("Analytics service initialized");
	}
}
