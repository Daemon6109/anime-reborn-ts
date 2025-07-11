import { ReplicatedStorage, Players } from "@rbxts/services";
import { safePlayerAdded } from "@shared/utils/safe-player-added.util";
import { Service, OnInit } from "@flamework/core";
import { DataStore } from "@server/services/player-data";
import { promiseR15 } from "@rbxts/character-promise";
import { Janitor } from "@rbxts/janitor";

const MountsRegistry: Folder = ReplicatedStorage.FindFirstChild("constants")?.FindFirstChild("Mounts") as Folder;

@Service()
export class MountsManager implements OnInit {
	private readonly equippedMounts = new Map<Player, Janitor>();
	private readonly serviceJanitor = new Janitor();

	constructor(private readonly dataservice: DataStore) {}

	onInit(): void {
		safePlayerAdded((player: Player) => {
			const characterPromise = promiseR15(player.Character || player.CharacterAdded.Wait()[0]);
			characterPromise.andThen((character) => this.onCharacterAdded(player));
		});

		const playerRemovingConnection = Players.PlayerRemoving.Connect((player) => {
			this.UnequipMount(player);
		});
		this.serviceJanitor.Add(playerRemovingConnection, "Disconnect");
	}

	private FindModel(name: string) {
		return MountsRegistry.FindFirstChild(name);
	}

	/**
	 * Checks if a player has any mounts equipped on character add.
	 * If the mount is marked as equipped in the player's data store, it equips it in-game when they first join.
	 */
	private onCharacterAdded(player: Player) {
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
	 */
	public async EquipMount(player: Player, Mount: string) {
		const character = player.Character ?? (await player.CharacterAdded.Wait())[0];
		const PlayerStore = this.dataservice.getPlayerStore();
		const MountExists = this.FindModel(Mount);

		this.cleanupEquippedMountModel(player);

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

		if (updateResult && MountExists) {
			const mountJanitor = new Janitor();
			this.equippedMounts.set(player, mountJanitor);

			const MountModel: Model = MountExists.Clone() as Model;
			mountJanitor.Add(MountModel, "Destroy");

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
			mountJanitor.Add(MountObject, "Destroy");
			MountObject.Value = MountModel;
		}
	}

	/**
	 * Unequips the currently equipped mount for the specified player.
	 * Removes the mount model from the game world, clears the player's mount data, and updates the datastore.
	 */
	public async UnequipMount(player: Player) {
		this.cleanupEquippedMountModel(player);

		// Update datastore to unequip all mounts
		const PlayerStore = this.dataservice.getPlayerStore();
		await PlayerStore.updateAsync(player, (data) => {
			data.mounts.ownedMounts.forEach((mount) => {
				mount.equipped = false;
			});
			return true;
		});
	}

	private cleanupEquippedMountModel(player: Player) {
		const mountJanitor = this.equippedMounts.get(player);
		if (mountJanitor) {
			mountJanitor.Cleanup();
			this.equippedMounts.delete(player);
		}
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
