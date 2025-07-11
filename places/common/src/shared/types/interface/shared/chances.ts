// Types
import type { Source } from "@rbxts/vide";
import type { Constant as ItemConstant } from "@shared/data/items-data";
import type { Constant as UnitConstant } from "@shared/data/units-data";

export default interface SharedChances {
	visible: Source<boolean>;

	closeCallback?: () => void;
	data: Source<
		| {
				items: Array<ItemConstant>;
				units: Array<UnitConstant>;
		  }
		| undefined
	>;
}
