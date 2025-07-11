import portals from "@shared/configuration/portals-data.json";

export type PortalsRegistry = typeof portals;
export type PortalName = keyof PortalsRegistry;
export type PortalData = PortalsRegistry[PortalName];
export type PortalConfiguration = PortalData["configuration"];
export type PortalRewards = PortalData["Rewards"];

/**
 * All portals organized by their internal names
 */
export const PortalsRegistry: PortalsRegistry = portals;

/**
 * Helper functions for working with portals
 */
export namespace PortalsData {
	/**
	 * Get portal data by name
	 */
	export function getPortal(name: PortalName): PortalData | undefined {
		return PortalsRegistry[name];
	}

	/**
	 * Get the configuration for a specific portal
	 */
	export function getConfiguration(name: PortalName): PortalConfiguration | undefined {
		return PortalsRegistry[name]?.configuration;
	}

	/**
	 * Get the rewards for a specific portal
	 */
	export function getRewards(name: PortalName): PortalRewards | undefined {
		return PortalsRegistry[name]?.Rewards;
	}
}
