import currencies from "@shared/configuration/currency-data.json";

type CurrenciesRegistryJSON = typeof currencies;
export type CurrencyName = keyof CurrenciesRegistryJSON;
export type CurrencyDataJSON = CurrenciesRegistryJSON[CurrencyName];

export type CurrencyData = Omit<CurrencyDataJSON, "DisplayIconSize" | "Gradient"> & {
	DisplayIconSize: UDim2;
	Gradient: Color3[];
};

export type CurrencyConfiguration = CurrencyData;

const CurrenciesRegistry: Record<CurrencyName, CurrencyData> = {} as Record<CurrencyName, CurrencyData>;

for (const [name, data] of pairs(currencies)) {
	const currencyName = name as CurrencyName;
	CurrenciesRegistry[currencyName] = {
		...data,
		DisplayIconSize: new UDim2(
			data.DisplayIconSize.x.scale,
			data.DisplayIconSize.x.offset,
			data.DisplayIconSize.y.scale,
			data.DisplayIconSize.y.offset,
		),
		Gradient: data.Gradient.map((c) => new Color3(c.r, c.g, c.b)),
	};
}

export { CurrenciesRegistry };

/**
 * Helper functions for working with currencies
 */
export namespace CurrenciesData {
	/**
	 * Get currency data by name
	 */
	export function getCurrency(name: CurrencyName): CurrencyData | undefined {
		return CurrenciesRegistry[name];
	}

	/**
	 * Get all premium currencies (gems and event currencies)
	 */
	export function getPremiumCurrencies(): Record<string, CurrencyData> {
		const premiumCurrencies: Record<string, CurrencyData> = {};
		for (const [name, currency] of pairs(CurrenciesRegistry)) {
			if (currency.Rarity === "Mythical" || currency.Rarity === "Exclusive") {
				premiumCurrencies[name as string] = currency;
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
			if (currency.Rarity === "Exclusive") {
				eventCurrencies[name as string] = currency;
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
			currenciesArray.push([name as string, currency]);
		}

		// Sort by order (ascending)
		currenciesArray.sort((a, b) => {
			return a[1].Order < b[1].Order;
		});

		return currenciesArray;
	}

	/**
	 * Get currency display name
	 */
	export function getDisplayName(name: CurrencyName): string | undefined {
		return CurrenciesRegistry[name]?.DisplayName;
	}

	/**
	 * Get currency description
	 */
	export function getDescription(name: CurrencyName): string | undefined {
		return CurrenciesRegistry[name]?.Description;
	}

	/**
	 * Get currency image ID
	 */
	export function getImageId(name: CurrencyName): string | undefined {
		return CurrenciesRegistry[name]?.Image;
	}

	/**
	 * Get currency rarity
	 */
	export function getRarity(name: CurrencyName): CurrencyConfiguration["Rarity"] | undefined {
		return CurrenciesRegistry[name]?.Rarity;
	}

	/**
	 * Get currency gradient colors
	 */
	export function getGradientColors(name: CurrencyName): readonly Color3[] | undefined {
		return CurrenciesRegistry[name]?.Gradient;
	}

	/**
	 * Check if currency is premium (not gold)
	 */
	export function isPremium(name: CurrencyName): boolean {
		return name !== "Gold";
	}

	/**
	 * Check if currency is event-based
	 */
	export function isEventCurrency(name: CurrencyName): boolean {
		const currency = CurrenciesRegistry[name];
		return currency?.Rarity === "Exclusive";
	}

	/**
	 * Get currency icon size
	 */
	export function getIconSize(name: CurrencyName): UDim2 | undefined {
		return CurrenciesRegistry[name]?.DisplayIconSize;
	}
}
