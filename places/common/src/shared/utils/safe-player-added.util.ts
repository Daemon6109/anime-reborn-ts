import { Players } from "@rbxts/services";

/**
 * Calls the given callback for all existing players in the game, and any that join thereafter.
 *
 * Useful in situations where you want to run code for every player, even players who are already in the game.
 */
export function safePlayerAdded(onPlayerAddedCallback: (player: Player) => void): RBXScriptConnection {
	// Handle existing players
	for (const player of Players.GetPlayers()) {
		task.spawn(() => onPlayerAddedCallback(player));
	}

	// Handle future players
	return Players.PlayerAdded.Connect(onPlayerAddedCallback);
}
