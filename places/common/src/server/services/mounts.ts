// mounts
--------------------------------------------------------------------------------

import { Network } from "@network/server";
import { Person } from "@commonserver/person";
import Shingo from "@pkgs/shingo";
import { loadModules } from "@commonutils/loadModules";
import { ReplicatedStorage, Players } from "@rbxts/services";

const version = { major: 1, minor: 0, patch: 0 };

// Get mounts registry from constants
const MountsRegistry = loadModules.fromChildren(ReplicatedStorage.Registry.Mounts) as Record<
	string,
	{ GetModel?: () => Model | Part }
>;

// Store equipped mount data for all players
const equippedMountData = new Map<Player, { Model: Model | Part | undefined }>();

// Events
const mountEquippedEvent = new Shingo<{ player: Player; mountName: string }>();
const mountUnequippedEvent = new Shingo<{ player: Player }>();

interface MountsDataCache {
	Inventory: {
		Mounts: {
			[key: string]: { Count: number } | undefined;
		};
	};
	EquippedMount?: string;
}

//[=[
//	Mount system for managing player mounts.
//
//	Provides functionality to give, equip, unequip, and toggle mounts for players.
//	Integrates with the Person class for data storage and the Blink Network system for networking.
//
//	@class Mounts
//]=]
const Mounts = {
	version: version,
	mountEquipped: mountEquippedEvent,
	mountUnequipped: mountUnequippedEvent,

	//[=[
	//	Gives a mount to a player.
	//
	//	@within Mounts
	//
	//	@param person Person -- The person to give the mount to
	//	@param mountName string -- The name of the mount
	//	@param amount number? -- The amount to give (defaults to 1)
	//
	//	```ts
	//	Mounts.giveMount(person, "DragonMount", 1);
	//	```
	//]=]
	giveMount(person: Person, mountName: string, amount?: number): void {
		if (!MountsRegistry[mountName]) {
			warn(`Invalid Mount ${mountName}`);
			return;
		}
		amount = amount ?? 1;
		person.dataCache((dataCache) => {
			const cache = dataCache as MountsDataCache;
			// Add mount to inventory
			const currentCount = cache.Inventory.Mounts[mountName]?.Count || 0;
			cache.Inventory.Mounts[mountName] = {
				Count: currentCount + amount,
			};
			return cache;
		});
	},

	//[=[
	//	Equips a mount for a player.
	//
	//	@within Mounts
	//
	//	@param person Person -- The person to equip the mount for
	//	@param mountName string -- The name of the mount to equip
	//
	//	@return boolean -- Whether the mount was successfully equipped
	//
	//	```ts
	//	const success = Mounts.equipMount(person, "DragonMount");
	//	```
	//]=]
	equipMount(person: Person, mountName: string): boolean {
		// Check if mount exists in registry
		const mountConfig = MountsRegistry[mountName];
		if (!mountConfig) {
			warn(`Mount ${mountName} not found in registry`);
			return false;
		}
		const player = person.player;
		const character = player.Character;
		if (!character) {
			return false;
		}
		// Check if player owns this mount
		const cache = person.dataCache() as MountsDataCache;
		const inventory = cache.Inventory;
		const mounts = inventory.Mounts;
		if (!mounts[mountName] || !mounts[mountName]!.Count || mounts[mountName]!.Count <= 0) {
			return false;
		}
		// Unequip current mount first
		Mounts.unequipMount(person);
		// Get mount model
		const mountModel = mountConfig.GetModel && mountConfig.GetModel();
		if (mountModel) {
			const newModel = mountModel.Clone();
			equippedMountData.set(player, { Model: newModel });
			// Attach mount to character
			for (const descendant of newModel.GetDescendants()) {
				if (descendant.IsA("Motor6D")) {
					const motor = descendant as Motor6D;
					const limb = character.FindFirstChild(motor.Name) as BasePart | undefined;
					if (!limb) continue;

					if (!motor.Part0) {
						motor.Part0 = limb;
					} else if (!motor.Part1) {
						motor.Part1 = limb;
					}
				}
			}
			newModel.Parent = character; // Create mount object reference in character
			let mountObject = character.FindFirstChild("MountObject") as ObjectValue | undefined;
			if (!mountObject) {
				const newMountObject = new Instance("ObjectValue");
				newMountObject.Name = "MountObject";
				newMountObject.Parent = character;
				mountObject = newMountObject;
			}
			if (mountObject) {
				mountObject.Value = newModel;
			}
		} else {
			warn(`Mount ${mountName} does not have a valid model`);
			return false;
		}
		// Update data cache
		person.dataCache((dataCache) => {
			(dataCache as MountsDataCache).EquippedMount = mountName;
			return dataCache;
		});
		// Fire event
		mountEquippedEvent.fire({ player: player, mountName: mountName });
		return true;
	},

	//[=[
	//	Unequips the currently equipped mount for a player.
	//
	//	@within Mounts
	//
	//	@param person Person -- The person to unequip the mount for
	//
	//	```ts
	//	Mounts.unequipMount(person);
	//	```
	//]=]
	unequipMount(person: Person): void {
		const player = person.player;
		const equippedData = equippedMountData.get(player);
		if (equippedData) {
			const mountModel = equippedData.Model;
			if (mountModel) {
				mountModel.Destroy();
			}
			equippedMountData.delete(player);
		}
		// Update data cache
		person.dataCache((dataCache) => {
			(dataCache as MountsDataCache).EquippedMount = ""; // Clear equipped mount (This will save as nil in the data since its the default value)
			return dataCache;
		});
		// Fire event
		mountUnequippedEvent.fire({ player: player });
	},

	//[=[
	//	Equips the mount that's saved in the player's data.
	//
	//	@private
	//
	//	@param person Person -- The person to equip the mount for
	//]=]
	equipMountFromData(person: Person): void {
		const cache = person.dataCache() as MountsDataCache;
		const equippedMount = cache.EquippedMount;

		if (equippedMount && equippedMount !== "") {
			Mounts.equipMount(person, equippedMount);
		}
	},
};

//[=[
//	Handles when a character is added - equips their saved mount.
//
//	@private
//
//	@param person Person -- The person whose character was added
//
//	```ts
//	_handleCharacterAdded(person);
//	```
//]=]
async function _handleCharacterAdded(person: Person): Promise<void> {
	await person.player.CharacterAppearanceLoaded.Wait(); // Wait for character to load
	Mounts.equipMountFromData(person);
}

//[=[
//	Starts the mounts system.
//
//	```ts
//	start();
//	```
//]=]
async function start(): Promise<void> {
	Network.EquipMount.on(async (player: Player, mountName: string) => {
		const person = await Person.getForPlayer(player);
		assert(person);
		Mounts.equipMount(person, mountName);
	});
	Network.UnequipMount.on(async (player: Player) => {
		const person = await Person.getForPlayer(player);
		assert(person);
		Mounts.unequipMount(person);
	});
}

//[=[
//	Initializes the mounts system.
//
//	```ts
//	init();
//	```
//]=]
function init(): void {
	// Set up character respawn handling
	Person.personAdded.Connect((person: Person) => {
		const player = person.player;
		player.CharacterAdded.Connect(() => {
			_handleCharacterAdded(person);
		});
		// Equip mount when character is already present
		if (player.Character) {
			_handleCharacterAdded(person);
		}
	});
	// Clean up when player leaves
	Person.personRemoved.Connect((person: Person) => {
		const player = person.player;
		const equippedData = equippedMountData.get(player);
		if (equippedData) {
			const mountModel = equippedData.Model;
			if (mountModel) {
				mountModel.Destroy();
			}
			equippedMountData.delete(player);
		}
	});
}

export default {
	version: version,

	// Functions
	init: init,
	start: start,
	equipMountFromData: Mounts.equipMountFromData,
	equipMount: Mounts.equipMount,
	unequipMount: Mounts.unequipMount,
	giveMount: Mounts.giveMount,

	// Events
	mountEquipped: mountEquippedEvent,
	mountUnequipped: mountUnequippedEvent,
};
