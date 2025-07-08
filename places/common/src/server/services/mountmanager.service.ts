/* eslint-disable roblox-ts/lua-truthiness */
/** Mounts Manager
 * @Spirast
 */

import { ReplicatedStorage, ServerScriptService } from "@rbxts/services";
import { Service, OnInit } from "@flamework/core";
import { DataStore } from "@services/player-data";

const MountsRegistry: Folder = script.Parent?.Parent?.Parent.constants.Mounts; // also hallucinate this
let EquippedMountData = new Map<Player, { Model?: Model }>();

@Service()
export class MountsManager implements OnInit {
	constructor(private readonly dataservice: DataStore) {}

	// Initialization
	onInit(): void | Promise<void> {}

	private FindModel(name: string) {
		MountsRegistry.FindFirstChild(name);
	}

	// Give a player a mount
	public GiveMount(player: Player, Mount: string, amount?: number) {
		const PlayerProfile = this.dataservice.getPlayerStore();

		if (!amount) {
			amount = 1;
		}

		if (!MountsRegistry[Mount]) {
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
				});
				return true;
			}
		});
	}

	public EquipMount(player: Player, Mount: string) {
		const character = player.Character ?? player.CharacterAdded.Wait()[0];
		const PlayerStore = this.dataservice.getPlayerStore();

		// TODO: finish this

		this.UnequipMount(player);
		player.SetAttribute("MountToggled", true);
		EquippedMountData.set(player, {});

		if (MountModel) {
			const ClonedModel = MountModel.Clone();

			EquippedMountData.set(player, { Model: ClonedModel });

			for (const motor of ClonedModel.GetDescendants()) {
				if (!motor.IsA("Motor6D")) continue;

				const motorInstance = motor as Motor6D;
				const limb = character.FindFirstChild(motorInstance.Name);

				if (!motor.Part0) {
					motor.Part0 = limb;
				} else {
					if (!motor.Part1) {
						motor.Part1 = limb;
					}
				}

				ClonedModel.Parent = character;

				let MountObject: ObjectValue = character.FindFirstChild("MountObject");
				if (!MountObject) {
					MountObject = new Instance("ObjectValue");
					MountObject.Name = "MountObject";
					MountObject.Parent = character;
				}
				MountObject.Value = ClonedModel;
			}
		}
	}

	public UnequipMount(player: Player) {}
}
