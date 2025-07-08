import { Service, OnInit } from "@flamework/core";
import { AnalyticsService } from "@rbxts/services";
import { safePlayerAdded } from "@shared/utils/safe-player-added.util";
import { playerData } from "../../../remotes/network/client";

/**
 * Currency types for economy events
 */
interface EconomyEvents {
	Gold: number;
	Gems: number;
}

@Service()
export class Analytics implements OnInit {
	/**
	 * Logs an event used to track player actions related in experience.
	 *
	 * ThreadSafety: Unsafe
	 * Creator Hub: https://create.roblox.com/docs/reference/engine/classes/AnalyticsService#LogEconomyEvent
	 */
	public LogEconomyEvent(
		player: Player,
		flowType: Enum.AnalyticsEconomyFlowType,
		currencyType: keyof EconomyEvents,
		amount: number,
		endingBalance: number,
		transactionType: keyof typeof Enum.AnalyticsEconomyTransactionType,
		itemSku?: string,
		customFields?: Record<keyof typeof Enum.AnalyticsCustomFieldKeys, string>,
	) {
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
	}

	onInit() {
		// safePlayerAdded((player) => {
		// });
	}
}
