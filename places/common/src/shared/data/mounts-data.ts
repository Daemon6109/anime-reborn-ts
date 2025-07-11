import mounts from "@shared/configuration/mounts-data.json";

export type MountsRegistry = typeof mounts;
export type MountName = keyof MountsRegistry;
export type MountData = MountsRegistry[MountName];
export type MountConfiguration = MountData["configuration"] & {
	PriceInGems?: number;
};

/**
 * All mounts organized by their internal names
 */
export const MountsRegistry: MountsRegistry = mounts;

/**
 * Helper functions for working with mounts
 */
export namespace MountsData {
	/**
	 * Get mount data by name
	 */
	export function getMount(name: MountName): MountData | undefined {
		return MountsRegistry[name];
	}

	/**
	 * Get all mounts of a specific rarity
	 */
	export function getMountsByRarity(rarity: MountConfiguration["Rarity"]): Record<string, MountData> {
		const filteredMounts: Record<string, MountData> = {};
		for (const [name, mount] of pairs(MountsRegistry)) {
			if (mount.configuration.Rarity === rarity) {
				filteredMounts[name as string] = mount;
			}
		}
		return filteredMounts;
	}

	/**
	 * Get all mounts sorted by price
	 */
	export function getMountsByPrice(): Array<[string, MountData]> {
		const mountsArray: Array<[string, MountData]> = [];
		for (const [name, mount] of pairs(MountsRegistry)) {
			mountsArray.push([name as string, mount]);
		}

		// Sort by price (ascending)
		mountsArray.sort((a, b) => {
			const priceA = (a[1].configuration as MountConfiguration).PriceInGems ?? 0;
			const priceB = (b[1].configuration as MountConfiguration).PriceInGems ?? 0;
			return priceA < priceB;
		});

		return mountsArray;
	}

	/**
	 * Get mount display name
	 */
	export function getDisplayName(name: MountName): string | undefined {
		return MountsRegistry[name]?.configuration.DisplayName;
	}

	/**
	 * Get mount description
	 */
	export function getDescription(name: MountName): string | undefined {
		return MountsRegistry[name]?.configuration.Description;
	}

	/**
	 * Get mount stats (speed, jump, acceleration)
	 */
	export function getStats(
		name: MountName,
	): Pick<MountConfiguration, "MaxSpeed" | "JumpHeight" | "Acceleration"> | undefined {
		const mount = MountsRegistry[name];
		if (!mount) return undefined;

		return {
			MaxSpeed: mount.configuration.MaxSpeed,
			JumpHeight: mount.configuration.JumpHeight,
			Acceleration: mount.configuration.Acceleration,
		};
	}

	/**
	 * Check if mount is purchasable with gems
	 */
	export function isPurchasable(name: MountName): boolean {
		return (MountsRegistry[name]?.configuration as MountConfiguration).PriceInGems !== undefined;
	}

	/**
	 * Get mount price in gems
	 */
	export function getPrice(name: MountName): number | undefined {
		return (MountsRegistry[name]?.configuration as MountConfiguration).PriceInGems;
	}
}
