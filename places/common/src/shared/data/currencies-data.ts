/**
 * Currencies Registry Data - Migrated from live game
 * Contains all currency configurations and properties
 */

export interface CurrencyConfiguration {
	readonly TrueName: string;
	readonly DisplayName: string;
	readonly Description: string;
	readonly Image: string;
	readonly Rarity: "Common" | "Rare" | "Epic" | "Legendary" | "Mythical" | "Exclusive";
	readonly Sort: readonly string[];
	readonly Order: number;
	readonly DisplayIconSize: UDim2;
	readonly Gradient: readonly Color3[];
}

export interface CurrencyData {
	readonly configuration: CurrencyConfiguration;
}

/**
 * All currencies organized by their internal names
 */
export const CurrenciesRegistry: Record<string, CurrencyData> = {
	Gold: {
		configuration: {
			TrueName: "Gold",
			DisplayName: "Gold",
			Description: "Regular currency!",
			Image: "rbxassetid://18922132513",
			Rarity: "Legendary",
			Sort: ["Currency"],
			Order: 2,
			DisplayIconSize: UDim2.fromScale(0.7, 0.7),
			Gradient: [
				new Color3(1, 0.615686, 0),
				new Color3(0.898039, 1, 0),
				new Color3(1, 0.615686, 0),
				new Color3(0.898039, 1, 0),
			],
		},
	},

	Gems: {
		configuration: {
			TrueName: "Gems",
			DisplayName: "Gems",
			Description: "Premium currency!",
			Image: "rbxassetid://18919544914",
			Rarity: "Mythical",
			Sort: ["Currency"],
			Order: -6,
			DisplayIconSize: UDim2.fromScale(0.7, 0.7),
			Gradient: [new Color3(0, 1, 1), new Color3(0.439216, 1, 0.67451), new Color3(0.752941, 0.470588, 1)],
		},
	},

	"Red Ticket": {
		configuration: {
			TrueName: "Red Ticket",
			DisplayName: "Red Ticket",
			Description: "Event currency!",
			Image: "rbxassetid://97041119207213",
			Rarity: "Exclusive",
			Sort: ["Currency"],
			Order: -6,
			DisplayIconSize: UDim2.fromScale(0.7, 0.7),
			Gradient: [new Color3(0, 1, 1), new Color3(0.439216, 1, 0.67451), new Color3(0.752941, 0.470588, 1)],
		},
	},

	"Candy Cane": {
		configuration: {
			TrueName: "Candy Cane",
			DisplayName: "Candy Cane",
			Description: "Event currency!",
			Image: "http://www.roblox.com/asset/?id=130838390833163",
			Rarity: "Exclusive",
			Sort: ["Currency"],
			Order: -6,
			DisplayIconSize: UDim2.fromScale(0.7, 0.7),
			Gradient: [new Color3(0, 1, 1), new Color3(0.439216, 1, 0.67451), new Color3(0.752941, 0.470588, 1)],
		},
	},

	"New Year Coin": {
		configuration: {
			TrueName: "New Year Coin",
			DisplayName: "New Year Coin",
			Description: "Event currency!",
			Image: "rbxassetid://118764467778787",
			Rarity: "Exclusive",
			Sort: ["Currency"],
			Order: -6,
			DisplayIconSize: UDim2.fromScale(0.7, 0.7),
			Gradient: [new Color3(0, 1, 1), new Color3(0.439216, 1, 0.67451), new Color3(0.752941, 0.470588, 1)],
		},
	},
} as const;

/**
 * Helper functions for working with currencies
 */
export namespace CurrenciesData {
	/**
	 * Get currency data by name
	 */
	export function getCurrency(name: string): CurrencyData | undefined {
		return CurrenciesRegistry[name];
	}

	/**
	 * Get all premium currencies (gems and event currencies)
	 */
	export function getPremiumCurrencies(): Record<string, CurrencyData> {
		const premiumCurrencies: Record<string, CurrencyData> = {};
		for (const [name, currency] of pairs(CurrenciesRegistry)) {
			if (currency.configuration.Rarity === "Mythical" || currency.configuration.Rarity === "Exclusive") {
				premiumCurrencies[name] = currency;
			}
		}
		return premiumCurrencies;
	}

	/**
	 * Get all event currencies
	 */
	export function getEventCurrencies(): Record<string, CurrencyData> {
		const eventCurrencies: Record<string, CurrencyData> = {};
		for (const [name, currency] of pairs(CurrenciesRegistry)) {
			if (currency.configuration.Rarity === "Exclusive") {
				eventCurrencies[name] = currency;
			}
		}
		return eventCurrencies;
	}

	/**
	 * Get currencies sorted by order
	 */
	export function getCurrenciesByOrder(): Array<[string, CurrencyData]> {
		const currenciesArray: Array<[string, CurrencyData]> = [];
		for (const [name, currency] of pairs(CurrenciesRegistry)) {
			currenciesArray.push([name, currency]);
		}

		// Sort by order (ascending)
		currenciesArray.sort((a, b) => {
			return a[1].configuration.Order < b[1].configuration.Order;
		});

		return currenciesArray;
	}

	/**
	 * Get currency display name
	 */
	export function getDisplayName(name: string): string | undefined {
		return CurrenciesRegistry[name]?.configuration.DisplayName;
	}

	/**
	 * Get currency description
	 */
	export function getDescription(name: string): string | undefined {
		return CurrenciesRegistry[name]?.configuration.Description;
	}

	/**
	 * Get currency image ID
	 */
	export function getImageId(name: string): string | undefined {
		return CurrenciesRegistry[name]?.configuration.Image;
	}

	/**
	 * Get currency rarity
	 */
	export function getRarity(name: string): CurrencyConfiguration["Rarity"] | undefined {
		return CurrenciesRegistry[name]?.configuration.Rarity;
	}

	/**
	 * Get currency gradient colors
	 */
	export function getGradientColors(name: string): readonly Color3[] | undefined {
		return CurrenciesRegistry[name]?.configuration.Gradient;
	}

	/**
	 * Check if currency is premium (not gold)
	 */
	export function isPremium(name: string): boolean {
		return name !== "Gold";
	}

	/**
	 * Check if currency is event-based
	 */
	export function isEventCurrency(name: string): boolean {
		const currency = CurrenciesRegistry[name];
		return currency?.configuration.Rarity === "Exclusive";
	}

	/**
	 * Get currency icon size
	 */
	export function getIconSize(name: string): UDim2 | undefined {
		return CurrenciesRegistry[name]?.configuration.DisplayIconSize;
	}
}
