import { Service, OnInit } from "@flamework/core";
import { Players, ReplicatedStorage } from "@rbxts/services";
import { DataService } from "./data.service";

const version = { major: 1, minor: 0, patch: 0 };

export interface MountConfig {
	Name: string;
	DisplayName: string;
	Description: string;
	Model?: string; // Model name in ReplicatedStorage
	Speed?: number;
	Health?: number;
	Special?: string;
	Rarity: "Common" | "Rare" | "Epic" | "Legendary";
	Cost?: Record<string, number>;
	RequiredLevel?: number;
}

export interface EquippedMountData {
	Model?: Model | Part;
	Config?: MountConfig;
}

export interface MountEquippedEvent {
	player: Player;
	mountName: string;
}

export interface MountUnequippedEvent {
	player: Player;
}

/**
 * Mount system for managing player mounts - transportation, cosmetic companions, etc.
 */
@Service()
export class MountService implements OnInit {
	public readonly version = version;

	// Mount configurations registry
	private mountConfigs: Record<string, MountConfig> = {};

	// Currently equipped mount data for all players
	private equippedMountData: Map<Player, EquippedMountData> = new Map();

	// Event callbacks
	private mountEquippedCallbacks: Array<(event: MountEquippedEvent) => void> = [];
	private mountUnequippedCallbacks: Array<(event: MountUnequippedEvent) => void> = [];

	constructor(private readonly dataService: DataService) {}

	public onInit(): void {
		this.loadDefaultMountConfigs();
		this.setupPlayerHandlers();
		print("MountService initialized");
	}

	/**
	 * Subscribe to mount equipped events
	 */
	public onMountEquipped(callback: (event: MountEquippedEvent) => void): void {
		this.mountEquippedCallbacks.push(callback);
	}

	/**
	 * Subscribe to mount unequipped events
	 */
	public onMountUnequipped(callback: (event: MountUnequippedEvent) => void): void {
		this.mountUnequippedCallbacks.push(callback);
	}

	/**
	 * Fire mount equipped event
	 */
	private fireMountEquipped(event: MountEquippedEvent): void {
		for (const callback of this.mountEquippedCallbacks) {
			try {
				callback(event);
			} catch (error) {
				warn(`Error in mount equipped callback: ${error}`);
			}
		}
	}

	/**
	 * Fire mount unequipped event
	 */
	private fireMountUnequipped(event: MountUnequippedEvent): void {
		for (const callback of this.mountUnequippedCallbacks) {
			try {
				callback(event);
			} catch (error) {
				warn(`Error in mount unequipped callback: ${error}`);
			}
		}
	}

	/**
	 * Loads default mount configurations
	 */
	private loadDefaultMountConfigs(): void {
		this.mountConfigs = {
			// Basic Mounts
			Horse: {
				Name: "Horse",
				DisplayName: "Brown Horse",
				Description: "A reliable brown horse for traveling",
				Speed: 16,
				Health: 100,
				Rarity: "Common",
				Cost: { Gold: 1000 },
				RequiredLevel: 1,
			},
			Unicorn: {
				Name: "Unicorn",
				DisplayName: "Magical Unicorn",
				Description: "A magical unicorn with healing powers",
				Speed: 20,
				Health: 150,
				Special: "Healing Aura",
				Rarity: "Rare",
				Cost: { Gems: 100 },
				RequiredLevel: 10,
			},
			Dragon: {
				Name: "Dragon",
				DisplayName: "Fire Dragon",
				Description: "A powerful fire dragon that can fly",
				Speed: 25,
				Health: 200,
				Special: "Flight",
				Rarity: "Epic",
				Cost: { Gems: 500 },
				RequiredLevel: 25,
			},
			Phoenix: {
				Name: "Phoenix",
				DisplayName: "Legendary Phoenix",
				Description: "A legendary phoenix with revival powers",
				Speed: 30,
				Health: 300,
				Special: "Revival",
				Rarity: "Legendary",
				Cost: { Gems: 1000 },
				RequiredLevel: 50,
			},
			// Special Mounts
			Wolf: {
				Name: "Wolf",
				DisplayName: "Shadow Wolf",
				Description: "A swift shadow wolf",
				Speed: 18,
				Health: 120,
				Rarity: "Rare",
				Cost: { Gold: 5000 },
				RequiredLevel: 15,
			},
			Griffin: {
				Name: "Griffin",
				DisplayName: "Royal Griffin",
				Description: "A majestic royal griffin",
				Speed: 22,
				Health: 180,
				Special: "Flight",
				Rarity: "Epic",
				Cost: { Gems: 300 },
				RequiredLevel: 30,
			},
		};
	}

	/**
	 * Gives a mount to a player
	 */
	public async giveMount(player: Player, mountName: string, amount = 1): Promise<boolean> {
		if (!this.mountConfigs[mountName]) {
			warn(`Invalid mount: ${mountName}`);
			return false;
		}

		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			warn(`Failed to get player data for ${player.Name}`);
			return false;
		}

		const newData = { ...playerData };
		const mounts = newData.Inventory.Mounts as Record<string, unknown>;

		// Add mount to inventory
		if (mounts[mountName] !== undefined) {
			// Mount already owned - could add quantity if mounts support stacking
			print(`${player.Name} already owns mount: ${mountName}`);
		} else {
			mounts[mountName] = {
				Name: mountName,
				Owned: true,
				Equipped: false,
			};
			print(`Gave mount ${mountName} to ${player.Name}`);
		}

		this.dataService.setCache(player, newData);
		return true;
	}

	/**
	 * Checks if a player owns a mount
	 */
	public async hasMount(player: Player, mountName: string): Promise<boolean> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return false;
		}

		const mounts = playerData.Inventory.Mounts as Record<string, unknown>;
		const mountData = mounts[mountName] as { Owned?: boolean } | undefined;
		return mountData?.Owned === true;
	}

	/**
	 * Equips a mount for a player
	 */
	public async equipMount(player: Player, mountName: string): Promise<boolean> {
		// Check if player owns the mount
		const ownsMount = await this.hasMount(player, mountName);
		if (!ownsMount) {
			warn(`${player.Name} does not own mount: ${mountName}`);
			return false;
		}

		// Check mount config
		const mountConfig = this.mountConfigs[mountName];
		if (!mountConfig) {
			warn(`Invalid mount configuration: ${mountName}`);
			return false;
		}

		// Check level requirement
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return false;
		}

		if (
			mountConfig.RequiredLevel !== undefined &&
			(playerData.PlayerBasicData as { Level: number }).Level < mountConfig.RequiredLevel
		) {
			warn(`${player.Name} does not meet level requirement for mount: ${mountName}`);
			return false;
		}

		// Unequip current mount first
		await this.unequipMount(player);

		// Create/spawn the mount model
		const mountModel = this.createMountModel(mountConfig);
		if (mountModel) {
			mountModel.Name = `${player.Name}_${mountName}`;
			mountModel.Parent = game.Workspace;

			// Position mount near player
			const character = player.Character;
			if (character) {
				const humanoidRootPart = character.FindFirstChild("HumanoidRootPart") as Part;
				if (humanoidRootPart) {
					if (mountModel.IsA("Model") && mountModel.PrimaryPart) {
						mountModel.PrimaryPart.CFrame = humanoidRootPart.CFrame.add(new Vector3(0, 0, -5));
					} else if (mountModel.IsA("Part")) {
						mountModel.CFrame = humanoidRootPart.CFrame.add(new Vector3(0, 0, -5));
					}
				}
			}
		}

		// Store equipped mount data
		this.equippedMountData.set(player, {
			Model: mountModel,
			Config: mountConfig,
		});

		// Update player data
		const newData = { ...playerData };
		const mounts = newData.Inventory.Mounts as Record<string, unknown>;

		// Unequip all mounts first
		for (const [name, mountData] of pairs(mounts)) {
			const mount = mountData as { Equipped?: boolean };
			mount.Equipped = false;
		}

		// Equip the new mount
		const targetMount = mounts[mountName] as { Equipped?: boolean };
		targetMount.Equipped = true;

		this.dataService.setCache(player, newData);

		// Fire event
		this.fireMountEquipped({ player, mountName });

		print(`${player.Name} equipped mount: ${mountName}`);
		return true;
	}

	/**
	 * Unequips the current mount for a player
	 */
	public async unequipMount(player: Player): Promise<boolean> {
		const equippedData = this.equippedMountData.get(player);
		if (!equippedData) {
			return false; // No mount equipped
		}

		// Remove mount model from workspace
		if (equippedData.Model) {
			equippedData.Model.Destroy();
		}

		// Clear equipped data
		this.equippedMountData.delete(player);

		// Update player data
		const playerData = await this.dataService.getCache(player);
		if (playerData) {
			const newData = { ...playerData };
			const mounts = newData.Inventory.Mounts as Record<string, unknown>;

			// Unequip all mounts
			for (const [name, mountData] of pairs(mounts)) {
				const mount = mountData as { Equipped?: boolean };
				mount.Equipped = false;
			}

			this.dataService.setCache(player, newData);
		}

		// Fire event
		this.fireMountUnequipped({ player });

		print(`${player.Name} unequipped mount`);
		return true;
	}

	/**
	 * Toggles a mount for a player (equip if not equipped, unequip if equipped)
	 */
	public async toggleMount(player: Player, mountName: string): Promise<boolean> {
		const equippedData = this.equippedMountData.get(player);

		// If this mount is already equipped, unequip it
		if (equippedData?.Config?.Name === mountName) {
			return await this.unequipMount(player);
		} else {
			// Otherwise, equip it
			return await this.equipMount(player, mountName);
		}
	}

	/**
	 * Gets the currently equipped mount for a player
	 */
	public getEquippedMount(player: Player): MountConfig | undefined {
		return this.equippedMountData.get(player)?.Config;
	}

	/**
	 * Gets all mounts owned by a player
	 */
	public async getOwnedMounts(player: Player): Promise<string[]> {
		const playerData = await this.dataService.getCache(player);
		if (!playerData) {
			return [];
		}

		const mounts = playerData.Inventory.Mounts as Record<string, unknown>;
		const ownedMounts: string[] = [];

		for (const [mountName, mountData] of pairs(mounts)) {
			const mount = mountData as { Owned?: boolean };
			if (mount.Owned === true) {
				ownedMounts.push(mountName);
			}
		}

		return ownedMounts;
	}

	/**
	 * Gets mount configuration
	 */
	public getMountConfig(mountName: string): MountConfig | undefined {
		return this.mountConfigs[mountName];
	}

	/**
	 * Gets all mount configurations
	 */
	public getAllMountConfigs(): Record<string, MountConfig> {
		return { ...this.mountConfigs };
	}

	/**
	 * Sets mount configuration
	 */
	public setMountConfig(mountName: string, config: MountConfig): void {
		this.mountConfigs[mountName] = config;
	}

	/**
	 * Creates a mount model (placeholder implementation)
	 */
	private createMountModel(config: MountConfig): Model | Part | undefined {
		// In a real implementation, this would load the actual mount model
		// For now, create a simple placeholder

		const part = new Instance("Part");
		part.Name = config.Name;
		part.Size = new Vector3(4, 2, 6);
		part.Material = Enum.Material.Neon;
		part.BrickColor = new BrickColor("Bright red");
		part.Shape = Enum.PartType.Block;
		part.TopSurface = Enum.SurfaceType.Smooth;
		part.BottomSurface = Enum.SurfaceType.Smooth;
		part.CanCollide = false;

		// Add a basic seat
		const seat = new Instance("Seat");
		seat.Name = "MountSeat";
		seat.Size = new Vector3(2, 1, 2);
		seat.Material = Enum.Material.Fabric;
		seat.BrickColor = new BrickColor("Really black");
		seat.CFrame = part.CFrame.add(new Vector3(0, 1, 0));
		seat.Parent = part;

		return part;
	}

	/**
	 * Setup player join/leave handlers
	 */
	private setupPlayerHandlers(): void {
		Players.PlayerRemoving.Connect((player) => {
			// Clean up equipped mount when player leaves
			const equippedData = this.equippedMountData.get(player);
			if (equippedData?.Model) {
				equippedData.Model.Destroy();
			}
			this.equippedMountData.delete(player);
		});

		// Handle character respawning
		Players.PlayerAdded.Connect((player) => {
			player.CharacterAdded.Connect(() => {
				// Re-equip mount if player had one equipped before respawning
				task.wait(1); // Wait for character to fully load

				task.spawn(async () => {
					const playerData = await this.dataService.getCache(player);
					if (!playerData) return;

					const mounts = playerData.Inventory.Mounts as Record<string, unknown>;
					for (const [mountName, mountData] of pairs(mounts)) {
						const mount = mountData as { Equipped?: boolean };
						if (mount.Equipped === true) {
							this.equipMount(player, mountName);
							break;
						}
					}
				});
			});
		});
	}
}
