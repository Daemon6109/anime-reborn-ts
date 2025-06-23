/**
 * Mounts Registry Data - Migrated from live game
 * Contains all mount configurations and stats
 */

export interface MountConfiguration {
	readonly TrueName: string;
	readonly DisplayName: string;
	readonly Description: string;
	readonly ViewportCFrame: CFrame;
	readonly PreviewViewport: CFrame;
	readonly MaxSpeed: number;
	readonly JumpHeight: number;
	readonly Acceleration: number;
	readonly PriceInGems?: number;
	readonly Rarity: "Common" | "Rare" | "Epic" | "Legendary" | "Mythical";
}

export interface MountAnimations {
	readonly idle: string;
	readonly walk: string;
}

export interface MountData {
	readonly configuration: MountConfiguration;
	readonly animations: MountAnimations;
}

/**
 * All mounts organized by their internal names
 */
export const MountsRegistry: Record<string, MountData> = {
	FairyWings: {
		configuration: {
			TrueName: "FairyWings",
			DisplayName: "Fairy Wings",
			Description: "What better way to fly around than these?",
			ViewportCFrame: new CFrame(0, 0.2, -5),
			PreviewViewport: new CFrame(0, 0, -7),
			MaxSpeed: 45,
			JumpHeight: 14,
			Acceleration: 44.12,
			PriceInGems: 2250,
			Rarity: "Rare",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	DemonSlayer: {
		configuration: {
			TrueName: "DemonSlayer",
			DisplayName: "Monster Slayer",
			Description:
				"Despite how heavy this sword is, it offers amazing travelling qualities. They claim the fuel of this sword is Dark Magic..",
			ViewportCFrame: new CFrame(0, 0.1, -5.5),
			PreviewViewport: new CFrame(0, 0, -6.5),
			MaxSpeed: 55,
			JumpHeight: 10,
			Acceleration: 53.92,
			PriceInGems: 3500,
			Rarity: "Epic",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	CrazyBike: {
		configuration: {
			TrueName: "CrazyBike",
			DisplayName: "Crazy Bike",
			Description: "With great performance and great looks, the Crazy Bike is suitable for many mages.",
			ViewportCFrame: new CFrame(0, 0, -12).mul(CFrame.Angles(0, math.rad(90), 0)),
			PreviewViewport: new CFrame(0, 0, -12).mul(CFrame.Angles(0, math.rad(90), 0)),
			MaxSpeed: 60,
			JumpHeight: 8,
			Acceleration: 39.22,
			PriceInGems: 4000,
			Rarity: "Epic",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	StrangeCloud: {
		configuration: {
			TrueName: "StrangeCloud",
			DisplayName: "Strange Cloud",
			Description: "Does not rain.",
			ViewportCFrame: new CFrame(-0.2, 0.2, -5).mul(CFrame.Angles(0, math.rad(50), 0)),
			PreviewViewport: new CFrame(-0.2, -0.6, -6).mul(CFrame.Angles(0, math.rad(50), 0)),
			MaxSpeed: 50,
			JumpHeight: 12,
			Acceleration: 49.02,
			PriceInGems: 3000,
			Rarity: "Rare",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	HoverCar: {
		configuration: {
			TrueName: "HoverCar",
			DisplayName: "Hover Car",
			Description: "Definitely creates traffic.",
			ViewportCFrame: new CFrame(0, 0.2, -12).mul(CFrame.Angles(0, math.rad(90), 0)),
			PreviewViewport: new CFrame(0, -0.6, -12).mul(CFrame.Angles(0, math.rad(90), 0)),
			MaxSpeed: 70,
			JumpHeight: 18,
			Acceleration: 58,
			PriceInGems: 5000,
			Rarity: "Legendary",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	CandyCaneBroomstick: {
		configuration: {
			TrueName: "CandyCaneBroomstick",
			DisplayName: "Candy Cane Broomstick",
			Description: "Delicious magic.",
			ViewportCFrame: new CFrame(-0.2, 0.2, -10),
			PreviewViewport: new CFrame(-0.2, -0.6, -10),
			MaxSpeed: 60,
			JumpHeight: 14,
			Acceleration: 54,
			PriceInGems: 4500,
			Rarity: "Epic",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	CandyHoverboard: {
		configuration: {
			TrueName: "CandyHoverboard",
			DisplayName: "Candy Hoverboard",
			Description: "Unfortunately non-magical.",
			ViewportCFrame: new CFrame(0, 0.2, -5).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0, -0.4, -5).mul(CFrame.Angles(0, math.rad(180), 0)),
			MaxSpeed: 55,
			JumpHeight: 0,
			Acceleration: 46,
			PriceInGems: 3200,
			Rarity: "Rare",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	IceSkates: {
		configuration: {
			TrueName: "IceSkates",
			DisplayName: "Ice Skates",
			Description: "Cold... Like, seriously cold.",
			ViewportCFrame: new CFrame(0, 0.2, -3).mul(CFrame.Angles(0, math.rad(180), 0)),
			PreviewViewport: new CFrame(0, -0.4, -5).mul(CFrame.Angles(0, math.rad(180), 0)),
			MaxSpeed: 40,
			JumpHeight: 7.2,
			Acceleration: 50,
			PriceInGems: 2800,
			Rarity: "Rare",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	CandySleigh: {
		configuration: {
			TrueName: "CandySleigh",
			DisplayName: "Candy Sleigh",
			Description: "Seriously? Who made this..",
			ViewportCFrame: new CFrame(0, 0.2, -10).mul(CFrame.Angles(0, math.rad(90), 0)),
			PreviewViewport: new CFrame(0, -0.6, -10).mul(CFrame.Angles(0, math.rad(90), 0)),
			MaxSpeed: 65,
			JumpHeight: 15,
			Acceleration: 42,
			PriceInGems: 4200,
			Rarity: "Epic",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	DemonWings: {
		configuration: {
			TrueName: "DemonWings",
			DisplayName: "Demon Wing",
			Description: "What better way to fly around than these?",
			ViewportCFrame: new CFrame(0, 0.2, -5),
			PreviewViewport: new CFrame(0, 0, -7),
			MaxSpeed: 45,
			JumpHeight: 14,
			Acceleration: 44.12,
			PriceInGems: 2250,
			Rarity: "Rare",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},

	HoverChair: {
		configuration: {
			TrueName: "HoverChair",
			DisplayName: "Hover Chair",
			Description: "What better way to fly around than these?",
			ViewportCFrame: new CFrame(0, 0.2, -5),
			PreviewViewport: new CFrame(0, 0, -7),
			MaxSpeed: 55,
			JumpHeight: 14,
			Acceleration: 59.12,
			PriceInGems: 3800,
			Rarity: "Epic",
		},
		animations: {
			idle: "84536523195656",
			walk: "131383125495707",
		},
	},
} as const;

/**
 * Helper functions for working with mounts
 */
export namespace MountsData {
	/**
	 * Get mount data by name
	 */
	export function getMount(name: string): MountData | undefined {
		return MountsRegistry[name];
	}

	/**
	 * Get all mounts of a specific rarity
	 */
	export function getMountsByRarity(rarity: MountConfiguration["Rarity"]): Record<string, MountData> {
		const filteredMounts: Record<string, MountData> = {};
		for (const [name, mount] of pairs(MountsRegistry)) {
			if (mount.configuration.Rarity === rarity) {
				filteredMounts[name] = mount;
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
			mountsArray.push([name, mount]);
		}

		// Sort by price (ascending)
		mountsArray.sort((a, b) => {
			const priceA = a[1].configuration.PriceInGems ?? 0;
			const priceB = b[1].configuration.PriceInGems ?? 0;
			return priceA < priceB;
		});

		return mountsArray;
	}

	/**
	 * Get mount display name
	 */
	export function getDisplayName(name: string): string | undefined {
		return MountsRegistry[name]?.configuration.DisplayName;
	}

	/**
	 * Get mount description
	 */
	export function getDescription(name: string): string | undefined {
		return MountsRegistry[name]?.configuration.Description;
	}

	/**
	 * Get mount stats (speed, jump, acceleration)
	 */
	export function getStats(
		name: string,
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
	export function isPurchasable(name: string): boolean {
		return MountsRegistry[name]?.configuration.PriceInGems !== undefined;
	}

	/**
	 * Get mount price in gems
	 */
	export function getPrice(name: string): number | undefined {
		return MountsRegistry[name]?.configuration.PriceInGems;
	}
}
