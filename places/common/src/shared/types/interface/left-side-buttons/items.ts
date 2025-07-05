// Types
import { Source } from "@rbxts/vide";

export default interface LeftSideItems {
	visible: Source<boolean>;

	itemInfoVisible: Source<boolean>;

	filters: {
		search: Source<string | undefined>;
		category: Source<string | undefined>;
	};

	selectedUUID: Source<string | undefined>;
}
