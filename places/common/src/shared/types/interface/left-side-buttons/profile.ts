// Types
import { Source } from "@rbxts/vide";

export default interface LeftSideProfile {
	visible: Source<boolean>;

	player: Source<Player | undefined>;

	titles: {
		visible: Source<boolean>;
	};

	inbox: {
		visible: Source<boolean>;
	};
}
