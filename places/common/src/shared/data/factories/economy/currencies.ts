// Economy currencies factory
export interface Currencies {
	Gold: number;
	Gems: number;
	"Red Ticket": number;
	"Candy Cane": number;
	"New Year Coin": number;
}

export function createCurrencies(): Currencies {
	return {
		Gold: 0,
		Gems: 500,
		"Red Ticket": 0,
		"Candy Cane": 0,
		"New Year Coin": 0,
	};
}
