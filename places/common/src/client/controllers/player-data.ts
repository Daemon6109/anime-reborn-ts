// Packages
import { Controller, OnStart } from "@flamework/core";
import ClientNetwork from "@network/client";
import CharmSync from "@rbxts/charm-sync";

// Charm Components
const { client } = CharmSync;

import atoms from "@shared/atoms";

const syncer = client({ atoms });

@Controller()
export class Interface implements OnStart {
	onStart() {
		ClientNetwork.playerData.sync.on((payload) => {
			// Type assertion to bypass the type mismatch
			// The server sends a Map but we expect a PlayerDataMap object
			syncer.sync(payload as never);
		});
		ClientNetwork.playerData.init.fire();
	}
}
