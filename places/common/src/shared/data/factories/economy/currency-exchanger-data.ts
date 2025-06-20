// Currency exchanger data factory
export interface CurrencyExchangerData {
	Day: number;
	Exchanged: number;
}

export function createCurrencyExchangerData(): CurrencyExchangerData {
	return {
		Day: 0,
		Exchanged: 0,
	};
}
