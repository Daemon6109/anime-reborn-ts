// Types
import type { Source } from "@rbxts/vide";
import type * as Types from "@shared/types";

export default interface SharedChances {
	visible: Source<boolean>;

	kills: Source<number | undefined>;
	selectedUUID: Source<string | undefined>;
	requirments: Source<
		Array<Types.InterfaceProps.PlayerData.Unit.Constant | Types.InterfaceProps.PlayerData.Item.Constant> | []
	>;
}
