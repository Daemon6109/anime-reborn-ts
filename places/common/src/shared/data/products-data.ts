/**
 * Products Registry Data - Migrated from live game
 * Contains all monetization products: gamepasses, gems, gold, bundles, potions, etc.
 */

export interface ProductData {
	readonly Type: "Gamepass" | "Product";
	readonly BuyLimit?: number; // Must be 1 for Gamepasses. If none, no limit applies
	readonly Giftable?: boolean;
	readonly Name: string;
	readonly Callback?: (player: Player) => void; // Runs when bought, and when type is Gamepass and player joins
	readonly RunOnceCallback?: (player: Player) => void; // Runs only once when bought, useful for Gamepass
	readonly GradientName?: string; // Used for gifting
	readonly GradientColors?: Color3[]; // Used for gifting
	readonly AlsoAward?: number; // Award another product ID when this is purchased
}

/**
 * All products organized by their Roblox product/gamepass IDs
 */
export const ProductsRegistry: Record<number, ProductData> = {
	// GAMEPASSES
	[931258600]: {
		Type: "Gamepass",
		BuyLimit: 1,
		Giftable: true,
		Name: "Extra 50 Storage",
		AlsoAward: 1932432112,
		GradientName: "Rare",
	},

	[931598388]: {
		Type: "Gamepass",
		BuyLimit: 1,
		Giftable: true,
		Name: "Shiny Hunter",
		AlsoAward: 1932432116,
		GradientName: "Mythical",
	},

	[887686872]: {
		Type: "Gamepass",
		BuyLimit: 1,
		Giftable: true,
		Name: "VIP",
		AlsoAward: 1932432115,
		GradientName: "Legendary",
	},

	[931436143]: {
		Type: "Gamepass",
		BuyLimit: 1,
		Giftable: true,
		Name: "Display All Units",
		AlsoAward: 1932432113,
		GradientName: "Rare",
	},

	// STORAGE PRODUCTS
	[1932432112]: {
		Type: "Product",
		BuyLimit: 1,
		Giftable: true,
		Name: "Extra 50 Storage",
		AlsoAward: 931258600,
		GradientName: "Rare",
	},

	[2660208988]: {
		Type: "Product",
		BuyLimit: 7,
		Giftable: true,
		Name: "Extra 50 Storage",
		GradientName: "Rare",
	},

	// OTHER GAMEPASS PRODUCTS
	[1932432116]: {
		Type: "Product",
		BuyLimit: 1,
		Giftable: true,
		Name: "Shiny Hunter",
		AlsoAward: 931598388,
		GradientName: "Mythical",
	},

	[1932432115]: {
		Type: "Product",
		BuyLimit: 1,
		Giftable: true,
		Name: "VIP",
		AlsoAward: 887686872,
		GradientName: "Legendary",
	},

	[1932432113]: {
		Type: "Product",
		BuyLimit: 1,
		Giftable: true,
		Name: "Display All Units",
		AlsoAward: 931436143,
		GradientName: "Rare",
	},

	// GEMS
	[1932432122]: {
		Type: "Product",
		Giftable: true,
		Name: "500 Gems",
		GradientName: "Gems",
	},

	[1932432120]: {
		Type: "Product",
		Giftable: true,
		Name: "1,250 Gems",
		GradientName: "Gems",
	},

	[1932432119]: {
		Type: "Product",
		Giftable: true,
		Name: "2,500 Gems",
		GradientName: "Gems",
	},

	[1932432118]: {
		Type: "Product",
		Giftable: true,
		Name: "6,000 Gems",
		GradientName: "Gems",
	},

	[1932432117]: {
		Type: "Product",
		Giftable: true,
		Name: "25,000 Gems",
		GradientName: "Gems",
	},
} as const;

/**
 * Helper functions for working with products
 */
export namespace ProductsData {
	/**
	 * Get product data by ID
	 */
	export function getProduct(id: number): ProductData | undefined {
		return ProductsRegistry[id];
	}

	/**
	 * Get all gamepasses
	 */
	export function getGamepasses(): Record<number, ProductData> {
		const gamepasses: Record<number, ProductData> = {};
		for (const [idString, product] of pairs(ProductsRegistry)) {
			if (product.Type === "Gamepass") {
				gamepasses[idString] = product;
			}
		}
		return gamepasses;
	}

	/**
	 * Get all currency products (gems, gold, etc.)
	 */
	export function getCurrencyProducts(): Record<number, ProductData> {
		const currencyProducts: Record<number, ProductData> = {};
		for (const [idString, product] of pairs(ProductsRegistry)) {
			if (product.GradientName === "Gems" || product.GradientName === "Gold") {
				currencyProducts[idString] = product;
			}
		}
		return currencyProducts;
	}

	/**
	 * Check if a product is giftable
	 */
	export function isGiftable(id: number): boolean {
		return ProductsRegistry[id]?.Giftable === true;
	}

	/**
	 * Get product buy limit
	 */
	export function getBuyLimit(id: number): number | undefined {
		return ProductsRegistry[id]?.BuyLimit;
	}
}
