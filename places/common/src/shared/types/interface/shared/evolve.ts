// Types
import type { Source } from "@rbxts/vide";
import type { Constant as ItemConstant } from "@shared/data/items-data";
import type { Constant as UnitConstant } from "@shared/data/units-data";

export default interface SharedEvolve {
	visible: Source<boolean>;

	kills: Source<number | undefined>;
	selectedUUID: Source<string | undefined>;
	requirments: Source<Array<UnitConstant | ItemConstant> | []>;
}
