import dialogues from "@shared/configuration/dialogues-data.json";

export type DialoguesRegistry = typeof dialogues;
export type DialogueName = keyof DialoguesRegistry;
export type DialogueData = DialoguesRegistry[DialogueName];
export type DialogueTree = DialogueData["Trees"];

/**
 * All dialogues organized by their internal names
 */
export const DialoguesRegistry: DialoguesRegistry = dialogues;

/**
 * Helper functions for working with dialogues
 */
export namespace DialoguesData {
	/**
	 * Get dialogue data by name
	 */
	export function getDialogue(name: DialogueName): DialogueData | undefined {
		return DialoguesRegistry[name];
	}

	/**
	 * Get the dialogue trees for a specific dialogue
	 */
	export function getDialogueTrees(name: DialogueName): DialogueTree | undefined {
		return DialoguesRegistry[name]?.Trees;
	}

	/**
	 * Get the name of the character speaking in the dialogue
	 */
	export function getCharacterName(name: DialogueName): string | undefined {
		return DialoguesRegistry[name]?.Name;
	}
}
