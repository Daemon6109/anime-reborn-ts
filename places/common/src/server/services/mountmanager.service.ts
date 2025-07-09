/* eslint-disable roblox-ts/lua-truthiness */
/**
 * Service responsible for managing player mounts including equipping, unequipping, and ownership tracking.
 * Handles mount model attachment to player characters and maintains equipped mount state.
 * @Spirast - Converting to TypeScript
 * @Copilot - Docstring generation and refactoring
 */

import { ReplicatedStorage, ServerScriptService, Players } from "@rbxts/services";
import { safePlayerAdded } from "../../shared/utils/safe-player-added.util";
import { Service, OnInit } from "@flamework/core";
import { DataStore } from "@services/player-data";

const MountsRegistry: Folder = ReplicatedStorage.FindFirstChild("constants")?.FindFirstChild("Mounts") as Folder;

@Service()
export class MountsManager implements OnInit {
	private equippedMountData = new Map<Player, { Model?: Model }>();

	constructor(private readonly dataservice: DataStore) {}

	// Initialization
	onInit(): void | Promise<void> {
		safePlayerAdded((player: Player) => {
			const character = player.Character || player.CharacterAdded.Wait()[0];
			this.onCharacterAdded(player, character);
		});

		Players.PlayerRemoving.Connect((player) => {
			this.UnequipMount(player);
			this.equippedMountData.delete(player);
		});
	}

	private FindModel(name: string) {
		return MountsRegistry.FindFirstChild(name);
	}

	/**
	 * Checks if a player has any mounts equipped on character add.
	 * If the mount is marked as equipped in the player's data store, it equips it in-game when they first join.
	 * @param player
	 * @param character
	 */
	private onCharacterAdded(player: Player, character: Model) {
		const PlayerProfile = this.dataservice.getPlayerStore();

		PlayerProfile.get(player).andThen((data) => {
			data.mounts.ownedMounts.forEach((mount) => {
				if (mount.equipped === true) {
					this.EquipMount(player, mount.name);
				}
			});
		});
	}

	/**
	 * Gives a specified mount to a player, adding it to their owned mounts collection.
	 * If the player already owns the mount, increases the quantity by the specified amount.
	 * @param player - The player to give the mount to
	 * @param Mount - The name of the mount to give
	 * @param amount - The quantity to give (defaults to 1)
	 */
	public GiveMount(player: Player, Mount: string, amount?: number) {
		const PlayerProfile = this.dataservice.getPlayerStore();

		if (!amount) {
			amount = 1;
		}

		if (!MountsRegistry.FindFirstChild(Mount)) {
			warn(`Invalid Mount ${Mount}`);
			return;
		}

		PlayerProfile.updateAsync(player, (playerData) => {
			// Find existing mount or create new entry
			const existingMount = playerData.mounts.ownedMounts.find((mount) => mount.name === Mount);

			if (existingMount) {
				existingMount.quantity += amount;
				return true;
			} else {
				playerData.mounts.ownedMounts.push({
					name: Mount,
					quantity: amount,
					equipped: false,
				});
				return true;
			}
		});
	}

	/**
	 * Equips a mount for the specified player by updating their data store and attaching the mount model to their character.
	 * Unequips any currently equipped mounts before equipping the new one.
	 *
	 * @param player - The player to equip the mount for
	 * @param Mount - The name of the mount to equip
	 */
	public async EquipMount(player: Player, Mount: string) {
		const character = player.Character ?? player.CharacterAdded.Wait()[0];
		const PlayerStore = this.dataservice.getPlayerStore();
		const MountExists = this.FindModel(Mount);

		const updateResult = await PlayerStore.updateAsync(player, (data) => {
			if (!MountExists || !data.mounts.ownedMounts.find((mount) => mount.name === Mount)) {
				return false; // Mount doesn't exist or player doesn't own it
			}

			// Unequip all mounts first
			data.mounts.ownedMounts.forEach((mount) => {
				// in case for some reason there's 2 mounts that are both equipped
				mount.equipped = false;
			});

			// Equip the new mount
			const mountToEquip = data.mounts.ownedMounts.find((mount) => mount.name === Mount);
			if (mountToEquip) {
				mountToEquip.equipped = true;
			}

			return true;
		});

		if (updateResult) {
			this.UnequipMount(player);

			const MountModel: Model = MountExists.Clone() as Model;

			player.SetAttribute("MountToggled", true);
			this.equippedMountData.set(player, {});

			if (MountModel) {
				this.equippedMountData.set(player, { Model: MountModel });
			}

			for (const motor of MountModel.GetDescendants()) {
				if (!motor.IsA("Motor6D") || !character.FindFirstChild(motor.Name)) {
					continue;
				}

				const Limb: BasePart = character.FindFirstChild(motor.Name) as BasePart;

				if (!motor.Part0) {
					motor.Part0 = Limb;
				} else {
					if (!motor.Part1) {
						motor.Part1 = Limb;
					}
				}
			}

			MountModel.Parent = character;
			let MountObject: ObjectValue = character.FindFirstChild("MountObject") as ObjectValue;
			if (!MountObject) {
				MountObject = new Instance("ObjectValue");
				MountObject.Name = "MountObject";
				MountObject.Parent = character;
			}
			MountObject.Value = MountModel;
		}
	}

	/**
	 * Unequips the currently equipped mount for the specified player.
	 * Removes the mount model from the game world, clears the player's mount data, and updates the datastore.
	 * @param player - The player whose mount should be unequipped
	 */
	public async UnequipMount(player: Player) {
		const character = player.Character || player.CharacterAdded.Wait()[0];
		const PlayerStore = this.dataservice.getPlayerStore();

		player.SetAttribute("MountToggled", undefined);

		const mountData = this.equippedMountData.get(player);
		if (mountData) {
			if (mountData.Model) {
				mountData.Model.Destroy();
			}
			this.equippedMountData.delete(player);
		}

		// Update datastore to unequip all mounts
		await PlayerStore.updateAsync(player, (data) => {
			data.mounts.ownedMounts.forEach((mount) => {
				mount.equipped = false;
			});
			return true;
		});
	}

	// Check if a player owns a specific mount
	public hasMount(player: Player, Mount: string): Promise<boolean> {
		const PlayerStore = this.dataservice.getPlayerStore();

		return PlayerStore.get(player)
			.andThen((data) => {
				if (!data) {
					return false;
				}

				const ownedMount = data.mounts.ownedMounts.find((mount) => mount.name === Mount);
				return ownedMount !== undefined && ownedMount.quantity > 0;
			})
			.catch(() => {
				return false;
			});
	}
}
