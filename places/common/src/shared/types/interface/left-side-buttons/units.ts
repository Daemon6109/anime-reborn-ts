// Types
import { Source } from "@rbxts/vide";
import type { UnitData } from "@shared/data/units-data";

export default interface LeftSideUnits {
	visible: Source<boolean>;

	unitInfoVisible: Source<boolean>;

	selectedUUID: Source<string | undefined>;
	units: Source<UnitData[] | []>;
	evolve: Source<boolean>;

	closeCallback: Source<(() => void) | undefined>;

	filters: {
		search: Source<string | undefined>;
		category: Source<string | undefined>;
	};

	feed: {
		visible: Source<boolean>;
		selectedUUID: Source<string | undefined>;
	};

	sell: {
		value: Source<boolean>;
		selected: Source<Record<number, string | undefined>>;
	};

	fuse: {
		value: Source<boolean>;
		selected: Source<Record<number, string | undefined>>;
		anchor: Source<string | undefined>;
	};
}
