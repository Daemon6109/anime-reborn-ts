// Slotbar data factory
export interface Slotbar {
	UUID: string;
	UnitName: string;
	Traits: Record<number, string>;
	Relic: string;
	Skin: string;
	Level: number;
	XP: number;
	AbilityTree: Record<string, unknown>;
	StatsPotential: Record<string, unknown>;
	StatsTraining: Record<string, unknown>;
	Locked: boolean;
	Shiny: boolean;
}

export interface SlotbarData {
	Slot1: Slotbar;
	Slot2: Slotbar;
	Slot3: Slotbar;
	Slot4: Slotbar;
	Slot5: Slotbar;
	Slot6: Slotbar;
}

function createSlotbar(): Slotbar {
	return {
		UUID: "",
		UnitName: "",
		Traits: {
			1: "",
			2: "",
			3: "",
		},
		Relic: "",
		Skin: "",
		Level: 1,
		XP: 0,
		AbilityTree: {},
		StatsPotential: {},
		StatsTraining: {},
		Locked: false,
		Shiny: false,
	};
}

export function createSlotbarData(): SlotbarData {
	return {
		Slot1: createSlotbar(),
		Slot2: createSlotbar(),
		Slot3: createSlotbar(),
		Slot4: createSlotbar(),
		Slot5: createSlotbar(),
		Slot6: createSlotbar(),
	};
}
