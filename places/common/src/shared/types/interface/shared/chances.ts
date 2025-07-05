// Types
import type * as Types from "@shared/types";
import type { Source } from "@rbxts/vide";

export default interface SharedChances {
	visible: Source<boolean>;

	closeCallback?: () => void;
	data: Source<
		| {
				items: Array<Types.InterfaceProps.PlayerData.Item.Constant>;
				units: Array<Types.InterfaceProps.PlayerData.Unit.Constant>;
		  }
		| undefined
	>;
}
