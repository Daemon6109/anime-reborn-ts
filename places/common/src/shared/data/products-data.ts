import products from "@shared/configuration/products-data.json";

export type ProductsRegistry = typeof products;
export type ProductId = keyof ProductsRegistry;
export type ProductData = ProductsRegistry[ProductId] & {
	readonly Callback?: (player: Player) => void; // Runs when bought, and when type is Gamepass and player joins
	readonly RunOnceCallback?: (player: Player) => void; // Runs only once when bought, useful for Gamepass
	readonly GradientColors?: Color3[]; // Used for gifting
};

/**
 * All products organized by their Roblox product/gamepass IDs
 */
export const ProductsRegistry: Record<number, ProductData> = products;

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
				gamepasses[idString as number] = product;
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
				currencyProducts[idString as number] = product;
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
		const product = ProductsRegistry[id];
		return product && "BuyLimit" in product ? product.BuyLimit : undefined;
	}
}
